#!/bin/sh
# remove to save upgrade
apt-get -y remove wolfram-engine smbclient samba-common
# update to latest raspbian
apt-get -y update && apt-get -y dist-upgrade \
&& apt-get -y autoremove && apt-get -y autoclean \
apt-get -y upgrade
# Update firmware
apt-get -y install curl
curl -L --output /usr/bin/rpi-update https://raw.github.com/Hexxeh/rpi-update/master/rpi-update && chmod +x /usr/bin/rpi-update
rpi-update
shutdown -r 0 now
