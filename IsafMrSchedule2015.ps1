$_watcher = 'IsafMrSchedule2015'
$_url = 'http://www.sailing.org/regattasearch.php?nocache=1&includeref=regattasearch&regattadiscipline=1&regattatype=1&regattayear=2015&regattacountry=211'
$_xpath = '//table[@class="results"]'
$_alertPath = [Environment]::GetFolderPath('Desktop')

Import-Module .\Run-Web-Watch.psm1

Run-Web-Watch $_watcher $_url $_xpath $_alertPath

Remove-Module Run-Web-Watch