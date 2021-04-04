Try {
    $UevTemplatePath = Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\UEV\Agent\Configuration -Name SettingsTemplateCatalogPath `
    -ErrorAction:Stop | Select-Object -Property SettingsTemplateCatalogPath
}
Catch {
    $UevTemplatePath = Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Uev\Agent\Configuration -Name SettingsTemplateCatalogPath `
    -ErrorAction:Stop | Select-Object -Property SettingsTemplateCatalogPath
}
$UevTemplatePath = $UevTemplatePath.SettingsTemplateCatalogPath
if(!$?){
    Write-Host -ForegroundColor:Red "No template storage path located on the computer. Terminating script."
    [Environment]::Stop()
}

$Templates = Get-ChildItem -Path "$($UevTemplatePath)" -Filter "*.xml" -Recurse
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
    $UevTemplate | Unregister-UevTemplate -Verbose
}