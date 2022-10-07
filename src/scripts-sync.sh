#!/bin/bash

source ~/nextcloud-credentials.sh

mkdir -p ~/scripts

flatpak run --command=nextcloudcmd com.nextcloud.desktopclient.nextcloud \
--path "/steamdeck/scripts" \
-u "${NC_USER}" \
-p "${NC_APP_PASSWORD}" \
"/home/deck/scripts" \
"${NC_SERVER_URL}"
