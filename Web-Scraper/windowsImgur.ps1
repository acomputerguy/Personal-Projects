param(
    [string]$URL
)

#create folder with post url name

$indexSlash
$URLlength
$lenFileName
$fileNamefromURL
$fileName

$indexQuote
$lineLength

#change filename to last bit of URL
$indexSlash = $URL.LastIndexOf('/')
$URLlength = $URL.Length
$lenFileName = $URLlength - $indexSlash

$fileNamefromURL = $URL.Substring($indexSlash + 1, $lenFileName - 1)

[string]$fileName = $PWD
$fileName += ( "\" + $fileNamefromURL)

#uncomment when done
#include -TimeoutSec 5
#Invoke-WebRequest -Uri $URL -Outfile $fileName

#parse through file and pull up all instances of media specific to post
foreach ($line in Get-Content $fileNamefromURL)
{
    if($line -match '<img src="//i.imgur.com/')
    {
        
        $indexQuote = $line.IndexOf('"')
        $lineLength = $line.Length
        $mediaLine += ($line.Substring($indexQuote + 1))

        $indexQuote = $mediaLine.IndexOf('"')
        $mediaLine = ($mediaLine.Substring(0, $indexQuote) + "`n")
    }
    
}

$allMedias = $mediaLine.split("`n")
#Write-Host $allMedias
#need to delete last element!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

#make file path, download all files
foreach ($media in $allMedias)
{
    #Write-Host "aaa" $ele "bbb"
    #REPEAT CODE, instead of $url its $ele

    $indexSlash = $media.LastIndexOf('/')
    $length = $media.Length
    $lenFileName = $length - $indexSlash
    $fileNamefromURL = $media.Substring($indexSlash + 1, $lenFileName - 1)
    Write-Host $fileNamefromURL

    [string]$fileName = $PWD
    $fileName += ( "\" + $fileNamefromURL)
    #end of repeat code
    $files += ($fileName + "`n")

}
$allFiles = $files.split("`n")
Write-Host @allFiles
#foreach( $bla in $allFiles)
#{     
    #include -TimeoutSec 5
    #Invoke-WebRequest -Uri $ele -Outfile $fileNamefromURL
#}
