#!/usr/bin/env bash

currentuser=$(users | awk '{print $1}')

## Update Permissions
chmod -Rf 0777 /home

## Create Exceptions List
echo '/home/'$currentuser'/.bash_history'>/tmp/file.lst
echo '/home/'$currentuser'/.conkyrc'>>/tmp/file.lst
echo '/home/'$currentuser'/.sudo_as_admin_successful'>>/tmp/file.lst
echo '/home/'$currentuser'/.xsession-errors'>>/tmp/file.lst
echo '/home/'$currentuser'/.xsession-errors.old'>>/tmp/file.lst
echo '/home/'$currentuser'/.config/autostart'>>/tmp/file.lst
echo '/home/'$currentuser'/.config/pulse'>>/tmp/file.lst
echo '/home/'$currentuser'/.config/session'>>/tmp/file.lst
echo '/home/'$currentuser'/.var/app/tv.kodi.Kodi/data/userdata/keymaps'>>/tmp/file.lst
echo '/home/'$currentuser'/Desktop'>>/tmp/file.lst
echo '/home/'$currentuser'/Documents'>>/tmp/file.lst
echo '/home/'$currentuser'/Downloads'>>/tmp/file.lst
echo '/home/'$currentuser'/Music'>>/tmp/file.lst
echo '/home/'$currentuser'/Pictures'>>/tmp/file.lst
echo '/home/'$currentuser'/Public'>>/tmp/file.lst
echo '/home/'$currentuser'/Templates'>>/tmp/file.lst
echo '/home/'$currentuser'/Videos'>>/tmp/file.lst

## Backup User Profile...
echo -e "\033[1;33mUser \"$currentuser\"... \033[1;34mBackup User Profile\033[0m"
tar --exclude={'*.log','*.tmp'} --exclude-from=/tmp/file.lst -zcvf profile-backup.tar.gz --absolute-names '/home/'$currentuser'/'
rm -f /tmp/file.lst