#!/bin/bash
#cam 8/2014
echo list of swap files and top 5 swap users
ls -lh /mnt/ephemeral/swapfile*
for file in /proc/*/status ; do awk '/VmSwap|Name/{printf $2 " " $3}END{ print ""}' $file; done | sort -k 2 -n -r |head -5
