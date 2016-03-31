#!/bin/bash
# cam 8/15/2014
echo "Enter full path and regex for file(s): "
read input
if [ -z "$input" ]
  then
    echo "No arguments supplied"
	exit
fi
echo "Total size of $input files in MB is:"
du -m $input |awk '{print $1}' |awk '{sum+=$1}END{print sum}'
