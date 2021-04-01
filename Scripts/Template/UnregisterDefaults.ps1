$inboxTemplates= Get-ChildItem -Path "$env:PROGRAMDATA\Microsoft\UEV\InboxTemplates" -Filter *.xml
for ($count = 0; $count -lt $inboxTemplates.Count; $count++) {
    Unregister-UevTemplate -Path $inboxTemplates[$count].FullName -ErrorAction SilentlyContinue -Verbose
}