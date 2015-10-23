function Run-Web-Watch {
	param (
		[string] $watcher,
		[string] $url,
		[string] $xpath,
		[string] $alertPath
	)

	cls 

	if (Test-Path ${env:ProgramFiles(x86)}) { $beyondComparePath = '{0}\Beyond Compare 4\BCompare.exe' -f ${env:ProgramFiles(x86)}}
	else { $beyondComparePath = '{0}\Beyond Compare 4\BCompare.exe' -f $env:ProgramFiles }

	$runningFolder = '{0}\Dropbox\Sailing\ScheduleWatching' -f $env:USERPROFILE
	$outputPath = '{0}\{1}' -f $runningFolder, $watcher

	add-type -Path $runningFolder\HtmlAgilityPack.dll
	$htmlweb = New-Object htmlagilitypack.htmlweb

	$previousFile = Get-ChildItem -Path $runningFolder\$watcher -Filter *_source.html | Sort-Object LastAccessTime -Descending | Select-Object -First 1
	$previousFilePath = '{0}\{1}' -f $outputPath, $previousFile
	$currentFilePath = '{0}\current.html' -f $outputPath

	$htmldocument = $htmlweb.Load($url)
	$htmldocument.DocumentNode.SelectSingleNode($xpath).OuterHtml | Out-File ($currentFilePath)

	$currentFileContents = [IO.File]::ReadAllText($currentFilePath)
	$previousFileContents = [IO.File]::ReadAllText($previousFilePath)
	$comparison = $currentFileContents.CompareTo($previousFileContents)

	if($comparison)
	{
		$timestamp = (get-date -Format yyyyMMddHmmss)
		$sourceFilePath = '{0}\{1}_source.html' -f $outputPath, $timestamp
		$diffFilePath = '{0}\{1}_diff.html' -f $outputPath, $timestamp
		
		Copy-Item $currentFilePath $sourceFilePath

		$comparisonScriptPath = '{0}\comparisonScript.txt' -f $runningFolder
		&$beyondComparePath /silent `@$comparisonScriptPath $previousFilePath $sourceFilePath $diffFilePath | Out-Null
	
		Copy-Item $diffFilePath $alertPath
	}

	Remove-Item $currentFilePath
}

export-modulemember -function Run-Web-Watch