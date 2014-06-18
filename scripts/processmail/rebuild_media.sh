#!/bin/sh

# MEDIA      destination dir for media files
# MEDIAMETA  meta-data file for media
# MEDIAJSON  media json file in profile

MEDIA=/home/pi/pp_home/media
MEDIAMETA=/home/pi/pp_home/media-metadata
MEDIAJSON=/home/pi/pp_home/pp_profiles/livephoto/media.json
IMGLIST="*jpg*jpeg*png*"
MOVLIST="*mp4*"


cat <<EOF > ${MEDIAJSON}.NEW
{
 "issue": "1.2",
 "tracks": [
EOF

for file in $(ls -1r ${MEDIA}/*)
do
 filename=$(basename ${file})
 extension="${filename##*.}"
 shortmessage=`grep "${filename}" "${MEDIAMETA}" | eval sed 's/${filename}\\\s//'`
 if  echo $IMGLIST | grep -iq $extension ;
 then
 cat <<EOF >> ${MEDIAJSON}.NEW
  {
   "animate-begin": "",
   "animate-clear": "no",
   "animate-end": "",
   "background-colour": "",
   "background-image": "",
   "display-show-background": "no",
   "display-show-text": "yes",
   "duration": "",
   "image-window": "fit",
   "links": "",
   "location": "${MEDIA}/${filename}",
   "plugin": "",
   "show-control-begin": "",
   "show-control-end": "",
   "thumbnail": "",
   "title": "",
   "track-ref": "",
   "track-text": "${shortmessage}",
   "track-text-colour": "white",
   "track-text-font": "Helvetica 22",
   "track-text-x": "60",
   "track-text-y": "10",
   "transition": "cut",
   "type": "image"
  },
EOF
 fi

 if echo $MOVLIST | grep -iq $extension ;
 then
 cat <<EOF >> ${MEDIAJSON}.NEW
  {
   "animate-begin": "",
   "animate-clear": "no",
   "animate-end": "",
   "background-colour": "",
   "background-image": "",
   "display-show-background": "no",
   "display-show-text": "yes",
   "links": "",
   "location": "${MEDIA}/${filename}",
   "omx-audio": "hdmi",
   "omx-volume": "",
   "omx-window": "",
   "plugin": "",
   "show-control-begin": "",
   "show-control-end": "",
   "thumbnail": "",
   "title": "",
   "track-ref": "",
   "track-text": "",
   "track-text-colour": "grey",
   "track-text-font": "Helvetica 30",
   "track-text-x": "40",
   "track-text-y": "1040",
   "type": "video"
  },
EOF
  fi

done

cat <<EOF >> ${MEDIAJSON}.NEW
 ]
}
EOF

sed --in-place 'N; s/},\n\s]/}\n ]/' ${MEDIAJSON}.NEW

cp --force ${MEDIAJSON}.NEW ${MEDIAJSON}
