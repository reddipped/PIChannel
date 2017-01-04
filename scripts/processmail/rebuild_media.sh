#!/bin/sh

# MEDIA      destination dir for media files
# MEDIAMETA  meta-data file for media
# MEDIAJSON  media json file in profile

MEDIA=/home/pi/pp_home/media
MEDIAMETA=/home/pi/pp_home/media-metadata
MEDIAJSON=/home/pi/pp_home/pp_profiles/livephoto/media.json
IMGLIST="*jpg*jpeg*png*"
MOVLIST="*mp4*"

# prevent concurrent running instances
if pidof -x "$0" -o $$ >/dev/null; then
    echo "Process already running"
    exit 1
fi

cat <<EOF > ${MEDIAJSON}.NEW
{
 "issue": "1.2",
 "tracks": [
EOF

## Present webinterface address on boot
_IP=$(hostname -I) || true
if [ "$1" = "init" ] && [ "$_IP" ] ;
then
  _IP=$(echo "${_IP}" | sed 's/[ \t]*$//')
  cat <<EOF >> ${MEDIAJSON}.NEW
{
 "animate-begin": "",
 "animate-clear": "no",
 "animate-end": "",
 "background-colour": "black",
 "background-image": "",
 "display-show-background": "no",
 "display-show-text": "yes",
 "duration": "",
 "image-window": "fit",
 "links": "",
 "location": "",
 "plugin": "",
 "show-control-begin": "",
 "show-control-end": "",
 "message-colour": "white",
 "message-font": "Helvetica 50 bold",
 "message-justify": "center",
 "message-x": "",
 "message-y": "",
 "text": "Management interface\n\n http://$_IP/index.py",
 "thumbnail": "",
 "title": "",
 "track-ref": "",
 "track-text": "",
 "track-text-colour": "white",
 "track-text-font": "Helvetica 22",
 "track-text-x": "60",
 "track-text-y": "10",
 "transition": "cut",
 "type": "message"
},
EOF
fi

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
   "background-colour": "black",
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
   "background-colour": "black",
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
