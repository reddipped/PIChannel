#!/bin/sh

# NEWMAILDIR received new maildir
# TMPPROCDIR tmp dir for processing new attachments
# MEDIA      destination dir for media files
# MEDIAMETA  meta-data file for media
# MAXPCTUSG  maximum allow percentage of diskspace

NEWMAILDIR=/home/pi/mail.mbox/new
TMPPROCDIR=/home/pi/processmail/tmp
MEDIA=/home/pi/pp_home/media
MEDIAMETA=/home/pi/pp_home/media-metadata
MAXPCTUSG=95
APPLEMOVEXT="*mov*"
IMGLIST="*jpg*jpeg*png*"

LANG=
LANGUAGE=
LC_CTYPE="POSIX"

# assure minimal free disk space
if [ -d ${MEDIAMETA} ] ;
then
  mkdir "${MEDIAMETA}"
fi
cp --force ${MEDIAMETA} ${MEDIAMETA}.TMP
while [ ${MAXPCTUSG} -lt $(df -h  ${MEDIA} | awk '{ print $5 }' | tail -1 | cut -d'%' -f1) ]
do
  removefile=$(ls -1 ${MEDIA} | sort | head -1)
  if [ ! -z "${removefile}" ] ;
  then
    rm "${MEDIA}/$removefile"
    cat ${MEDIAMETA}.TMP | grep -v "$removefile" > ${MEDIAMETA}.TMP
  fi
done
cp --force ${MEDIAMETA}.TMP ${MEDIAMETA}

# log status
status=`date +"%F at %T"`

# retrieve new mail
getmailresult=$(getmail --delete --all  2>&1 >/dev/null)

gmresult=$?

# if e-mail retrieved successfully
cp --force ${MEDIAMETA} ${MEDIAMETA}.TMP
if [ $gmresult -eq 0 -a ! -z "$(ls -A ${NEWMAILDIR})" ] ;
then
  imgcount=0
  # for each new received e-mail
  for file in ${NEWMAILDIR}/*
  do
    # extract supported attachments
    mu extract  --overwrite --target-dir=${TMPPROCDIR} "${file}" '.*(\.jpg|\.jpeg|\.png|\.mov|\.mp4)'
    # if attachments extracted successfully and tmp processing directory is not empty
    if [ $? -eq 0 -a ! -z "$(ls -A $TMPPROCDIR)" ] ;
    then
      # extract short message
      shortmessage=`mu view "${file}" --summary-len=1 | grep "^Subject" | sed 's/Subject: \(.*\)$/\1/'`

      # process all attachments, move all attachments to livetracks dir with timestamp filename
      for attach in ${TMPPROCDIR}/*
      do
        imgcount=$(($imgcount + 1))
        extension="${attach##*.}"
        # change extension of .mov files to .mp4
        if  echo $APPLEMOVEXT | grep -iq $extension ; then extension="mp4" ; fi
        medianame=$(date +%Y%m%d%H%M%S-%N).${extension}
        # fix orientation for images sent by smartphones
        if echo $IMGLIST | grep -iq $extension ;
	    then
        	convert -auto-orient "${attach}" "${MEDIA}/${medianame}"
        	rm -f "${attach}"
        else
            mv "${attach}" "${MEDIA}/${medianame}"
        fi
        echo ${medianame} ${shortmessage} >> ${MEDIAMETA}.TMP
      done
     fi
     rm -f $file
  done

  status="${status} success ${imgcount} new images retrieved"

  cp --force ${MEDIAMETA}.TMP ${MEDIAMETA}
  # Remove emoticons
  sed -i 's/[\d128-\d255]//g' ${MEDIAMETA}
  # Replace double by single quote
  sed -i 's/"/\x27/g' ${MEDIAMETA}
  /home/pi/processmail/rebuild_media.sh
  sudo /etc/init.d/lightdm restart
else
  if [ $gmresult -eq 0 ] ;
  then
    status="${status} success (no new mail)"
  else
    status="${status} failed ($getmailresult)"
  fi
fi

echo $status > /var/tmp/processmail.sts
