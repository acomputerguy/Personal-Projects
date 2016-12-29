#Author: Felipe Webb
#Description: Using Nmap as a defensive tool for a real world example.
#Script will constantly scan the local box and alert the user for port activity

#Pre-conditions: Make sure the XML format is acceptable for ndiff (try a test case and make it original_Results.xml)

#!/bin/bash

#automatically pull up the IP address in use
ipAddr=`ifconfig eth0 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1`

#counter for scan # in report
i=0

#very first file name
oldFileName="original_Results.xml"

#endlessly scan the local machine
while :
do
        #timestamp file name and store for future reference
	startfn=("SelfScanResults")
	timeStamp=`date +%m-%d-%Y_%H:%M:%S`
	newFileName=("$startfn$timeStamp.xml")

        #scan and print newer results to xml file
	printThis=`nmap -sV $ipAddr -oX $newFileName`

        #parse through ndiff results and print out the essentials
	scan_Diff=`ndiff $oldFileName $newFileName | awk '/'"$ipAddr"'/{y=1;next}y'`

        #remove old file, no longer needed anymore
	rm $oldFileName

        #the new file becomes the old file once we scan in the next iteration
	oldFileName=$newFileName
            
        #if there is no difference in between previous and current scan results,
        #go to next iteration and skip remainder of code below
	if [ -z "$scan_Diff" ]
		then
		i=$(( i+1 ))
		continue
	fi

        #append results to file and increment counter by 1 with a timestamp
	echo -e "$timeStamp Report #$i" "$scan_Diff\n" >> "report.log"
	i=$(( i+1 ))

        #delete all old results in trash bin
	rm -rf ~/.local/share/Trash *

done
