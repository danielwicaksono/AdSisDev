#!/bin/sh
# filename: hwmonitor.sh
 
while true
do
diskUsage=`df -h | awk '$NF=="/"{printf "%s", $5}'`
ramUsed=`free -m | grep "Mem" | cut -d " " -f22`
ramTotal=`free -m | grep "Mem" | cut -d " " -f12`
ramUsedPercentage=$(($(($ramUsed*100))/$ramTotal))
echo "Ram Usage: $ramUsedPercentage | Disk Usage: $diskUsage"
sleep 1
done
