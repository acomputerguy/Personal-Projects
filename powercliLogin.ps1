##################Automatic Login##################
#Input code into Initialize-PowerCLIEnvironment.ps1 file
#This is where source code to automatically boot powercli is

function loginVcenter {
<#
.SYNOPSIS
Function will automatically log into VIServer
.DESCRIPTION
Function prompts user for server name, user name, and password
.EXAMPLE
Input the following respectively - vcenter.vase.local, fwebb, password
.PARAMETER
Queried vcenter.vase.local in my uses
#>

#Due to runtime issues, confirm for user to input first
Write-Host "`nPress any key to continue...`n"
$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | out-null

#Prompt user for server to conncet to - vcenter.vase.local
$server = Read-Host -Prompt 'Input domain address'

#Parse for vase.local in server name
$indexPos = $server.IndexOf(".") + 1;
$length = $server.length
$portionDomain = $server.substring($indexPos, $length - $indexPos)

#Append @vase.local to username, format is as follows: <usrnm>@vase.local
$user = Read-Host -Prompt 'Username'
$user = $user + "@" + $portionDomain

#Read passwords as asterisks, keep out of buffer, and convert back to plaintext for connection
$maskedPassword = Read-Host -Prompt 'Password' -AsSecureString
$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto( [Runtime.InteropServices.Marshal]::SecureStringToBSTR($maskedPassword) )

#Connect to VIServer, ignoring invalid certificate action and multiple default servers
Connect-VIServer -Server $server -Protocol https -User $user -Password $password -Force
Write-Host "`n"
}

loginVcenter

#Error buffer is shell-specific
while($true) #rewrite loop later, bad code
{
	if( ($error[0] -match "Cannot complete login due to an incorrect user name or password") -OR ($error[0] -match "Could not resolve the requested VC server") )
	{
		#Clear buffer
		$error.Clear()
		loginVcenter
	}
	elseif ( ($error[0] -NotMatch "Cannot complete login due to an incorrect user name or password") -OR ($error[0] -NotMatch "Could not resolve the requested VC server") )
	{ #rewrite elseif, when do you want to not check for error
		#Welcome user
		Write-Host "`t`nWelcome! You are now in " -NoNewLine
		Write-Host -foregroundcolor yellow $global:DefaultVIServer
		Break
	}
}
