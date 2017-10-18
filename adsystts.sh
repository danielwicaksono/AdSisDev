#!/bin/sh
# filename: adsystts.s

opt="0"
while [ $opt == "0" ] || [ $opt != "4" ]
    do
    	echo "=============== MONITORING MENU ==============="
	echo "1. Bandwith Monitoring"
	echo "2. Hw Monitoring RAM + DISK"
	echo "3. Pilihan 3"
	echo "4. exit"
	echo "==============================================="
	echo "Pilihan : "
	read opt
        case $opt in
        1) clear;
	   echo "++++++++++++++++++++Bandwith Monnitor++++++++++++++++++++"
	   sleep 1;
	   sh ./bandwithmonitor.sh;
           ;;

        2) clear;
            echo "-------------------Hardware Monitor-------------------"
	    sleep 1;
	    sh ./hwmonitor.sh;
	    exit;
	    ;;

        3) clear;
            echo "Pilihan 3"
            sleep 1;
	    exit;
	    ;;
    esac
done
