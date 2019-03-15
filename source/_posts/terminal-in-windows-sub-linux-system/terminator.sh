#!/bin/sh
cd ~
x=`/mnt/c/Windows/System32/tasklist.exe /FI "IMAGENAME eq vcxsrv.exe" | grep vcxsrv.exe`;

if [[ ! $x ]];then
  "/mnt/c/Program Files/VcXsrv/vcxsrv.exe" :0 -ac -terminate -lesspointer -multiwindow -clipboard -wgl -dpi auto 2> /dev/null & 
fi

export DISPLAY=:0.0
terminator
