#!/bin/sh
# This script will set the VGA monitor above the built in monitor

number_of_monitors="$(/bin/xrandr --listmonitors | /bin/awk 'NR==1{print $2}')"

if [ "$number_of_monitors" = "2" ]; then
  /bin/xrandr --output VGA1 --auto --above LVDS1 --primary
fi
