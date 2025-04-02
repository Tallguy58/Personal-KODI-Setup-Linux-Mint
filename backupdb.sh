#!/usr/bin/env bash

currentuser=$(users | awk '{print $1}')

## Update Permissions
chmod -Rf 0777 /home

## Delete User Files
rm -rf /home/$currentuser/.config/pulse
rm -rf /home/$currentuser/.config/session
rm -f /home/$currentuser/.sudo_as_admin_successful
rm -f /home/$currentuser/.bash_history
rm -f /home/$currentuser/.xsession-errors
rm -f /home/$currentuser/.xsession-errors.old
rm -f /home/$currentuser/Desktop/skype_skypeforlinux.desktop

## Backup User Profile...
echo -e "\033[1;33mUser \"$currentuser\"... \033[1;34mBackup User Profile\033[0m"
tar -zcvf "profile-backup.tar.gz" "/home/$currentuser/"

## Restore User Files
cp -f /var/lib/snapd/desktop/applications/skype_skypeforlinux.desktop /home/$currentuser/Desktop

## Update Permissions
chmod -Rf 0777 /home