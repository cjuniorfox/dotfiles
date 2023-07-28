#!/bin/bash

cat << EOF | pkexec 
    cd "$(pwd)"
    cp checkupdated /usr/local/bin
    cp checkupdate /usr/local/bin
    cp update /usr/local/bin
    cp checkupdate.service /etc/systemd/system/
    systemctl daemon-reload
    systemctl enable checkupdate --now
EOF

