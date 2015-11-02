#!/bin/sh
# install lxde-core components and lightdm
## Cleanup desktop
rm -rf ~/Desktop/*
cp ~/.config/lxpanel/LXDE/panels/panel \
/var/tmp/panel.bkp
cat <<EOF2 | tee ~/.config/lxpanel/LXDE/panels/panel
Global {
    edge=bottom
    allign=left
    margin=0
    widthtype=percent
    width=0
    height=0
    transparent=1
    tintcolor=#000000
    alpha=0
    autohide=0
    heightwhenhidden=0
    setdocktype=0
    setpartialstrut=0
    usefontcolor=1
    fontsize=10
    fontcolor=#8b8b8b
    usefontsize=0
    background=0
    backgroundfile=
    iconsize=24
}
EOF2
sed --in-place "s/wallpaper_mode.*/wallpaper_mode=0/g" \
/home/pi/.config/pcmanfm/LXDE/pcmanfm.conf
sed --in-place "s/wallpaper=.*/wallpaper=/g" \
/home/pi/.config/pcmanfm/LXDE/pcmanfm.conf
sed --in-place "s/desktop_bg=.*/desktop_bg=#000000/g" \
/home/pi/.config/pcmanfm/LXDE/pcmanfm.conf
sed --in-place "s/show_trash=.*/show_trash=0/g" \
/home/pi/.config/pcmanfm/LXDE/pcmanfm.conf
####apt-get -y remove pcmanfm
## Disable screenblanking and screensaver
sudo sed --in-place '/#!\/bin\/sh/a\# Disable screenblanking\n\xset s off\n\xset -dpms\n\xset s noblank' /etc/X11/xinit/xinitrc
sudo sed --in-place 's/^#xserver-command=X/xserver-command=X -s 0 -dpms/' /etc/lightdm/lightdm.conf
## Disable mousepointer
sudo sed  --in-place 's/^\(exec.*\/usr\/bin\/X.*\)/\1 -nocursor/' /etc/X11/xinit/xserverrc

