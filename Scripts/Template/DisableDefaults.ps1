$UevTemplatePath = "$env:PROGRAMDATA\Microsoft\UEV\InboxTemplates"
$Templates = Get-ChildItem -Path "$($UevTemplatePath)" -Filter "*.xml"

$CustomTemplateIDs = @()
ForEach ($File in $Templates) {
    [xml]$FileContent = Get-Content -Path "$($File.FullName)"
    $TemplateID = $($FileContent | Select-Xml -Xpath "/*").Node.ID.ToString()
    $CustomTemplateIDs += $TemplateID
}

$UevTemplates = @()
ForEach ($ID in $CustomTemplateIDs){
    $UevTemplates += Get-UevTemplate -TemplateID $ID
}

ForEach ($UevTemplate in $UevTemplates){
    $UevTemplate | Disable-UevTemplate -Verbose
}
Write-Host -ForegroundColor:Yellow "Waiting on the background jobs."