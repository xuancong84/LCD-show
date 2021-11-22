#!/bin/bash

if [ "`ls .system_backup/`" ]; then
	n=0
	while [ 1 ]; do
		if [ ! -e .system_backup.$n ]; then break; fi
		n=$[n+1]
	done
	sudo mv .system_backup .system_backup.$n
fi

sudo mkdir -p .system_backup

if [ -f /etc/X11/xorg.conf.d/99-calibration.conf ]; then
sudo cp -rf /etc/X11/xorg.conf.d/99-calibration.conf ./.system_backup
fi

if [ -f /etc/X11/xorg.conf.d/40-libinput.conf ]; then
sudo cp -rf /etc/X11/xorg.conf.d/40-libinput.conf ./.system_backup
fi

if [ -d /etc/X11/xorg.conf.d ]; then
sudo cp -rf /etc/X11/xorg.conf.d ./.system_backup/
fi

result=`grep -rn "^dtoverlay=" /boot/config.txt | grep ":rotate=" | tail -n 1`
if [ $? -eq 0 ]; then
str=`echo -n $result | awk -F: '{printf $2}' | awk -F= '{printf $NF}'`
if [ -f /boot/overlays/$str-overlay.dtb ]; then
sudo cp -rf /boot/overlays/$str-overlay.dtb ./.system_backup
fi
if [ -f /boot/overlays/$str.dtbo ]; then
sudo cp -rf /boot/overlays/$str.dtbo ./.system_backup
fi
fi

root_dev=`grep -oPr "root=[^\s]*" /boot/cmdline.txt | awk -F= '{printf $NF}'`
sudo cp -rf /boot/config.txt .system_backup/
sudo cp -rf /boot/cmdline.txt .system_backup/
if [ -f /usr/share/X11/xorg.conf.d/99-fbturbo.conf ]; then
sudo cp -rf /usr/share/X11/xorg.conf.d/99-fbturbo.conf ./.system_backup/
fi
sudo cp -rf ./usr/99-fbturbo.conf-original /usr/share/X11/xorg.conf.d/99-fbturbo.conf
sudo cp -rf /etc/rc.local ./.system_backup/
sudo cp -rf ./etc/rc.local-original /etc/rc.local

sudo cp -rf /etc/modules ./.system_backup/
sudo cp -rf ./etc/modules-original /etc/modules

if [ -f /etc/modprobe.d/fbtft.conf ]; then
sudo cp -rf /etc/modprobe.d/fbtft.conf ./.system_backup
fi

if [ -f /etc/inittab ]; then
sudo cp -rf /etc/inittab ./.system_backup
fi

type fbcp > /dev/null 2>&1
if [ $? -eq 0 ]; then
sudo cp -rf /usr/local/bin/fbcp .system_backup/fbcp
fi

#type cmake > /dev/null 2>&1
#if [ $? -eq 0 ]; then
#sudo touch ./.system_backup/have_cmake
#sudo apt-get purge cmake -y 2> error_output.txt
#result=`cat ./error_output.txt`
#echo -e "\033[31m$result\033[0m"
#fi

if [ -f /usr/share/X11/xorg.conf.d/10-evdev.conf ]; then
sudo cp -rf /usr/share/X11/xorg.conf.d/10-evdev.conf ./.system_backup
sudo dpkg -P xserver-xorg-input-evdev
#sudo apt-get purge xserver-xorg-input-evdev -y  2> error_output.txt
#result=`cat ./error_output.txt`
#echo -e "\033[31m$result\033[0m"
fi

if [ -f /usr/share/X11/xorg.conf.d/45-evdev.conf ]; then
sudo cp -rf /usr/share/X11/xorg.conf.d/45-evdev.conf ./.system_backup
fi

if [ -f ./.have_installed ]; then
sudo cp -rf ./.have_installed ./.system_backup
fi
