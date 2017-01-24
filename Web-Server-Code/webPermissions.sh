#!/bin/usr/bash

#Author: Felipe Webb
#Description: Search and set all files and directories in
#current and subdirectories permissions accordingly for web server

#home directory (/home/abc1234/) should be 711
#before wq, :set ff=unix
for i in $( find -iname '*' )
do
	if [ -d $i ]
	then
		echo directory: $i
		chmod 755 $i
	elif [ -f $i ]
	then
		echo regularfile: $i
		chmod 644 $i
	fi
done
