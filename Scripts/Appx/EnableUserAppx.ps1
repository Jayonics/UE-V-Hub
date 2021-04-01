$DisabledPackages = Get-UevAppxPackage -CurrentComputerUser -Verbose | Where-Object { $_.Enabled -eq $false }
$DisabledPackages | ForEach-Object {
    $_ | Enable-UevAppxPackage -CurrentComputerUser -Verbose
}

Write-Host -ForegroundColor:Yellow "Comparison of now enabled packages."
Compare-Object -ReferenceObject $DisabledPackages -DifferenceObject $(Get-UevAppxPackage -CurrentComputerUser -Verbose | Where-Object { $_.Enabled -eq $false })