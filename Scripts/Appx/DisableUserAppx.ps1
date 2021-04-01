$EnabledPackages = Get-UevAppxPackage -CurrentComputerUser -Verbose | Where-Object { $_.Enabled -eq $true }
$EnabledPackages | ForEach-Object {
    $_ | Disable-UevAppxPackage -CurrentComputerUser -Verbose
}

Write-Host -ForegroundColor:Yellow "Comparison of now enabled packages."
Compare-Object -ReferenceObject $EnabledPackages -DifferenceObject $(Get-UevAppxPackage -CurrentComputerUser -Verbose | Where-Object { $_.Enabled -eq $true })