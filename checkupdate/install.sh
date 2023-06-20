#!/bin/bash

cat << EOF | pkexec 
cd "$(pwd)"
cp checkupdated.sh /usr/local/bin
cp checkupdate.sh /usr/local/bin
cp update.sh /usr/local/bin
cp checkupdate.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable checkupdate --now
EOF

