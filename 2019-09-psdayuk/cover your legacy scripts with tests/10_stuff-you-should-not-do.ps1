
Get-Module Pester, Assert | Remove-Module 
Import-Module Pester -MinimumVersion 4.0
Import-Module Assert -MinimumVersion 0.9
cd $PSScriptRoot

"Initialized, run the script step by step 🚀"

break

<# here you are substituting two different scenarios 
1) the mock should return different values for different paramteters, in that case make two mocks, with appropriate -parameters filters (Say first Get-User call is to get user Jakub, and the second call is to get user named Jaap).
2) You are testing against environment bound or non-determenistic cmdlet, like get-random, or get-date, which does not take any parameters. In that case you should extract the behavior to a separate function that takes two different inputs, and test that.
#>
Describe "Stateful mock" { 
    $script:call = 0
    function f () {}
    Mock f {
        (++$script:call)
    }

    It "does one thing on first call" {
        f | Should -Be 1
    }

    It "does one thing on first call" {
        f | Should -Be 2
    }
}

break 

# every Should -Not -Throw contains a more comprehensive test
Describe "Should not throw" {
    It "Does not throw when closing task" {
        $id = "10005"
        { Close-Task $id } | Should -Not -Throw
    }

    It "Closes the task" {
        $id = "10005"
        Close-Task -Id $id

        $task = Get-Task -Id $id
        $task.Status | Should -Be "Closed"
    }
}

break

