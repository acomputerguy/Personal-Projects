
#!/bin/bash

#Author: Felipe Webb
#Purpose: Using Nmap as a defensive tool as real world example.
#Script will constantly scan the local subnet and alert the user when a port is open and closed.
#WIP

#Pre-conditions for first file
#automatically pull up the IP address in use
ipAddr=`ifconfig eth0 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1`

#scan and print first results to an xml file
#`nmap -sV $ipAddr -oX original_Results.xml`

#temporary value until proof of concept checks out
i=0

while (( $i < 3 ))
do
            #timestamp file name and store for future reference
            startfn=("SelfScanResults")
            endfn=`date +%m-%d-%Y_%H:%M:%S`
            fileName=("$startfn$endfn.xml")

            #scan and print newer results to xml file
            scan_Results=`nmap -sV $ipAddr -oX $fileName`

            #parse through ndiff results and print out the essentials
            scan_Diff=`ndiff original_Results.xml $fileName | awk '/'"$ipAddr"'/{y=1;next}y'`

            #if there is no difference in between previous and current scan results, go to next iteration
            if [ -z "$scan_Diff" ]
                        then
                        i=$(( i+1 ))
                        continue
            fi
           #WORKING ON THIS PART...diff requires files
            echo $scan_Diff > temp1
            echo $scan_Diff > temp2
            newOrNot=`diff temp1 temp2`

            #append results to file and increment counter by 1
            echo "Report #$i" "$scan_Diff" >> "report.txt"
            i=$(( i+1 ))

            #remove files when done
            rm $fileName
            rm temp1
            rm temp2

done
