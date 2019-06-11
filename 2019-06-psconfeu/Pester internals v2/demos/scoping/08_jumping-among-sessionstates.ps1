# Dave Wyatt came up wit this :) Thanks!
# $sessionStateInternal = $sessionState.Internal
# $scriptBlock.SessionStateInternal = $sessionStateInternal

Get-Module M, P, Q | Remove-Module

New-Module -Name M {
    $script:a = "module M"

    function Invoke-OriginalScriptBlock ($ScriptBlock) {
        & $ScriptBlock
    }

    function Invoke-ModifiedScriptBlock ($ScriptBlock) {
        $newSb = [ScriptBlock]::Create("'Hello!'`n$ScriptBlock")

        & $newSb
    }

    function Invoke-InCallerSessionState {
        [CmdletBinding()]
        param ($ScriptBlock)

        $newSb = [ScriptBlock]::Create("'Hello!'`n$ScriptBlock")

        $sessionState = $PSCmdlet.SessionState

        $flags = [System.Reflection.BindingFlags]'Instance,NonPublic'
        
        # Dave Wyatt came up wit this :) Thanks!
        # $sessionStateInternal = $sessionState.Internal
        # $scriptBlock.SessionStateInternal = $sessionStateInternal

        $sessionStateInternal = [Management.Automation.SessionState].GetProperty(
            'Internal', $flags).GetValue($sessionState, $null)
        
        [ScriptBlock].GetProperty(
            'SessionStateInternal', $flags).SetValue(
                $newSb, $SessionStateInternal)

        & $newSb
    }

    function Invoke-InOriginalSessionState {
        [CmdletBinding()]
        param ($ScriptBlock)

        $flags = [Reflection.BindingFlags]'Instance,NonPublic'
        
        # $sessionStateInternal = $ScriptBlock.SessionStateInternal
        $sessionStateInternal = [ScriptBlock].GetProperty(
            'SessionStateInternal', $flags).GetValue($ScriptBlock, $null)
        
        $newSb = [ScriptBlock]::Create("'Hello!'`n$ScriptBlock")

        # $ScriptBlock.SessionStateInternal = $sessionStateInternal
        [ScriptBlock].GetProperty(
            'SessionStateInternal', $flags).SetValue(
                $newSb, $SessionStateInternal)

        & $newSb                
    }

    function Invoke-InGivenSessionState {
        param ($ScriptBlock, $SessionState)

        $newSb = [ScriptBlock]::Create("'Hello!'`n$ScriptBlock")

        # invokes in the session state we gave it
        # e.g. inside of a module that we looked up
        $flags = [System.Reflection.BindingFlags]'Instance,NonPublic'
        
        # $sessionStateInternal = $sessionState.Internal
        $sessionStateInternal = [Management.Automation.SessionState].GetProperty(
            'Internal', $flags).GetValue($SessionState, $null)

        # $ScriptBlock.SessionStateInternal = $sessionStateInternal
        [ScriptBlock].GetProperty(
            'SessionStateInternal', $flags).SetValue(
                $newSb, $SessionStateInternal)
                
        & $newSb
    }
} | Import-Module

New-Module -Name P { 
    $script:a = "module P"
    $sbP = { 
        $script:a
    }
    Export-ModuleMember -Variable sbP
} | Import-Module

New-Module -Name Q { 
    $script:a = "module Q" 
    $sbQ = { 
        $script:a
    }
    Export-ModuleMember -Variable sbQ 
} | Import-Module

break 

$script:a = "script session state"

$sb = { 
    $script:a
}

# this one we know, it prints the value of $script:a
Invoke-OriginalScriptBlock $sb

break 

# the sb is recreated in the module, to say hello at 
# the start but at the same time it gets bound to module 
# session state because re-creating the scriptblock binds 
# it to the current session state -> to module M
Invoke-ModifiedScriptBlock $sb

break 

# the sb is re-created by $PSCmdlet is used to get 
# caller session state and invoke the sb in it
# so the scriptblock is bound to module M but 
# temporarily invoked in script session state
Invoke-InCallerSessionState $sb

break 

# caller session state is not always where the script block is 
# coming from so sb from module P is incorrectly invoked 
# in script session state
& $sbP
Invoke-InCallerSessionState $sbP

break 

& $sbP
Invoke-InOriginalSessionState $sbP

break 

# lastly make a scriptblock here but invoke it in module P session state

$p = Get-Module P
& $sb
Invoke-InGivenSessionState -ScriptBlock $sb -SessionState $p.SessionState

# Usages in Pester:
# - changing the scriptblock and invoking it in caller scope -> e.g. add param block to mockWith, and parameterFilter
# - making scriptblock in invoking it in caller scope -> defining mocks
# - making scriptblock and invoking it in some module scope -> when looking for private module functions





