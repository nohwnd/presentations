Get-Module M, P | Remove-Module

New-Module -Name M { 
    $script:a = "module M"
    function Get-ModuleSessionState {
        $ExecutionContext.SessionState
    }


    function Get-CallerSessionState {
        [CmdletBinding()]
        param()

        $PSCmdlet.SessionState
    }

} | Import-Module

New-Module -Name P {
    function Get-CallerSessionStateFromModuleP {
        Get-CallerSessionState
    }
} | Import-Module


$ss = $ExecutionContext.SessionState
$ssm = Get-ModuleSessionState 
$ssc = Get-CallerSessionState
$ssp = Get-CallerSessionStateFromModuleP

break 

# having the session state gives us a lot of power
# we can peek into module M and see it's internal variable
$ssm.PSVariable.GetValue("a")

break 

# another way of peeking into module M
# useful when you are debugging a module

$m = Get-Module M
& ($m) {
    $script:a
}

# - $ExecutionContext.SessionState.Module is a great way of checking where you are when playing with modules



