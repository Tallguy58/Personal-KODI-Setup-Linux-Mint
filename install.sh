#!/usr/bin/env bash

currentuser=$(users | awk '{print $1}')

function run-in-user-session() {
    _display_id=":$(find /tmp/.X11-unix/* | sed 's#/tmp/.X11-unix/X##' | head -n 1)"
    _username=$(who | grep "($_display_id)" | awk '{print $1}')
    _user_id=$(id -u "$_username")
    _environment=("DISPLAY=$_display_id" "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$_user_id/bus")
    sudo -Hu "$_username" env "${_environment[@]}" "$@"
}

install-package() {
if ! dpkg -s $1 >/dev/null 2>&1; then
    echo -e '\033[1;33mInstalling \033[1;32m'$1' \033[0m\c'
    apt-get -y -qq install $1 >/dev/null
    echo -e '\033[1;36m... OK\033[0m'
fi
}

function get-perl() {
echo -e '\033[1;33mInstalling \033[1;34mPerl\033[0m'
install-package perl
install-package libnet-ssleay-perl
install-package libauthen-pam-perl
install-package libio-pty-perl
}

function get-samba() {
echo -e '\033[1;33mInstalling \033[1;34mSMB File Sharing\033[0m'
apt-get -y -qq install samba --install-recommends >/dev/null
install-package samba-common-bin
install-package samba-dsdb-modules
install-package samba-libs
install-package samba-vfs-modules
install-package smbclient
install-package autofs
install-package cifs-utils
install-package caja-share
install-package libsmbclient0
install-package libwbclient0
install-package winbind
install-package libnss-winbind
mkdir -p /etc/samba
cp -f files/smb.conf /etc/samba
touch /etc/libuser.conf
chmod 0777 -Rf /var/lib/samba/usershares
files=$(ls -1 /var/lib/samba/usershares)
if [ "$files" != """" ]; then
  rm -f /var/lib/samba/usershares/*
fi
run-in-user-session net usershare add Shared_Media /mnt/shared_media "Media Centre" Everyone:F guest_ok=y
}

function get-kodi() {
echo -e '\033[1;33mInstalling \033[1;34mKODI Media Centre\033[0m'
flatpak install -y --noninteractive flathub tv.kodi.Kodi
echo -e "[SeatDefaults]\nuser-session=cinnamon\nsession-setup-script=/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=kodi tv.kodi.Kodi --standalone">/etc/lightdm/lightdm.conf.d/70-linuxmint.conf

## Keymap settings...
mkdir -p /home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/
touch /home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '<keymap>'>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '  <global>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '    <keyboard>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <b>noop</b>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <backslash>noop</backslash>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <d>noop</d>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <e>noop</e>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <equals>noop</equals>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <g>noop</g>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <h>noop</h>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <k>noop</k>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <minus>noop</minus>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <numpadminus>noop</numpadminus>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <numpadplus>noop</numpadplus>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <t>noop</t>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <tab>noop</tab>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <plus>noop</plus>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <v>noop</v>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <volume_mute>noop</volume_mute>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <volume_down>noop</volume_down>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <volume_up>noop</volume_up>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '      <y>noop</y>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '    </keyboard>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '  </global>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
echo -e '</keymap>'>>/home/$currentuser/.var/app/tv.kodi.Kodi/data/userdata/keymaps/keyboard.xml
}

function get-php() {
echo -e '\033[1;33mInstalling \033[1;34mApache\033[0m'
install-package apache2
echo -e '\033[1;33mInstalling \033[1;34mPHP 7.4\033[0m'
add-apt-repository -y ppa:ondrej/php
apt-get -y -qq update >/dev/null
install-package php7.4
install-package php7.4-cli
install-package php7.4-json
install-package php7.4-common
install-package php7.4-mysql
install-package php7.4-zip
install-package php7.4-gd
install-package php7.4-mbstring
install-package php7.4-curl
install-package php7.4-xml
install-package php7.4-bcmath
install-package php7.4-opcache
install-package php7.4-fpm
install-package php7.4-intl
install-package php7.4-xml
install-package php7.4-bz2
install-package php7.4-cgi
install-package libapache2-mod-php7.4
a2enmod php7.4
update-alternatives --set php /usr/bin/php7.4
update-alternatives --set phar /usr/bin/phar7.4
update-alternatives --set phar.phar /usr/bin/phar.phar7.4
chmod -Rf 0777 /var/www/html
rm -r -f /var/www/html/*
unzip -o -q files/navphp4.45.zip -d/var/www/html
echo -e 'php_value upload_max_filesize 4.0G'>/var/www/html/.htaccess
echo -e 'php_value post_max_size 4.2G'>>/var/www/html/.htaccess
echo -e 'php_value memory_limit -1'>>/var/www/html/.htaccess
sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
sed -i 's/Restart=on-abort/Restart=always/g' /lib/systemd/system/apache2.service
systemctl -q enable apache2
}

function get-krusader() {
echo -e '\033[1;33mInstalling \033[1;34mKrusader Twin File Browser\033[0m'
install-package krusader
install-package libc6
install-package libgcc-s1
install-package zlib1g
install-package cpio
install-package konsole
install-package okteta
install-package rpm
echo -e '\033[1;33mInstalling \033[1;34mKrusader Twin File Browser\033[1;36m - Tools\033[0m'
install-package kdiff3
install-package kget
install-package kompare
install-package krename
install-package hashdeep
install-package kmail
echo -e '\033[1;33mInstalling \033[1;34mKrusader Twin File Browser\033[1;36m - Archivers\033[0m'
install-package arj
install-package ark
install-package bzip2
install-package lhasa
install-package p7zip
install-package rar
install-package unace
install-package unrar
install-package unzip
install-package zip
cp -f /usr/share/applications/org.kde.krusader.desktop /home/$currentuser/Desktop
sed -i "s/Exec=krusader -qwindowtitle %c %u/Exec=krusader -qwindowtitle %c %u --left='\/media\/$currentuser\/' --right='\/mnt\/shared_media\/'/g" /home/$currentuser/Desktop/org.kde.krusader.desktop
}

function get-conky() {
echo -e '\033[1;33mInstalling \033[1;34mConky\033[0m'
install-package conky-all
cp -f files/conky.conf /home/$currentuser/.conkyrc
echo -e '[Desktop Entry]'>/home/$currentuser/.config/autostart/conky.desktop
echo -e 'Type=Application'>>/home/$currentuser/.config/autostart/conky.desktop
echo -e 'Exec=/usr/bin/conky -d'>>/home/$currentuser/.config/autostart/conky.desktop
echo -e 'X-GNOME-Autostart-enabled=true'>>/home/$currentuser/.config/autostart/conky.desktop
echo -e 'NoDisplay=false'>>/home/$currentuser/.config/autostart/conky.desktop
echo -e 'Hidden=false'>>/home/$currentuser/.config/autostart/conky.desktop
echo -e 'Name[en_AU]=Conky'>>/home/$currentuser/.config/autostart/conky.desktop
echo -e 'Comment[en_AU]=System information tool'>>/home/$currentuser/.config/autostart/conky.desktop
echo -e 'X-GNOME-Autostart-Delay=5'>>/home/$currentuser/.config/autostart/conky.desktop
## HDSentinel
wget -qO /tmp/hdsentinel.zip https://www.hdsentinel.com/hdslin/hdsentinel-020c-x64.zip
unzip -oq /tmp/hdsentinel.zip -d /tmp
mv -f /tmp/HDSentinel /bin/hdsentinel
rm -f /tmp/hdsentinel.zip
chmod 0777 -f /bin/hdsentinel
if ! grep -Fxq $currentuser" ALL=NOPASSWD: /bin/hdsentinel" /etc/sudoers
then
    echo $currentuser" ALL=NOPASSWD: /bin/hdsentinel">>/etc/sudoers
fi
if ! grep -Fxq $currentuser" ALL=NOPASSWD: /usr/bin/lshw" /etc/sudoers
then
    echo $currentuser" ALL=NOPASSWD: /usr/bin/lshw">>/etc/sudoers
fi
if ! grep -Fxq $currentuser" ALL=NOPASSWD: /usr/sbin/dmidecode" /etc/sudoers
then
    echo $currentuser" ALL=NOPASSWD: /usr/sbin/dmidecode">>/etc/sudoers
fi
}

function get-SimpleHTTPServerWithUpload() {
echo -e '\033[1;33mInstalling \033[1;34mSimple HTTP Service with Upload\033[0m'
cp -f files/SimpleHTTPServerWithUpload.py /bin
chmod +x -f /bin/SimpleHTTPServerWithUpload.py
## Create BASH Script
echo -e '#!/bin/bash'>/bin/SimpleHTTPServerWithUpload.sh
echo -e 'clear'>>/bin/SimpleHTTPServerWithUpload.sh
echo -e 'cd /mnt/shared_media'>>/bin/SimpleHTTPServerWithUpload.sh
echo -e 'python3 /bin/SimpleHTTPServerWithUpload.py 8080'>>/bin/SimpleHTTPServerWithUpload.sh
## Create Service
echo -e '[Unit]'>/lib/systemd/system/SimpleHTTPServerWithUpload.service
echo -e 'Description=Simple HTTP Server With Upload'>>/lib/systemd/system/SimpleHTTPServerWithUpload.service
echo -e '[Service]'>>/lib/systemd/system/SimpleHTTPServerWithUpload.service
echo -e 'ExecStart=/bin/SimpleHTTPServerWithUpload.sh'>>/lib/systemd/system/SimpleHTTPServerWithUpload.service
echo -e 'Restart=Always'>>/lib/systemd/system/SimpleHTTPServerWithUpload.service
echo -e '[Install]'>>/lib/systemd/system/SimpleHTTPServerWithUpload.service
echo -e 'WantedBy=multi-user.target'>>/lib/systemd/system/SimpleHTTPServerWithUpload.service
## Change Permissions
chmod +x -f /bin/SimpleHTTPServerWithUpload.sh
chmod 0644 -f /lib/systemd/system/SimpleHTTPServerWithUpload.service
systemctl -q enable SimpleHTTPServerWithUpload
}

function get-clamav() {
echo -e '\033[1;33mInstalling \033[1;34mClam Anti-Virus\033[0m'
install-package clamav
install-package clamav-daemon
install-package clamav-freshclam
install-package clamtk
}

function fix-desktop-error() {
if [ -f /usr/share/applications/org.kde.kdeconnect_open.desktop ]; then
	if ! grep -Fxq 'MimeType=application/octet-stream;' /usr/share/applications/org.kde.kdeconnect_open.desktop
	then
		echo -e '\033[1;31mFixing Desktop Database...\033[0m'
		sed -i '/MimeType=/c\MimeType=application\/octet-stream;' /usr/share/applications/org.kde.kdeconnect_open.desktop
		update-desktop-database
	fi
fi
}

function bootdrivelabel() {
   echo -e '\033[1;31mSetting Boot Hard Disc Drive Label\033[0m'
   dev=$(findmnt -T / -n -o source | head -1)
   e2label $dev 'Linux Mint'
}

function desktop-settings() {
echo -e '\033[1;33mUpdating   \033[1;34mDesktop Themes And Settings...\033[0m'
# Desktop Icon Settings
run-in-user-session dconf write /org/nemo/desktop/computer-icon-visible "true"
run-in-user-session dconf write /org/nemo/desktop/home-icon-visible "true"
run-in-user-session dconf write /org/nemo/desktop/network-icon-visible "true"
run-in-user-session dconf write /org/nemo/desktop/show-orphaned-desktop-icons "false"
run-in-user-session dconf write /org/nemo/desktop/trash-icon-visible "true"
run-in-user-session dconf write /org/nemo/desktop/volumes-visible "false"
# Desktop Background Settings
run-in-user-session dconf write /org/cinnamon/desktop/background/slideshow/delay 5
run-in-user-session dconf write /org/cinnamon/desktop/background/slideshow/slideshow-enabled "true"
run-in-user-session dconf write /org/cinnamon/desktop/background/slideshow/random-order "true"
run-in-user-session dconf write /org/cinnamon/desktop/background/slideshow/image-source "'xml:///usr/share/cinnamon-background-properties/linuxmint-wallpapers.xml'"
#Screen Saver
run-in-user-session dconf write /org/cinnamon/desktop/session/idle-delay "uint32 0"
run-in-user-session dconf write /org/cinnamon/desktop/screensaver/lock-enabled "false"
run-in-user-session dconf write /org/cinnamon/desktop/screensaver/show-notifications "false"
# Power Management
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/sleep-display-ac 0
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/sleep-inactive-ac-timeout 0
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/button-power "'shutdown'"
run-in-user-session dconf write /org/cinnamon/settings-daemon/plugins/power/lock-on-suspend "false"
# Themes
run-in-user-session dconf write /org/cinnamon/desktop/wm/preferences/theme "'Mint-Y-Dark'"
run-in-user-session dconf write /org/cinnamon/desktop/wm/preferences/theme-backup "'Mint-Y-Dark'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/icon-theme "'hi-color'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/icon-theme-backup "'hi-color'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/gtk-theme "'Adwaita-dark'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/gtk-theme-backup "'Adwaita-dark'"
run-in-user-session dconf write /org/cinnamon/desktop/interface/cursor-theme "'DMZ-White'"
run-in-user-session dconf write /org/cinnamon/theme/name "'Adapta-Nokto'"
# Time / Date
run-in-user-session dconf write /org/cinnamon/desktop/interface/clock-show-date "true"
run-in-user-session dconf write /org/cinnamon/desktop/interface/clock-show-seconds "true"
run-in-user-session dconf write /org/cinnamon/desktop/interface/clock-use-24h "false"
}

## START INSTALLATION ##
history -c
reset
wmctrl -r :ACTIVE: -e 0,50,50,1500,800
xset s off noblank -dpms
echo -e '\033[1;33mInstalling \033[1;34mCommon Utilities\033[0m'
install-package software-properties-common
install-package default-jre
install-package gedit
install-package libc6
install-package libgd3
install-package deborphan
install-package lsscsi
install-package moreutils
install-package pavucontrol
install-package ntfs-3g
install-package nmap
install-package openssl
install-package libpam-runtime
install-package gdebi
install-package openssh-server

## FIND MEDIA FILES ON NTFS DRIVE AND CREATE AN FSTAB MOUNT ENTRY.
mkdir -p /mnt/shared_media
dev=$(findmnt -t fuseblk -n -o source | head -1)
if [ -z "${dev}" ]; then
	dev=$(findmnt -t ntfs3 -n -o source | head -1)
fi
if [ -n "${dev}" ]; then
    echo -e $dev' is mounted as /mnt/shared_media'
    uuid=$(blkid -s UUID $dev | cut -f2 -d':' | cut -c2-)
    mountline=$uuid' /mnt/shared_media auto nosuid,nodev,nofail 0 0'
    if ! grep -Fxq $uuid' /mnt/shared_media auto nosuid,nodev,nofail 0 0' /etc/fstab
    then
        echo $mountline>>/etc/fstab
    fi
else
	echo -e '\033[1;31mShared Media Drive not located!\033[0m'
fi

# Start Process...
get-perl
get-samba
get-kodi
get-php
get-krusader
get-conky
get-SimpleHTTPServerWithUpload
get-clamav
fix-desktop-error
bootdrivelabel
desktop-settings

## login interactively without entering your password
groupadd -r nopasswdlogin
groupadd -r autologin
gpasswd -a $currentuser nopasswdlogin
gpasswd -a $currentuser autologin
## Fix autologin greeter
echo -e "[Seat:*]\nautologin-guest=false\ngreeter-show-manual-login=false\ngreeter-hide-users=false\ngreeter-session=lightdm-slick-greeter\nautologin-user="$currentuser"\nautologin-user-timeout=0">/etc/lightdm/lightdm.conf

## Change Hostname
echo "MEDIAPC">/etc/hostname

## Change IP Address/Default Gateway of Network adapter
netid=$(nmcli -g NAME c show --active | grep -v 'lo')
nmcli c mod "$netid" ipv4.method manual ipv4.addresses "192.168.0.5/24" ipv4.gateway "192.168.0.1" ipv4.dns "8.8.8.8,8.8.4.4"

echo -e '\033[1;33mUpdating   \033[1;34mUser Permissions\033[0m'
chmod -Rf 0777 /home

echo -e '\033[1;33mFix Broken Dependencies...\033[0m'
apt-get -y -qq install -f >/dev/null
echo -e '\033[1;33mFix Broken Installations...\033[0m'
dpkg --configure -a >/dev/null
echo -e '\033[1;33mFix Broken Dependencies...\033[0m'
apt-get -y -qq install -f >/dev/null
echo -e '\033[1;33mDelete Cached Files...\033[0m'
apt-get -y -qq clean >/dev/null
echo -e '\033[1;33mDelete Obsolete Files...\033[0m'
apt-get -y -qq autoclean >/dev/null
echo -e '\033[1;33mApplying Updates...\033[0m'
apt-get -y -qq update >/dev/null
echo -e '\033[1;33mApplying Upgrades...\033[0m'
apt-get -y -qq --allow-change-held-packages -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" -o APT::Get::Always-Include-Phased-Updates=true upgrade >/dev/null

systemctl -q daemon-reload

shutdown -r now
