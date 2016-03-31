#!/bin/bash
# cmerrill-mv 9/9/2014
# this will format netter output into files for csv input
# make your header files
for file1 in `ls -rt |grep ":" |head -1`
do
cat $file1 |grep 'connections established' |awk '{print $2,$3}' >> FieldHeaders
cat $file1 |grep retrans |grep 'TCP data loss events' |awk '{print $2,$3,$4,$5}' >> FieldHeaders
cat $file1 |grep retrans |grep -v Detected |awk '{first = $1; $1 = ""; print $0; }' >> FieldHeaders
cat $file1 |grep retrans |grep  Detected |awk '{print $2,$5,$6,$7,$8}' >> FieldHeaders
done
# Make your datafiles 
for file in `ls -rt |grep -v FieldHeaders |grep -v TCP`; do echo $file >> timeheader
cat $file |grep 'connections established' |awk '{print $1}' >> connnectionsestablished
cat $file |grep 'TCP data loss events' |awk '{print $1}' >>TCPdatalossevents
cat $file |grep 'segments retransmited' |awk '{print $1}' >> segmentsretransmitted
cat $file |grep 'times recovered from packet loss due to fast retransmit' |awk '{print $1}' >> timesrecoveredfrompacketlossduetofastretransmit
cat $file |grep 'timeouts after reno fast retransmit' |awk '{print $1}' >>timeoutsafterrenofastretransmit 
cat $file |grep 'fast retransmits' |awk '{print $1}' >> fastretransmits
cat $file |grep 'forward retransmits' |awk '{print $1}' >> forwardretransmits
cat $file |grep 'retransmits in slow start' |awk '{print $1}' >> retransmitsinslowstart
cat $file |grep 'sack retransmits failed' |awk '{print $1}' >> sackretransmitsfailed
cat $file |grep 'times using reno fast retransmit' |awk '{print $3}' >> reorderingusingrenofastretransmit
done
# self acknowledgement section
# echo "you totally rock if this actually works"
