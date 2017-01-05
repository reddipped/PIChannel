#!/bin/sh
cd /var/tmp
apt-get -y install fbi
wget https://github.com/reddipped/PIChannel/raw/master/img/pichannel.png
wget https://github.com/reddipped/PIChannel/raw/master/scripts/aasplashscreen
cp aasplashscreen /etc/init.d/aasplashscreen
chmod u+x /etc/init.d/aasplashscreen
#sudo update-rc.d aasplashscreen defaults
insserv /etc/init.d/aasplashscreen
cp /var/tmp/pichannel.png /etc
cp /var/tmp/pichannel.png /etc/pichannelorg.png
# quiet boot mode
echo `cat /boot/cmdline.txt` quiet splash logo.nologo loglevel=3 | tee /var/tmp/cmdline.txt
cp /var/tmp/cmdline.txt /boot
sed --in-place "s/console=tty1/console=tty3/" /boot/cmdline.txt
# reboot to test
shutdown -r 0 now
