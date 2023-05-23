#!/bin/bash

LOCK=" Lock"
LOGOUT=" Logout"
SUSPEND=" Suspend"
#HIBERNATE=" Hibernate"
REBOOT=" Reboot"
SHUTDOWN=" Shutdown"

CONF=$(cat << EOF
configuration{
        show-icons:false;
}
#window {
        y-offset: 32px;
        width: 16em;
        anchor: north east;
        location: north east;
}
mainbox {
        children: [inputbar,listview];
}
listview{
        border: 1px;
        border-radius: 6px;
        coluns:2;
        lines:3;
}
EOF
)

case $(cat << EOF | rofi -dmenu -theme-str "$CONF" -i -p "Shutdown?"
$LOCK
$LOGOUT

$SUSPEND
$REBOOT
$SHUTDOWN
EOF
) in
"$LOCK")
 i3exit lock;;
"$LOGOUT")
 i3exit logout;;
"$SUSPEND")
 i3exit suspend;;
"$REBOOT")
 i3exit reboot;;
"$SHUTDOWN")
 i3exit shutdown;;
esac
