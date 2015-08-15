#!/bin/sh
# Configure wlan interface
cat <<EOF | tee -a /etc/network/interfaces 
iface wlan0 inet dhcp
wpa-ssid WIFISSID
wpa-psk WIFIPSK
EOF
sed --in-place "1i auto wlan0" /etc/network/interfaces
sed --in-place "s/^\(iface wlan0 inet manual.*\)/#\1/" \
 /etc/network/interfaces
sed --in-place "s/^\(wpa-roam.*\)/#\1/" /etc/network/interfaces
sed --in-place "s/^\(iface default.*\)/#\1/" /etc/network/interfaces
# set hostname
echo "pichannel" | sudo tee /etc/hostname
# create wifi monitoring script to prevent disconnect
mkdir /root/scripts
cat <<EOF2 > /root/scripts/wifimonitor.sh
#!/bin/sh

if ! ifconfig wlan0 | grep -q "inet addr:" ; then
  echo "Network connection down! Attempting reconnection."
  /sbin/ifup --force wlan0
fi
EOF2
chmod u+x /root/scripts/wifimonitor.sh
# schedule wifimonitor.sh in crontab
(crontab -l; echo "1 * * * * /root/scripts/wifimonitor.sh" ) \
| crontab -
# disable power management
cat <<EOF3 >/etc/modprobe.d/8192cu.conf
# Disable power management
options 8192cu rtw_power_mgnt=0 rtw_enusbss=0
EOF3