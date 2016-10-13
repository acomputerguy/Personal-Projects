<#
Author: Felipe Webb
Purpose: Automatically reconnect to user-specified SSID
Pre-conditions: Not connected to a network, already connected to SSID
before if password is required, SSID taken form command line argument

NetConnectionStatus
2 Connected
7 Media Disconnected

*WIP*
Functionality is done, needs cleanup
#>

#Get the information from a Media disconnected network adapter using the Win32_networkadapter class

#Acquire information fromt the network adapter
[string] $isNetAdapterConnected = (Get-WmiObject win32_networkadapter -Filter "NetConnectionStatus = 2" | select netconnectionid, netconnectionstatus)

#if there isn't a network connection, run the rest of the code
if( $isNetAdapterConnected -eq $null )
    {
        #Insert the rest of the code here at the end
        Write-Host "There is no network connection. Running the rest of the code..."
    }
else
    {
        #If there is a network connection and confirmed by the number 2, close the program
        [string] $isNetAdapter2Result = $isNetAdapterConnected[45]
        if ($isNetAdapter2Result -eq 2)
        {
            Write-Host "Wi-Fi adapter is already connected. Please disconnect so program will run. Exiting program..."
            exit
        }
    }

#Declaring an array to store all SSIDs where deliminator is an empty space used to put each SSID (explained below)
$SSID_Array = @()
$delim = ' '

#Counter for asking user which SSID to connect to
$counter = 1

#Log the current networks being broadcasted
netsh wlan show network > ssidNames.log
Start-Sleep -s 2 #pause if the code goes too fast

#Loop through file for the line that contains the SSID
foreach ($service in get-content 'ssidNames.log')
{
    if ($service -match 'SSID \d')
    {
        #Inserting Wi-Fi names into the array
        #For example, format comes in as, 'SSID 5 : WifiName'
        $SSID_Array += $service.split($delim)[3]
    }
}

#Loop through array, if user-inputted SSID matches with what is being broadcasted, connect
foreach($element in $SSID_Array)
{
    if($element -eq $ARGS[0]) #$SSID_Input
    {
        netsh wlan connect name = $ARGS[0]
        $SSID_Exists = "True"
        Start-sleep -s 5 #give it time to connect, avoid race condition
    }
}
#Otherwise ask the user which SSID they are looking for
if($SSID_Exists -eq "False")
{
    foreach($element in $SSID_Array)
    {
        #say the null SSID is a hidden network
        if($element -eq '')
        {
            Write-Host $counter "Hidden Network:"
            Continue
        }

        Write-Host $counter $element
        $counter++
    }
#ask user which SSID they are referring to
$ssidNum = Read-Host -Prompt "SSID does not match what is being broadcasted. Which SSID # are you referring to?"

#loop through the array for the SSID and connect to it
$userSpecifiedSSID = $SSID_Array[$ssidNum-1]
netsh wlan connect name = $userSpecifiedSSID
Start-sleep -s 5
}

#delete file when done
Remove-Item ssidNames.log

while ($true)
{
    $isNetAdapterConnected = (Get-WmiObject win32_networkadapter -Filter "NetConnectionStatus = 2" | select netconnectionid, netconnectionstatus)

    #if there isn't a network connection, run the rest of the code
    if( $isNetAdapterConnected -eq $null )
        {
            #Insert the rest of the code here at the end
            Write-Host "I see the network disconnected."
            netsh wlan connect name = RIT
            Start-Sleep -s 5 #give it time to connect
        }
    else
        {
            #If there is a network connection and confirmed by the number 2, close the program
            [string] $isNetAdapter2Result = $isNetAdapterConnected[45]
            if ($isNetAdapter2Result -eq 2)
            {
                Write-Host "Wi-Fi adapter is already connected!"
                Start-Sleep -s 5
            }
        }
}
