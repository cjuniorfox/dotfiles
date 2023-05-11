#!/bin/bash

echo -e "@text,,40,40,420,40,40,center,center,#ffffff 100,#000000 0 ,$1,\n$2,$3\n$4,$5\n" | jgmenu --simple --config-file=~/.config/jgmenu/dialog/jgmenurc
