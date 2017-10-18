#!/bin/sh
# filename: hwmonitor.sh
 
while true
do
disk=`df -h | awk '$NF=="/"{printf "%s", $5}'`
ram=`free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }'`
echo "Ram Usage: "  $ram "| Disk Usage: " $disk
sleep 1
done
