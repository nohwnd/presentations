
Get-Module Pester, Assert | Remove-Module 
Import-Module Pester -MinimumVersion 4.0
Import-Module Assert -MinimumVersion 0.9
cd $PSScriptRoot

"Initialized, run the script step by step 🚀"

break

Import-Module .\m1.psm1 

break 

Describe "Get-Greeting" { 
    It "Can test 'Get-Greeting' function" {
        Get-Greeting -Name 'Pester' | Should -Be 'Hello, Pester!'
    }

    It "Cannot mock Get-GreetingText that is used by Get-GreetingFunction" {
        Mock Get-GreetingText { 'I ❤ {0}!' }
        Get-Greeting -Name 'Pester' | Should -Be 'I ❤ Pester!'
    }

    InModuleScope -ModuleName m1 {
        It "Can mock internal Get-GreetingText function, that is used by Get-GreetingFunction" {
            Mock Get-GreetingText { 'I ❤ {0}!' }
            # Write-Host "Module: $($ExecutionContext.SessionState.Module)"
            Get-Greeting -Name 'Pester' | Should -Be 'I ❤ Pester!'
        }
    }

    It "Can mock internal Get-GreetingText function, that is used by Get-GreetingFunction" {
        Mock Get-GreetingText { 'I ❤ {0}!' } -ModuleName "m1"
        # Write-Host "Module: $($ExecutionContext.SessionState.Module)"
        Get-Greeting -Name 'Pester' | Should -Be 'I ❤ Pester!'
    }

    # describe the difference between InModuleScope and -ModuleName
}




