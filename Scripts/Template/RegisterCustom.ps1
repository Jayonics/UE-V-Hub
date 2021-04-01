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

Get-ChildItem -Path "$($UevTemplatePath)" -Filter "*.xml" | ForEach-Object {
    Register-UevTemplate -Path $($_.FullName) -Verbose
}