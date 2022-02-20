#!/usr/bin/env bash

# Author: Dmitri Popov, dmpop@linux.com

#######################################################################
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#######################################################################

# Read user
USER="$(whoami)"
if [ -z "$USER" ]; then
    USER="pi"
fi

cp /var/www/little-backup-box/config.cfg $HOME/config.cfg.bak

cd
dialog --clear \
    --title "Warning" \
    --backtitle "Uninstall Little Backup Box" \
    --yesno "This will uninstall Little Backup Box.\nAre you sure you want to proceed?" 7 60

response=$?

clear

case $response in
0)
    sudo rm -rf /home/$USER/little-backup-box

    sudo mv /etc/minidlna.conf.orig /etc/minidlna.conf

    sudo rm /etc/samba/smb.conf
    sudo rm /etc/samba/login.conf
    sudo mv /etc/samba/smb.conf.orig /etc/samba/smb.conf
    sudo smbpasswd -x lbb
	sudo samba restart

    sudo service apache2 stop

    sudo systemctl stop filebrowser.service
    sudo systemctl disable filebrowser.service
    sudo rm /etc/systemd/system/filebrowser.service

    crontab -r
#     sudo reboot
    ;;
1)
    exit 1
    ;;
255)
    exit 1
    ;;
esac
