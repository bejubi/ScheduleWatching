$url = "http://www.sailing.org/regattasearch.php?nocache=1&includeref=regattasearch&regattadiscipline=1&regattatype=1&regattayear=2015&regattacountry=211"
$xpath = "//table[@class='results']"
$outputFolder = "IsafMrSchedule2015"
$beyondComparePath = "C:\Program Files\Beyond Compare 4\BCompare.exe"

add-type -Path .\HtmlAgilityPack.dll
$htmlweb = New-Object htmlagilitypack.htmlweb

$latestFile = Get-ChildItem -Path .\$outputFolder\ -Filter *_source.html | Sort-Object LastAccessTime -Descending | Select-Object -First 1

$htmldocument = $htmlweb.Load($url)
$html = $htmldocument.DocumentNode.SelectSingleNode($xpath).OuterHtml

$html | Out-File .\$outputFolder\current.html

$currentFileContents = [IO.File]::ReadAllText('.\' + $outputFolder + '\current.html')
$previousFileContents = [IO.File]::ReadAllText('.\' + $outputFolder + '\' + $latestFile.name)
$comparison = $currentFileContents.CompareTo($previousFileContents)

if($comparison)
{
    $timestamp = $(get-date -Format yyyyMMddHmmss)
    $savedFileName = $timestamp + "_source.html"
    $savedFilePath = '.\' + $outputFolder + '\' + $savedFileName
    $html | Out-File $savedFilePath

    $reportFileName = $timestamp + "_diff.html"
    &$beyondComparePath /silent `@"comparisonScript.txt" "$outputFolder\$latestFile" "$outputFolder\$savedFileName" "$outputFolder\$reportFileName" | Out-Null
    
    Copy-Item "$outputFolder\$reportFileName" "$([Environment]::GetFolderPath('Desktop'))"
}

Remove-Item .\$outputFolder\current.html