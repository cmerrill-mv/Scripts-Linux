#!/bin/bash
#cmerrill@netpulse.com 20150115
# SYSADMIN-458
DIR=`ls -alrt /data/logs |grep gz |grep -v tar |awk '{print $6}'|head -1`
mkdir /data/logs/$DIR
ls -alrt /data/logs |grep gz |grep -v tar |awk '{print $8}' >> outfile
for FILE in `cat outfile`
do
# Uncoment for testing
#echo  $FILE $DIR/.
mv /data/logs/$FILE /data/logs/$DIR/.
done
tar -zcf /data/logs/$DIR.tar.gz /data/logs/$DIR 2>&1 > /dev/null
rm outfile
rm -rf /data/logs/$DIR
