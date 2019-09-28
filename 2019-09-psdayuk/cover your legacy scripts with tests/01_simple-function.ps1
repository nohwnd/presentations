
Get-Module Pester, Assert | Remove-Module 
Import-Module Pester -MinimumVersion 4.0
Import-Module Assert -MinimumVersion 0.9
cd $PSScriptRoot

"Initialized, run the script step by step 🚀"

break

function ConvertTo-Base64 {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Value
    )

    $bytes = [System.Text.Encoding]::UTF8.GetBytes($Value)
    $result = [Convert]::ToBase64String($bytes)
    $result
}

Describe "ConvertTo-Base64" { 
    
    It "Encodes string 'PSDayUK 2019' as 'UFNEYXlVSyAyMDE5'" {
        $Expected = 'UFNEYXlVSyAyMDE5'
        $actual = ConvertTo-Base64 'PSDayUK 2019'
        $actual | Should -BeExactly $Expected
    }
}


break 

Describe "Provide multiple examples ConvertTo-Base64" {
    It -TestCases @(
        @{ Value = 'PSDayUK 2019'
           Expected = 'UFNEYXlVSyAyMDE5' }

        @{ Value = '@nohwnd'
           Expected = 'QG5vaHduZA==' }

        @{ Value = 'Pester ❤'
           Expected = 'UGVzdGVyIOKdpA==' }

    ) "Encodes string <value> as <expected>" {
        param($Value, $Expected)

        $actual = ConvertTo-Base64 $Value
        $actual | Should -BeExactly $Expected
    }
}

break

Describe "non-functional requiremets" {

    It "Has mandatory parameter Value" { 
        $command = Get-Command ConvertTo-Base64 
        $mandatory = $command.Parameters['Value'].Attributes.Mandatory
        $mandatory | Should -BeTrue -Because "because the Value parameter should be mandatory"
    }

}

break 

# but the code is ugly, so how about adding our own params to Should

Add-ShouldOperator -Name HaveMandatoryParameter -Test {
    param ($ActualValue, [string]$ParameterName, [switch] $Negate, [string] $Because)

    # look at  https://github.com/pester/Pester/blob/master/Functions/Assertions/BeTrueOrFalse.ps1
    # for inspiration, or here https://mathieubuisson.github.io/pester-custom-assertions/

    if ($null -eq $ActualValue -or $ActualValue -isnot [Management.Automation.CommandInfo])
    {
        throw "Input value must be non-null CommandInfo object. You can get one by calling Get-Command."
    }

    $isMandatory = [bool] $ActualValue.Parameters[$ParameterName].Attributes.Mandatory 

    if ((-not $Negate -and $isMandatory) -or ($Negate -and -not $isMandatory)) {
        [psCustomObject]@{ Succeeded = $true }
    }

    if (-not $Negate) 
    {
        [psCustomObject] @{
            Succeeded      = $false
            FailureMessage = "Expected command $($ActualValue.Name) to have mandatory parameter $ParameterName, but it did not have it."
        }
    }
    else 
    {
        [psCustomObject] @{
            Succeeded      = $false
            FailureMessage = "Expected command $($ActualValue.Name) to not have mandatory parameter $ParameterName, but it had it."
        }
    }
}

Describe "non-functional requirements" {
    It "Has mandatory parameter Value" { 
        Get-Command ConvertTo-Base64 | Should -HaveMandatoryParameter 'Value'
    }
}


break 

Describe "non-functional requirements" {
    It "Has mandatory parameter Value" { 
        Get-Command ConvertTo-Base64 | Should -HaveParameter -Mandatory 'Value'
    }
}

