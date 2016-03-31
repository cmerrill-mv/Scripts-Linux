#!/bin/bash
### cmerrill-mvm 8/20/2014
# 
echo "Your tomcat pids are:"
# old method
#ps -ef |grep tomcat |grep -v grep |grep -v root |awk '{print $3,$2}'
# better way
 pgrep -f tomcat
read -p "Do you want to kill these pids (Y/N)?"

[ "$(echo $REPLY | tr [:upper:] [:lower:])" == "y" ] || exit
pgrep -f tomcat |xargs kill -9
echo "Tomcat pids killed"

read -p "Do you want to restart tomcat (Y/N)?"

[ "$(echo $REPLY | tr [:upper:] [:lower:])" == "y" ] || exit
service tomcat start
### if new pids dont echo to screen uncomment these lines:
# sleep 5
# pgrep -f tomcat
