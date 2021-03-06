#!/bin/bash
opt=0

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
# Meng-convert ukuran ram menjadi GB atau MB
formatSize(){
        size=$1
        if [ $size -ge 1024 ]; then
                size=`echo "scale=1; $size/1024" | bc -l`
                echo "$size GB"
        else
                echo "$size MB"
        fi
}


until [ $opt -ge 4 ]
do
	# Menampilkan menu utama
	clear
	echo "=============== MONITORING MENU ==============="
	echo "1. NETWORK TRAFFIC"
	echo "2. CPU"
	echo "3. RAM"
	echo "4. EXIT"
	# Membaca pilihan yang diinginkan oleh user
	echo -e "Option: \c"
	read opt
	case $opt in
	# menampilkan throughput Rx, Tx, jumlah received packets, dan transmitted packets
    1)	while true
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
		    clear
		    echo "====================Network Monitoring===================="
		    echo "Rx: $rx, Tx: $tx"
		    echo "Received packets: $rxPackets, Transmitted packet: $txPackets"
		done
	;;
	 # menampilkan CPU usage dan CPU temperature
    	2)      while true
                do
                        cpuUsage=`top -bn1 | grep "load" | awk '{printf "%.2f%%\t\t\n", $(NF-2)}'`
                        cpuTemp=`sensors | grep "Core 0" | cut -d " " -f10`
                        clear
                        echo "====================CPU Monitoring===================="
                        echo "CPU Usage: $cpuUsage%"
                        echo "CPU Temperature: $cpuTemp"
                done
        ;;

	# menampilkan informasi RAM (used, total, dan usage)
    3)	while true
		do
			ramUsed=`free -m | grep "Mem" | cut -d " " -f22`
			ramTotal=`free -m | grep "Mem" | cut -d " " -f12`
			ramUsedPercentage=$(($(($ramUsed*100))/$ramTotal))
			ramUsedFormatted=$(formatSize $ramUsed)
			ramTotalFormatted=$(formatSize $ramTotal)
			clear
			echo "====================RAM Monitoring===================="
			echo "Used: $ramUsedFormatted"
			echo "Total: $ramTotalFormatted"
			echo "Usage: $ramUsedPercentage%"
		done
	;;
	esac
done
