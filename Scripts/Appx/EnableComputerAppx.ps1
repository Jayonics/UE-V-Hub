$DisabledPackages = Get-UevAppxPackage -Computer -Verbose | Where-Object { $_.Enabled -eq $false }
$DisabledPackages | ForEach-Object {
    $_ | Enable-UevAppxPackage -Computer -Verbose
}

Write-Host -ForegroundColor:Yellow "Comparison of now enabled packages."
Compare-Object -ReferenceObject $DisabledPackages -DifferenceObject $(Get-UevAppxPackage -Computer -Verbose | Where-Object { $_.Enabled -eq $false })