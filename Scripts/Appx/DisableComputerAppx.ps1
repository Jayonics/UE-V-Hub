$EnabledPackages = Get-UevAppxPackage -Computer -Verbose | Where-Object { $_.Enabled -eq $true }
$EnabledPackages | ForEach-Object {
    $_ | Disable-UevAppxPackage -Computer -Verbose
}

Write-Host -ForegroundColor:Yellow "Comparison of now enabled packages."
Compare-Object -ReferenceObject $EnabledPackages -DifferenceObject $(Get-UevAppxPackage -Computer -Verbose | Where-Object { $_.Enabled -eq $true })