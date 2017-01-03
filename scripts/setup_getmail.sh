#/bin/sh
sudo apt-get -y install imagemagick
sudo apt-get -y install getmail4
mkdir ~/.getmail
cd ~/.getmail
wget https://github.com/reddipped/PIChannel/raw/master/scripts/processmail/getmailrc
mkdir -p ~/mail.mbox/new
mkdir -p ~/mail.mbox/cur
mkdir -p ~/mail.mbox/tmp
# install mailutils
sudo apt-get -y install maildir-utils
# install mail processing
mkdir -p ~/processmail/tmp
# create processmail.sh script
cd ~/processmail
wget https://github.com/reddipped/PIChannel/raw/master/scripts/processmail/processmail.sh
wget https://github.com/reddipped/PIChannel/raw/master/scripts/processmail/rebuild_media.sh
wget https://github.com/reddipped/PIChannel/raw/master/scripts/processmail/firstrunonboot.sh
chmod u+x ~/processmail/*.sh
# schedule mail retrieval and processing
(crontab -l; \
echo "*/5 * * * * /home/pi/processmail/processmail.sh" ) \
| crontab -
# create empty status file
touch /var/tmp/processmail.sts
# rebuild presentation on boot
sudo sed --in-place '/^exit 0/i sudo -u pi touch /var/tmp/pichannelboot.sts &' /etc/rc.local
# create processmail.sts on boot
sudo sed --in-place '/^exit 0/i sudo -u pi touch /var/tmp/processmail.sts &' /etc/rc.local
# add firstrononboot to /etc/xdg/lxsession/LXDE/autostart
sudo sh -c 'echo "@/bin/sh /home/pi/processmail/firstrunonboot.sh" >> /etc/xdg/lxsession/LXDE/autostart'
