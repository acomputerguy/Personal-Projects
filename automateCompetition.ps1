#Automate the process to run the competition.

#remote desktop into 10.160.210.1
#so you can leave it running and connected to server

#Functionalities
#Process goes as follows (commands run consectuvively):
#Turn on blue and red team virtual machines
#(only to those who are not turned on)
#Grant Red Team and Blue Team console-only access
#User input to say how long the code should wait
#(Sometimes there are white team delays or something goes down)
#When time is up, suspend all red and blue team boxes
#Terminate session key of all students in competition
#(Require killing session so new permissions are pushed)
#Take snapshots with predefined user-input

###Formatting###
function printFormat {
	$len = $args[0].length
	$totalHyphens = "-" * $len
	Write-Host "`n$args`n$totalHyphens"
}
###EO formatting###

$blueName = Read-Host -Prompt "Thinking way ahead...`nSnapshot name of blue VMs" -foregroundcolor blue
$blueDescription = Read-Host -Prompt "Snapshot description of blue VMs" -foregroundcolor blue

$redName = Read-Host -Prompt "Snapshot name of red VMs" -foregroundcolor red
$redDescription = Read-Host -Prompt "Snapshot description of red VMs" -foregroundcolor red

###Grab all blue and red virtual machines for specific competition who have yet to be turned on###
$blueVMs = Get-Folder -Location "Blue Comp 2"
$redVMs = Get-Folder -Location "Red Comp 2"

#Grant console-only access to respective members
Set-VIRole -Role "Console Only" -AddPrivilege "Console interaction"
#I get lost when I do Set-VIPermission -Permission ??? -Role "Console Only" -Propagate:$true
#propagate goes to child objects, which are the virtual boxes
#Set-VIPermission -Principal "VSPHERE.LOCAL\Blue Team" -Role "Console Only"
#Set-VIPermission -Principal "VSPHERE.LOCAL\Red Team" -Role "Console Only" 

###Print out affected virtual macines###
#can you combine this somehow?
printFormat "Affected VMs include"
foreach($VM in $blueVMs)
{ Write-Host $VM -foregroundcolor blue }
foreach($VM in $redVMs)
{ Write-Host $VM -foregroundcolor red }

###Start all affected virtual machines in background consecutively###
printFormat "Powered on the following VMs"
foreach($VM in $blueVMs)
{ Start-VM -VM $VM -RunAsync:$false } #try to do -foreground #color. not sure how yet
foreach($VM in $redVMs)
{ Start-VM -VM $VM -RunAsync:$false }

###User input for time to wait until next commands###
$timeWait = Read-Host -Prompt "Waiting time [format is HR,MIN]"

$hours = $timeWait[0]
[int]$intHours = [convert]::ToInt32($hours, 10)

$length = $timeWait.length

function inputValidation {
	if($length -eq 3)
	{ $minutes = $timeWait[2]; return $minutes }
	elseif ($length -eq 4)
	{ $minutes = $timeWait[2] + $timeWait[3]; return $minutes }
}
$minutes = inputValidation
[int]$intMinutes = [convert]::ToInt32($minutes, 10)

$totalSeconds = $intHours * 3600 + $intMinutes * 60

for($i=1;$i -lt $totalSeconds; $i++)
{
	$activity = "Waiting $totalSeconds..."
	$status = "Currently at $i seconds"
	$remaining = $totalSeconds - $i
	$percentage = $i / $totalSeconds * 100
	$operation = "$percentage% complete"
	
	Write-Progress -Activity $activity -Status $status -SecondsRemaining $remaining -PercentComplete $percentage -CurrentOperation $operation
	Sleep 1
	#Start-Sleep -s $totalSeconds
}
#Kill relevant sessions (red/blue team students)
#either a) pull up all users from red and blue team (or team 1 or 2 whatever it is)
#use this as a reference to disconnect the sessions
#or b) disconnect using regex likwe -match "VASE/[upper case][lower case] but thats BAD in case theres VASE/Vcenter like VASE/Abrandano"
#might have to loop through username sand append VASE/ to the left of it. DONE

#you can also do...TRY TIHS for next competition
#$serviceInstance = Get-View 'ServiceInstance'
#$sessionManager = Get-View $serviceInstance.Content.SessionManager
#$sessionManager.SessionList | Select Username, Key, IPAddress
# or any of the others, LoginTime, LastActiveTime
#here you dont have to use .ToLocalTime()
$sessionMgr = Get-View $DefaultVIServer.ExtensionData.Client.ServiceContent.SessionManager

$allSessions = @()

#4 objects for vertical info. any more, everyone gets their own section
$sessionMgr.sessionList | foreach {
		$session = New-Object -TypeName PSObject -Property @{
		Username = $_.Username
		Key = $_.Key
		Fullname = $_.Fullname #do you need fullname? maybe, try it out
		#IPAddress = $_.IPAddress
		#LoginTime = ($_.logintime).ToLocaltime()
		#LastActiveTime = ($_.LastActiveTime).ToLocalTime()
	}
	$allSessions += $session
}
#focus on VASE\students not VSPHERE.LOCAL\
#"^VASE\\[A-Z]" will check for first uppercase so fwebB doesnt count
$disconnectUsers = $allSessions | Where {$_.Username -cmatch "^VASE\\[A-Z]"}

$disconnectUsers | foreach { 
	$SessionMgr.TerminateSession($_.Key)
	}
	
#Don't forget to write a message to everyone like you did in class, with "hello"

###Remove console-only access to respective members###
Set-VIRole -Role "Console Only" -RemovePrivilege "Console interaction"
#Remove-VIPermission -Principal "VSPHERE.LOCAL\Blue Team" -Role "Console Only"
#Remove-VIPermission -Principal "VSPHERE.LOCAL\Red Team" -Role "Console Only" 

#Suspend all affected virtual machines when time is up
#In case students suspend or power off the machines themselves, use the where clause
printFormat "Suspended the following VMs"
foreach($VM in $blueVMs)
{ Suspend-VM -VM $VM -Confirm:$false -RunAsync:$false | where { $_.Powerstate -ne "Suspended", "PoweredOff" } } #can you do -foregroundcolor blue
foreach($VM in $redVMs)
{ Suspend-VM -VM $VM -Confirm:$false -RunAsync:$false | where { $_.Powerstate -ne "Suspended", "PoweredOff" } }

###Snapshot virtual machines###
function snapshotVMs{
	foreach($VM in $blueVMs)
	{ New-Snapshot -VM $VM -Name $redName -Description $redDescription }
	foreach($VM in $redVMs)
	{ New-Snapshot -VM $VM -Name $blueName -Description $blueDescription }
}

