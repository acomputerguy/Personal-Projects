param (
    [string]$progFile
)

#acquire file extension from command line arg
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
            $indexCommentLine = $line[$line.IndexOf('commentLine=') + 13]
        }
    }
}
Write-Host $indexCommentLine

#loop through file mentioned in arg
foreach($line in Get-Content $progFile)
{
    if($line -notmatch $indexCommnetLine)
    {
        
    }
}

#type in: .\commentRemover.ps1 file_Name.ext
#C:\Program Files (x86)\Notepad++\langs.model.xml
#format goes: commentLine="//" commentStart="/*" commentEnd="*/">
