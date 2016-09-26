#!/bin/bash

#Author: Felipe Webb
#Purpose: Using Nmap as a defensive tool

#timestamp the file name
fileName=("SelfScanResults%M-%d-%Y_%H:%M.xml")

#automatically pull up IP address from etho0
ipAddr=`ifconfig eth0 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1`

#scan and print results to an xml file
scan_Results=`nmap -sV $ipAddr -oX $fileName`

#parse through ndiff results and print out necessary information
scan_Diff=`ndiff sample.xml $fileName | awk '/'"$ipAddr"'/{y=1;next}y'`

#print out results to file
echo "Report:" "$scan_Diff" > "report.txt"
