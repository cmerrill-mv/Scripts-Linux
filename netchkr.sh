#!/bin/bash
# merrill.c.a@gmail.com
# 6/20/2014
echo removing old camstat
rm /tmp/camstat
echo running netstat...
netstat >> /tmp/camstat
cd /tmp
echo `hostname` `date`
echo total tcp connections
grep -c tcp camstat
echo http connections
grep -c http camstat
echo webcache TIME_WAIT connections
grep webcache camstat |grep -c TIME_WAIT
echo SYN_RECV
grep -c SYN_RECV camstat
echo ESTABLISHED
grep -c ESTABLISHED camstat
echo LISTEN
grep -c LISTEN camstat
echo TIME_WAIT
grep -c TIME_WAIT camstat
echo CLOSE_WAIT
grep -c CLOSE_WAIT camstat
echo LAST_ACK
grep -c LAST_ACK camstat
echo Total sql
grep -c sql camstat
echo sql ESTABLISHED
grep sql camstat|grep -c ESTABLISHED
echo sql LISTEN
grep sql camstat |grep -c LISTEN
echo sql TIME_WAIT
grep sql camstat|grep -c TIME_WAIT
echo mongo port 27017
grep -c 27017 camstat
echo cobol 
grep -c cobol camstat
exit
