Get-Module Pester | Remove-Module 
$p = Import-Module Pester -MaximumVersion 4.9.9 -PassThru
"Reloaded, using Pester $($p.Version)."

. $PSSCriptRoot\Should-All.ps1



2, 3, 4, 5, 6, 7 | Should -All { $_ % 2 -eq 0 }



Describe "Should -All" {
    It "Passes when all numbers meet the filter" {
        $evenNumbers = 2, 4, 6, 8, 10
        $evenNumbers | Should -All { $_ % 2 -eq 0 } 
    }

    It "Fails when any number does not meet the filter" { 
        $mixedNumbers = 2, 3, 4 
        { $mixedNumbers | Should -All { $_ % 2 -eq 0 } } | Should -Throw -ErrorId "PesterAssertionFailed"
    }
}


