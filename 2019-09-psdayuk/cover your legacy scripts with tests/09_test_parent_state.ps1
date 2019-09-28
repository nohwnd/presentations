
Get-Module Pester, Assert | Remove-Module 
Import-Module Pester -MinimumVersion 4.0
Import-Module Assert -MinimumVersion 0.9
cd $PSScriptRoot

"Initialized, run the script step by step 🚀"

break

Get-Module m | Remove-Module 
New-Module -Name m -ScriptBlock { 
    $script:writeDebug = $false
    function Write-Log ($Message) {
            Write-Host -ForegroundColor Blue $Message
    }
    function Get-ReadableSummary { 
        Start-Sleep -Milliseconds 100
    }
    function A { 
        if ($script:writeDebug) {
            # this is wrapped in an if for performance reasons
            $summary = Get-ReadableSummary  # convenient but expensive to figure out
            Write-Log -Debug "A debugging message $that $contains $multiple $properties and $summary."
        }
    }

    Export-ModuleMember -Function 'A', 'Enable-WriteDebug'
} | Import-Module


Describe "Write-Log" {
    It "Writes log when writeDebug is set to `$true" {

        Mock Get-ReadableSummary -ModuleName 'm' { 
            if (-not $script:writeDebug) { 
                throw "Get-ReadableSummary should never be called when `$script:writeDebug is set to false for performance reasons."
            }
        }

        A 
    }
}