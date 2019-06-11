& "$PSScriptRoot\..\setup.ps1"

$runResult = Invoke-Pester -ScriptBlock {
    BeforeAll {
        #setup
    }
    Describe "d1" {
        Describe "d11" {
            It "i0" {  }
            It "i1" {  }
            It "i2" {  } -Tag "t1"
            It "i3" { throw "error"  }
            It -TestCases @(
                @{ Value = 10 }
                @{ Value = 11 }
            ) "i4" {  }
        }
    }

    Describe "d2" {
        It "i6" {}
    }
} -PassThru

break 

$runResult.ShouldRun
$runResult.Executed

$runResult.OneTimeTestSetup

$runResult.Blocks.Count
$runResult.Blocks[0]
$runResult.Blocks[0].Name

$runResult.Blocks[0].Blocks[0].Tests[3].Name
$runResult.Blocks[0].Blocks[0].Tests[3].Path -join " - "
$runResult.Blocks[0].Blocks[0].Tests[3].ShouldRun
$runResult.Blocks[0].Blocks[0].Tests[3].Executed
$runResult.Blocks[0].Blocks[0].Tests[3].Passed
$runResult.Blocks[0].Blocks[0].Tests[3].ErrorRecord
$runResult.Blocks[0].Blocks[0].Tests[3].Duration

$runResult.Blocks[0].Blocks[0].Tests.Count

$runResult.Blocks[0].Blocks[0].Tests[4].Name
$runResult.Blocks[0].Blocks[0].Tests[4].Id
$runResult.Blocks[0].Blocks[0].Tests[4].Data

$runResult.Blocks[0].Blocks[0].Tests[5].Name
$runResult.Blocks[0].Blocks[0].Tests[5].Id
$runResult.Blocks[0].Blocks[0].Tests[5].Data


