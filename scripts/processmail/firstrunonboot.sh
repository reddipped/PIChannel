#!/bin/sh

if [ -f /var/tmp/pichannelboot.sts ] ; then
  rm -f /var/tmp/pichannelboot.sts
  /home/pi/processmail/rebuild_media.sh init
  sudo /etc/init.d/lightdm restart
fi
