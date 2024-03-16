#!/usr/bin/bash
for i in /home/*;
  do setfacl -m u:sddm:x $i && setfacl -m u:sddm:r $i/.face.icon;
done
