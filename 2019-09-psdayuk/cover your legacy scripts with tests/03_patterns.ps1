
Get-Module Pester, Assert | Remove-Module 
Import-Module Pester -MinimumVersion 4.0
Import-Module Assert -MinimumVersion 0.9
cd $PSScriptRoot

"Initialized, run the script step by step 🚀"


break


function Reverse-String ($s) {
    $a = $s.ToCharArray()
    [array]::Reverse($a)
    -join $a 
}

Describe 'input -> output' {
    It -TestCases @(
        @{ In = 'Jakub'; Out = 'bukaJ' }
        @{ In = 'Jaap';  Out = 'paaJ'  }
    ) "requires no mock, just input output pairs" {
        param($In, $Out) 

        Reverse-String $In | Should -BeExactly $Out
    }
}


break

function Rename-Computer ($NewName) {
    # missing cmdlet on macOS    
}

function Set-StandardizedComputerName ($Name) { 
    $n = $Name.ToUpperInvariant()
    Rename-Computer -NewName $n
}

Describe 'input -> mock' {
    It "requires empty mock for the cmdlet that does the actual work + assert-mockcalled" {
        Mock Rename-Computer {}

        Set-StandardizedComputerName -Name "mypc"

        Assert-MockCalled Rename-Computer -ParameterFilter { $NewName -ceq "MYPC" }  -Exactly 1
    }
}


break


function Get-FormattedDate ($Date) {
    (Get-Date).ToString('yyyy-MM-dd')
}

Describe "mock -> output" {
    It "requires mock with behavior for the cmdlet that does the work + some assertion" {
        Mock Get-Date { 
            [DateTime]::MinValue
            
            # also show how to produce this object using the original cmdlet 
        }

        $formattedDate = Get-FormattedDate 

        $formattedDate | Should -Be "0001-01-01"
    }
}


break 

function Stop-AllPowerShellProcesses {
    Get-Process -Name powershell | 
        Stop-Process 
}

Describe "mock -> mock" {
    It "requires at least two mocks" { 
        Mock Get-Process { 
            [pscustomobject]@{ Name = 'dummy' }
            [pscustomobject]@{ Name = 'yummy' }
        }

        Mock Stop-Process {} 

        Stop-AllPowerShellProcesses

        Assert-MockCalled Stop-Process `
            -ParameterFilter { $Name -in 'dummy', 'yummy' } `
            -Exactly 2
    }
}