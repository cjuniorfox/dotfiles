#!/bin/bash

LOCK=" Lock"
LOGOUT=" Logout"
SWITCH_USER=" Switch User"
SUSPEND=" Suspend"
#HIBERNATE=" Hibernate"
REBOOT=" Reboot"
SHUTDOWN=" Shutdown"

CONF=$(cat << EOF
configuration{
        show-icons:false;
}
#window {
        width: 368px;
        anchor: north east;
        location: north east;
}
mainbox {
        children: [inputbar,listview];
}
listview{
        coluns:2;
        lines:3;
}
EOF
)

kill $(cat /run/user/$UID/rofi.pid) 2> /dev/null || \
	case $(cat << EOF | rofi -dmenu -theme-str "$CONF" -i -p "Shutdown?"
$LOCK
$LOGOUT
$SWITCH_USER
$SUSPEND
$REBOOT
$SHUTDOWN
EOF
) in
"$LOCK")
 i3exit lock ; ~/.config/hyprland/scripts/lockscreen;;
"$LOGOUT")
 i3exit logout ; hyprctl dispatch exit;;
"$SWITCH_USER")
 dm-tool switch-to-greeter;;
"$SUSPEND")
 i3exit suspend;;
"$REBOOT")
 i3exit reboot;;
"$SHUTDOWN")
 i3exit shutdown;;
esac
