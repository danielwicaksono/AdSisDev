#!/bin/sh

opt="0"
while [ $opt == "0" ] || [ $opt != "4" ]
    do
    	echo "=============== MONITORING MENU ==============="
	echo "1. Bandwith Monitoring"
	echo "2. Hardware Monitoring RAM + DISK"
	echo "3. CPU Monitoring"
	echo "4. EXIT
	echo "==============================================="
	echo "Pilihan : "
	read opt
        case $opt in
        1) clear;
	   echo "++++++++++++++++++++Bandwith Monitoring++++++++++++++++++++"
	   sleep 1;
	    formatSpeed(){
		    multiplier=0
		    throughput=$1
		    while (( $(echo "$throughput>1024" | bc -l) ))
		    do
			    multiplier=$(($multiplier+1))
			    throughput=`echo "scale=3; $throughput/1024" | bc -l`
		    done
		    case $multiplier in
			    1)
			    echo "$throughput KBps"
			    ;;
			    2)
			    echo "$throughput MBps"
			    ;;
			    *)
			    echo "$1 Bps"
			    ;;
		    esac
	    }

	    formatSize(){
		    size=$1
		    if [ $size -ge 1024 ]; then
			    size=`echo "scale=1; $size/1024" | bc -l`
			    echo "$size GB"
		    else
			    echo "$size MB"
		    fi
	    }

	    while true
	    do
		    r1=`/sbin/ifconfig eth0 | grep "RX packets" | cut -d " " -f14`
		    t1=`/sbin/ifconfig eth0 | grep "TX packets" | cut -d " " -f14`
		    sleep 1
		    r2=`/sbin/ifconfig eth0 | grep "RX packets" | cut -d " " -f14`
		    t2=`/sbin/ifconfig eth0 | grep "TX packets" | cut -d " " -f14`
		    rx=$(formatSpeed $(($r2-$r1)))
		    tx=$(formatSpeed $(($t2-$t1)))
		    rxPackets=`/sbin/ifconfig eth0 | grep "RX packets" | cut -d " " -f11`
		    txPackets=`/sbin/ifconfig eth0 | grep "TX packets" | cut -d " " -f11`
		    cpuUsage=`top -bn1 | grep "load" | awk '{printf "%.2f%%\t\t\n", $(NF-2)}'`
		    ramUsed=`free -m | grep "Mem" | cut -d " " -f22`
		    ramTotal=`free -m | grep "Mem" | cut -d " " -f12`
		    ramUsedPercentage=$(($(($ramUsed*100))/$ramTotal))
		    ramUsedFormatted=$(formatSize $ramUsed)
		    ramTotalFormatted=$(formatSize $ramTotal)
		    clear
		    echo "|CPU|"
		    echo -e "Usage: $cpuUsage%\n"
		    echo "|RAM|"
		    echo "Used: $ramUsedFormatted"
		    echo "Total: $ramTotalFormatted"
		    echo -e "Usage: $ramUsedPercentage%\n"
		    echo "|NETWORK TRAFFIC|"
		    echo "Rx: $rx, Tx: $tx"
		    echo "Received packets: $rxPackets, Transmitted packet: $txPackets"
	    done
	    exit
           ;;
	   
        2) clear;
            echo "-------------------Hardware Monitor-------------------"
	    sleep 1;
	    while true
	      do
	      diskUsage=`df -h | awk '$NF=="/"{printf "%s", $5}'`
	      ramUsed=`free -m | grep "Mem" | cut -d " " -f22`
	      ramTotal=`free -m | grep "Mem" | cut -d " " -f12`
	      ramUsedPercentage=$(($(($ramUsed*100))/$ramTotal))
	      echo "Ram Usage: $ramUsedPercentage | Disk Usage: $diskUsage"
	      sleep 1
	      done
	    exit;
	    ;;

        3) clear;
            echo "-------------------CPU Monitor-------------------"
            sleep 1;
            while true
	      do
		cpu=`lscpu | grep "Model name"| cut -d " " -f15,16,17,18,19,20`
		core=`cat /proc/cpuinfo |grep "processor"| wc -l`
		temp=`sensors | grep "Core"`
		usage=`grep 'cpu ' /proc/stat |awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%" }'`

		echo "cpu            : " $cpu
		echo "cpu usage	     : " $usage
		echo "core           : " $core
		echo "temperature    : " $temp
	      done
	    exit;
	    ;;
    esac
done
