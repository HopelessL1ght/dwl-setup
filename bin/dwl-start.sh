#!/bin/bash

# Kill already running dublicate process
_ps="waybar mako swaybg"
for _prs in $_ps; do
    if [ "$(pidof "${_prs}")" ]; then
         killall -9 "${_prs}"
    fi
 done

# Start our applications
#swaybg --output 'DP-1' --mode center  --image /home/ryan/Pictures/wallpapers/coolwall.png &
#swaybg --output 'DP-2' --mode center  --image /home/ryan/Pictures/wallpapers/coolwall.png &
swaybg --output '*' --mode center  --image /home/ryan/Pictures/wallpapers/centermoon.jpg &
wlr-randr --output DP-2 --mode 2560x1440@164.998993Hz --output DP-1 --mode 2560x1440@239.998001Hz &
nm-applet &
dunst &
mako &
waybar &
foot --server &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/home/ryan/.local/bin/autowallpaper.sh &

for portal in xdg-desktop-portal-gtk xdg-desktop-portal-wlr xdg-desktop-portal; do
   pkill -e "$portal"
done

# Start xdg-desktop-portal-wlr and xdg-desktop-portal-gtk
/usr/lib/xdg-desktop-portal-wlr &
/usr/lib/xdg-desktop-portal-gtk &

sleep 1

# Start main xdg-desktop-portal
/usr/lib/xdg-desktop-portal &

 exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots
