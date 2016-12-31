#!/bin/bash
## Enable Boot to Desktop and autologin
# obsolete due to pixel in raspbian jessie
#update-rc.d lightdm enable 2
#sed /etc/lightdm/lightdm.conf -i -e "s/^#autologin-user=.*/autologin-user=pi/"
#  if [ -e /etc/profile.d/boottoscratch.sh ]; then
#    rm -f /etc/profile.d/boottoscratch.sh
#    sed -i /etc/inittab \
#      -e "s/^#\(.*\)#\s*BTS_TO_ENABLE\s*/\1/" \
#      -e "/#\s*BTS_TO_DISABLE/d"
#    telinit q
#  fi
#  if [ -e /etc/profile.d/raspi-config.sh ]; then
#    rm -f /etc/profile.d/raspi-config.sh
#    sed -i /etc/inittab \
#      -e "s/^#\(.*\)#\s*RPICFG_TO_ENABLE\s*/\1/" \
#      -e "/#\s*RPICFG_TO_DISABLE/d"
#    telinit q
#  fi

# Change pi default password
echo "pi:pichannel" | sudo chpasswd

# Set CEC OSD Name
#cat << EOF | tee -a /boot/config.txt
# Set CEC name
#cec_osd_name=PI Channel
#
#hdmi_force_cec_name=PIChannel
#hdmi_ignore_cec_init=1
#EOF
## Install cec-utils
#sudo apt-get install cec-utils

# source raspi-config
source raspi-config nonint
# Change locale
echo "export LC_ALL=C" >> /root/.bashrc
echo "export LC_ALL=C" >> /home/pi/.bashrc
# Medium overclock if Model 1
# If Model = 1
if is_pione; then
        do_overclock "Medium"
else
        do_overclock "None"
fi
## change hostname
do_hostname "pichannel"
## Set GPU memory to 64
do_memory_split 128
## Expand rootfs
do_expand_rootfs
# update to latest raspbian
apt-get -y update -qq && apt-get -y dist-upgrade -qq \
&& apt-get -y autoremove && apt-get -y autoclean \
apt-get -y upgrade -qq
# Update firmware
apt-get -y install rpi-update -qq
rpi-update
## Remove update notification
rm /home/pi/.config/autostart/pi-conf-backup.desktop
## Reboot
reboot
