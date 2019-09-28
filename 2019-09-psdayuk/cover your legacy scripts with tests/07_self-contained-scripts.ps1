

Get-Module Pester, Import-Script | Remove-Module 
Import-Module Pester -MinimumVersion 4.0
Import-Module $PSScriptRoot\Import-Script.psm1
cd $PSScriptRoot

"Initialized, run the script step by step 🚀"

break

# mock the entrypoint function so
# we don't run anything from the script
$EntryPoint = 'Main'
$Path = "./script.ps1"
Invoke-Expression 'function placeholder { Write-Host "this is placeholder for $EntryPoint" }'
# alias to prevent main from running
Set-Alias $EntryPoint 'placeholder'

. $Path -Name 'Jakub'

# go ahead and try running Main again
Main -Name "Jakub" 

# remove the alias, now we have all functions
# from the script dot-sourced in this scope
# and can test them
Remove-Item "alias:$EntryPoint" -Force
Remove-Item "function:placeholder" -Force

# runs  the actual function
Main -Name 'Jakub'

# or 
Import-Script -Path .\script.ps1 -EntryPoint 'Main' -Arguments '-Name Jakub'

Describe "t1.ps1" {
    It "Can test 'Main' function" {
        Main -Name 'PSDayUK' | Should -Be 'Hello, PSDayUK!'
    }

    It "Can test 'Get-Greeting' function" {
        Get-Greeting -Name 'PSDayUK' | Should -Be 'Hello, PSDayUK!'
    }

    It "Can mock Get-GreetingText that is used by Get-GreetingFunction" {
        Mock Get-GreetingText { 'I ❤ {0}!'  }
        Get-Greeting -Name 'PSDayUK' | Should -Be 'I ❤ PSDayUK!'
    }
}

break 

# why is this magic when doing it automatically

# Caller  Module
#   4       4
#   3       3  
#   2       2 <-
#   1       1
#   0 <-    0

# this is like a function call
&{ 
    # this is like dot-sourcing
    function a () { "hello" }
}

# the function won't exist outside of the previous scriptblock
a