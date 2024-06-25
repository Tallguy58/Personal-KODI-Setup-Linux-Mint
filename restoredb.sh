#!/usr/bin/env bash

currentuser=$(users | awk '{print $1}')

## Restore User Profile...
echo -e '\033[1;33mUser '$currentuser'... \033[1;34mRestore User Profile\033[0m'
rm -f -r /home/$currentuser/
cp -f -r ../UserProfile/. /home/
echo -e '\033[1;33mUser '$currentuser'... \033[1;34mUpdating User Permissions\033[0m'
chmod -f -R 0777 /home/$currentuser/
echo -e '\033[1;33mUser '$currentuser'... \033[1;34mUpdating User Ownership\033[0m'
chown -R $currentuser:$currentuser /home/$currentuser
