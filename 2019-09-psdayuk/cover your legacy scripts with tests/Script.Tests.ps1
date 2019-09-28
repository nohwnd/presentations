

Get-Module Pester, Import-Script | Remove-Module 
Import-Module Pester -MinimumVersion 4.0
Import-Module $PSScriptRoot\Import-Script.psm1
function prompt () { "> " }

cd $PSScriptRoot

"Initialized, run the script step by step 🚀"

# break

Import-Script -Path .\Script.ps1 -EntryPoint 'Main' -Parameters @{ Name = 'Jakub' }

Describe "t1.ps1" {
    It "Can test 'Main' function" {
        Main -Name 'PSPowerHour' | Should -Be 'Hello, PSPowerHour!'
    }

    It "Can test 'Get-Greeting' function" {
        Get-Greeting -Name 'PSPowerHour' | Should -Be 'Hello, PSPowerHour!'
    }

    It "Can mock Get-GreetingText that is used by Get-GreetingFunction" {
        Mock Get-GreetingText { 'I ❤ {0}!'  }
        Get-Greeting -Name 'PSPowerHour' | Should -Be 'I ❤ PSPowerHour!'
    }
}

break

function placeholder { 
    Write-Host "this is a placeholder" -ForegroundColor Cyan 
}
Set-Alias Main 'placeholder'

. .\Script.ps1 -Name 'Jakub'

Remove-Item "alias:Main" -Force

Main -Name "Jakub"

break 


&{ 

    function a () { "hello" }
}


a