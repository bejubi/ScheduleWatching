$url = "http://www.sailing.org/regattasearch.php?nocache=1&includeref=regattasearch&regattadiscipline=1&regattatype=1&regattayear=2015&regattacountry=211"
$xpath = "//table[@class='results']"
$outputFileNameRoot = "IsafMrSchedule2015"
$beyondComparePath = "C:\Program Files (x86)\Beyond Compare 4\BCompare.exe"

add-type -Path .\HtmlAgilityPack.dll

cls

$filter = $outputFileNameRoot + '*.html'
$latestFile = Get-ChildItem -Path . -Filter $filter | Sort-Object CreationTime -Descending | Select-Object -First 1

$htmlweb = New-Object htmlagilitypack.htmlweb
$htmldocument = $htmlweb.Load($url)
$html = $htmldocument.DocumentNode.SelectSingleNode($xpath).OuterHtml

$html | Out-File .\current.html

$currentFile = [IO.File]::ReadAllText('.\current.html')

$previousFile = [IO.File]::ReadAllText($latestFile.name)

$comparison = $currentFile.CompareTo($previousFile)

if($comparison)
{
    $savedFileName = $outputFileNameRoot + $(get-date -Format yyyyMMddHmmss) + '.html'
    $savedFilePath = '.\' + $savedFileName
    $html | Out-File $savedFilePath

    $reportFileName = $savedFileName + "_diff.htm"
    &$beyondComparePath /silent `@"comparisonScript.txt" "$latestFile" "$savedFileName" "$reportFileName"
}

Remove-Item .\current.html