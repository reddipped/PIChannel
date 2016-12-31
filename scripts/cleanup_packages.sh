#!/bin/sh
# remove to save upgrade
# Get list of installed packages using  dpkg --get-selections
apt-get -y purge wolfram-engine smbclient samba-common penguinspuzzle minecraft-pi \
python-pygame pixel-wallpaper Epiphany chromium-browser samba-libs:armhf squeak-vm \
realvnc-vnc-server realvnc-vnc-viewer nuscratch samba-libs:armhf \
ruby oracle-java8-jdk nodejs
# update to latest raspbian
#apt-get -y update && apt-get -y dist-upgrade \
#&& apt-get -y autoremove && apt-get -y autoclean \
#apt-get -y upgrade
# Update firmware
#apt-get -y install rpi-update
#rpi-update
# Clean up
sudo apt-get clean
# Disable update notitifier messages
#sed --in-place
#/etc/apt/apt.conf.d/99update-notifier

reboot
