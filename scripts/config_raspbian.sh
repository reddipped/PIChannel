#!/bin/sh
# remove games
rm -rf /home/pi/python_games
# remove demo files
rm -rf /opt/vc/src/hello_pi
rm -rf /home/pi/ocr_pi.png
#Replace SSHD with dropbear
sudo apt-get -y install dropbear openssh-client
sudo /etc/init.d/ssh stop
sudo sed -i 's/NO_START=1/NO_START=0/' /etc/default/dropbear
sudo /etc/init.d/dropbear restart
sudo apt-get -y  purge openssh-server.* openssh-blacklist.*
# Auto remove dependencies
apt-get -y autoremove
# Set timezone
echo "Europe/Amsterdam" | tee /etc/timezone   
dpkg-reconfigure -f noninteractive tzdata
# Disable tty2-tty6
sed -i '/[2-6]:23:respawn:\/sbin\/getty 38400 \
tty[2-6]/s%^%#%g' /etc/inittab
# Enable preload
#apt-get install -y preload
#sed --in-place "s/sortstrategy = 3/sortstrategy = 0/g" \
#/etc/preload.conf
# Optimize mount
sed -i 's/defaults,noatime/defaults,noatime,nodiratime/g' \
/etc/fstab
## Disable IPv6
echo "net.ipv6.conf.all.disable_ipv6=1" | tee \
/etc/sysctl.d/disableipv6.conf
# disable Kernel module
echo 'blacklist ipv6' >> /etc/modprobe.d/blacklist
# Remove IPv6 hosts
sed -i '/::/s%^%#%g' /etc/hosts
## replace rsyslog
apt-get -y remove --purge rsyslog
# install syslog
apt-get -y install inetutils-syslogd
# stop syslogd
service inetutils-syslogd stop
# Remove old logs
for file in /var/log/*.log /var/log/mail.* /var/log/debug /var/log/syslog; do [ -f "$file" ] && rm -f "$file"; done
for dir in fsck news; do [ -d "/var/log/$dir" ] && rm -rf "/var/log/$dir"; done
# create syslog.conf
echo -e "*.*;mail.none;cron.none\t -/var/log/messages\ncron.*\t -/var/log/cron\nmail.*\t -/var/log/mail" > /etc/syslog.conf # config logrotate
mkdir -p /etc/logrotate.d
echo -e "/var/log/lightdm/*.log\n/var/log/lighttp/*.log\n/var/log/ntpstats/*log\n/var/log/apt/*.log\n/var/log/ConsoleKit/*.log\n/var/log/*.err\n/var/log/*warn\n/var/log/*info\n/var/log/faillog\n/var/log/*.log\n/var/log/wtmp\n/var/log/cron\n/var/log/mail\n/var/log/messages {\n\trotate 0\n\tdaily\n\tmissingok\n\tnotifempty\n\tcompress\n\tsharedscripts\n\tpostrotate\n\t/etc/init.d/inetutils-syslogd reload >/dev/null\n\tendscript\n}\n"  > /etc/logrotate.d/inetutils-syslogd
# start syslogd
service inetutils-syslogd start
# disable screen blanking 
sudo sed --in-place '/^exit 0/i setterm -blank 0' /etc/rc.local
# clean /var/tmp on boot
sudo sed --in-place '/^exit 0/i rm -rf /var/tmp/*' /etc/rc.local
