#!/bin/usr/bash
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
