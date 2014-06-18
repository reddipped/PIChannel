#!/bin/sh
## Enable Boot to Desktop and autologin
update-rc.d lightdm enable 2
sed /etc/lightdm/lightdm.conf -i -e "s/^#autologin-user=.*/autologin-user=pi/"
  if [ -e /etc/profile.d/boottoscratch.sh ]; then
    rm -f /etc/profile.d/boottoscratch.sh
    sed -i /etc/inittab \
      -e "s/^#\(.*\)#\s*BTS_TO_ENABLE\s*/\1/" \
      -e "/#\s*BTS_TO_DISABLE/d"
    telinit q
  fi
  if [ -e /etc/profile.d/raspi-config.sh ]; then
    rm -f /etc/profile.d/raspi-config.sh
    sed -i /etc/inittab \
      -e "s/^#\(.*\)#\s*RPICFG_TO_ENABLE\s*/\1/" \
      -e "/#\s*RPICFG_TO_DISABLE/d"
    telinit q
  fi
## Modest overclock 800 250 400 0
sed  --in-place "s/^#\?.*arm_freq.*/arm_freq=800/" /boot/config.txt
sed  --in-place "s/^#\?.*core_freq.*/core_freq=250/" /boot/config.txt
sed  --in-place "s/^#\?.*sdram_freq.*/sdram_freq=400/" /boot/config.txt
sed  --in-place "s/^#\?.*over_voltage.*/over_voltage=0/" /boot/config.txt
## Set GPU memory to 64
sed  --in-place "s/^#\?.* gpu_mem.*/gpu_mem=64/" /boot/config.txt
## expand fs
raspi-config --expand-rootfs
## reboot
shutdown -r 0 now