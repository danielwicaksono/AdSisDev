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

until [ $opt -gt 4 ]
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
	esac
done
