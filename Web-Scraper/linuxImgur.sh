#!/usr/bin/bash
#check if there is at least 1 argument later
wget $1

#when downloaded, file name is diff
#http://imgur.com/gallery/mMKha

file=$( echo $1 | cut -f  5 -d '/' )

media=$( cat $file | grep "<img src=\"//i.imgur.com/" | awk '{print $2;}' | cut -f 2 -d "=" | cut -c 4-26 )

for i in "${media[@]}"
do
	wget $i
done

#rm $file
