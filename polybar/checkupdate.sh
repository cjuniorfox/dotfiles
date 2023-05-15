#!/bin/bash
QT_UPDATES=$(dnf check-update -q 2> /dev/null | grep -v -e '^$' | wc -l)
if [ "$QT_UPDATES" != "0" ]; then
	echo "$QT_UPDATES";
fi
