param (
    [string]$progFile
)

#acquire file extension
$indexDot = $progFile.IndexOf('.')
$fileNameLen = $progFile.Length
$fileExtLen = $fileNameLen - $indexDot
$fileExt = $progFile.Substring($indexDot + 1, $fileExtLen - 1)

#get notepad file for data...change later for env var, C: can be diff
#$d = "${Env:ProgramFiles(x86)}
$absPath = "${env:ProgramFiles(x86)}\Notepad++\langs.model.xml"

#loop through langs.model.xml
foreach($line in Get-Content $absPath)
{
    if($line -match "ext=")
    {
        #remove text if its: "ext, ext , ext"
        if($line -match "(`"$fileExt| $fileExt | $fileExt`")")
        {
            Write-Host $line
        }
    }
}
#C:\Program Files (x86)\Notepad++\langs.model.xml
#format goes: commentLine="//" commentStart="/*" commentEnd="*/">

#grab commentLine
