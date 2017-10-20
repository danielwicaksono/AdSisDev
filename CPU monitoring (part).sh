#!/bin/bash

cpu=`lscpu | grep "Model name"| cut -d " " -f15,16,17,18,19,20`
core=`cat /proc/cpuinfo |grep "processor"| wc -l`
temp=`sensors | grep "Core"`
usage=`grep 'cpu ' /proc/stat |awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%" }'`

echo "cpu            : " $cpu
echo "cpu usage	     : " $usage
echo "core           : " $core
echo "temperature    : " $temp
