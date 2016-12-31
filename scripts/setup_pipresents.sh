#!/bin/sh
sudo apt-get -y update
sudo apt-get -y install python-tk
sudo apt-get -y install python-imaging
sudo apt-get -y install python-imaging-tk
sudo apt-get -y install x11-xserver-utils
sudo apt-get -y install unclutter
sudo apt-get -y install mplayer
sudo apt-get -y install uzbl
sudo apt-get -y install omxplayer
# Install pexpect
cd ~
wget http://pexpect.sourceforge.net/pexpect-2.3.tar.gz
tar xzf pexpect-2.3.tar.gz
cd pexpect-2.3
sudo python ./setup.py install
# install pipresents
# sudo apt-get -y install gnome-keyring
cd ~
rm -rf KenT2-pipresents*
wget https://github.com/KenT2/pipresents-next/tarball/master -O - | tar xz
mv KenT2-pipresents-next-* pipresents
cp -r ~/pipresents/pp_home ~/pp_home
rm -rf ~/pp_home/pp_profiles/*
mkdir /home/pi/pp_home/pp_profiles/livephoto
cd ~/pp_home/pp_profiles/livephoto
wget https://raw.githubusercontent.com/reddipped/PIChannel/master/pichannel/gpio.cfg
wget https://raw.githubusercontent.com/reddipped/PIChannel/master/pichannel/media.json
wget https://raw.githubusercontent.com/reddipped/PIChannel/master/pichannel/pp_showlist.json
wget https://raw.githubusercontent.com/reddipped/PIChannel/master/pichannel/resources.cfg
mkdir ~/pp_home/media
# prepare auto start
cd /var/tmp
wget https://raw.githubusercontent.com/reddipped/PIChannel/master/scripts/pipresents.desktop
mkdir -p /home/pi/.config/autostart
cp /var/tmp/pipresents.desktop /home/pi/.config/autostart
