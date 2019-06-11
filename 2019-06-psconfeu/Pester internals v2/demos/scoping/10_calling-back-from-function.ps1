# when mock is defined it needs to call back to internal Pester functions
# to count calls and get the actual behavior. To avoid publishing internal 
# functions or looking them up all the time, I pass the reference via a static
# object that is easily accessible from both sides

Get-Module M | Remove-Module 

New-Module -Name M -ScriptBlock {
    $script:count = 0
    $script:behavior = $null

    # this is only internal
    function Invoke-MockInternal {
        $script:count++
        & $script:behavior
    }

    function New-Mock {
        [CmdletBinding()]
        param($MockWith) 

        $script:behavior = $MockWith

        $defineFunction = {
            $mock = {
                # call back into the module scope via reference to
                # an internal module function
                & $MyInvocation.MyCommand.Mock.Invoke_MockInternal
            }

            $ExecutionContext.InvokeProvider.Item.Set("Function:\script:f", $mock, $true, $true)[0]            
        }

        # bind to caller session state so the function is defined
        # in the correct place
        Bind-ToSessionState -SessionState $PSCmdlet.SessionState -ScriptBlock $defineFunction 
        
        $definedFunction = & $defineFunction

        $functionLocalData = @{
            Invoke_MockInternal = Get-Command Invoke-MockInternal
        }

        Add-Member `
            -InputObject $definedFunction `
            -MemberType NoteProperty `
            -Name Mock `
            -Value $functionLocalData `
            -Force
    }

    function Get-CallCount {
        $script:count
    }

    function Bind-ToSessionState ($ScriptBlock, $SessionState) { 
        $flags = [System.Reflection.BindingFlags]'Instance,NonPublic'
        $sessionStateInternal = [Management.Automation.SessionState].GetProperty(
            'Internal', $flags).GetValue($SessionState, $null)

        [ScriptBlock].GetProperty(
            'SessionStateInternal', $flags).SetValue(
                $ScriptBlock, $SessionStateInternal)
    }

    Export-ModuleMember -Function New-Mock, Get-CallCount
} | Import-Module 

$script:a = "script session state"

New-Mock -MockWith {
    "mock was invoked"
    $script:a
}

f

Get-CallCount

# - We can attach function references to the command object, or some other global place to avoid exposing them 
#    from the module

# - Pester v4 simply exposes them anyway 
# - Pester v5 uses the described technique
# - but during the preparation I realized that I can just define the function in the caller scope using a module bound scriptblock, which call back into the module session state directly, kind of dynamically publishing functions from module