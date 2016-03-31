#!/bin/bash
# merrill.c.a@gmail.com 11/12/2014
# This will delete files in arg1 more than arg2 days old
# directory to start from
echo "Enter path to start from: "
read path
if [ -z "$path" ]
  then
    echo "No path supplied"
	exit
fi

#  Number of days
echo "Days to retain: "
read days
if [ -z "$days" ]
  then
    echo "No retention period supplied"
	exit
fi

find $path/* -type f -mtime +$days -exec rm -f '{}' \;
