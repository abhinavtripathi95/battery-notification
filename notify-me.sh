#!/bin/sh
eval "export $(egrep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -u $LOGNAME gnome-session)/environ)";

battery_status=`acpi -b | grep -E -o 'Discharging||Charging'`
battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)'`

#IMP: always write absolute paths for cronjob
if [ $battery_status = 'Discharging' ]
then

    if [ $battery_level -le 15 ] 
    then
        /usr/bin/notify-send "Battery critical" "Shutting down in 30 seconds" -i /home/abhinav/Documents/battery-scripts/alert.ico
        sleep 30
        /sbin/shutdown -h now

    elif [ $battery_level -le 20 ]
    then
        /usr/bin/notify-send "Battery very low" "Battery level is ${battery_level}%!" -i /home/abhinav/Documents/battery-scripts/battery-critical.ico

    elif [ $battery_level -le 30 ]
    then 
        /usr/bin/notify-send "Battery low" "Battery level is ${battery_level}%!" -i /home/abhinav/Documents/battery-scripts/battery-low.ico
    
    fi

else
    if [ $battery_level -gt 92 ]
    then
        /usr/bin/notify-send "Battery is charging" "Battery level is ${battery_level}%!" -i /home/abhinav/Documents/battery-scripts/battery-full.ico
    fi
fi