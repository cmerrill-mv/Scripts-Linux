#!/bin/bash
# to be placed in  /mnt/tomcat/
# rewritten by cmerrill-mv
# 2014/12/29
# place this line in /etc/crontab to roll daily @ 23:00
# 00 23 * * * tomcat /bin/bash /mnt/tomcat/tomcat_logroller.sh
cd /mnt/tomcat/logs
LOGDIR=`date '+%Y-%m-%d' | sed 's/-//g'`
mkdir $LOGDIR
find . -maxdepth 1 -type f -mtime +0 -name "*.log*" -exec mv {} $LOGDIR \;
for i in `find . -maxdepth 1 -type d -iname "201*" -mtime +14 | sed 's/.\///g'`; do tar -cvf $i.tar $i; gzip $i.tar; rm -rf $i; done
for i in `find . -maxdepth 1 -type d -iname "*.gz" -mtime +30 | sed 's/.\///g'`; do rm -rf $i; done
