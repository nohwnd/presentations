Get-Module Pester | Remove-Module
Import-Module Pester -MinimumVersion 5.0.0 -DisableNameChecking -ErrorAction Stop

$p = Get-Module Pester


$function:global:prompt = { "> "}
cls
Write-Host "Using Pester v$($p.Version), let's 🤘!"
