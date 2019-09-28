
Get-Module Pester, Assert | Remove-Module 
Import-Module Pester -MinimumVersion 4.0
Import-Module Assert -MinimumVersion 0.9
cd $PSScriptRoot

"Initialized, run the script step by step 🚀"


break

function Get-WmiObject { 
    # missing cmdlet on MacOS
}

function Set-StandardizedComputerNameViaWmi ($Name) { 
    $n = $Name.ToUpperInvariant()
    $o = Get-WmiObject -Class Win32_ComputerSystem
    
    $returnCode = $o.Rename($n)
    
    1 -eq $returnCode
}

Describe 'cmdlet that returns object with behavior' {
    It "makes us fake the returned object, and store the method call values in it" {
        $rename = {
            param($Name) 
            
            # store the param value for further reference
            $this.__name = $Name

            # return proper return code to ensure
            # the function will pass
            1
        } 

        $p = [pscustomobject]@{
            __name = ''
        } | Add-Member -MemberType ScriptMethod -Name Rename -Value $rename -PassThru


        Mock Get-WmiObject {
            $p
        }
        
        Set-StandardizedComputerNameViaWmi -Name "mypc"

        # verify the behavior here, just like with Assert-MockCalled
        $p.__name | Should -BeExactly "MYPC"
    }
}
