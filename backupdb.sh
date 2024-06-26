#!/usr/bin/env bash

currentuser=$(users | awk '{print $1}')

## Backup User Profile...
echo -e '\033[1;33mUser '$currentuser'... \033[1;34mBackup User Profile\033[0m'
tar -zcvf "profile-backup.tar.gz" "/home/$currentuser/"