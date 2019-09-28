
function Import-Script { 
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String] $Path,
        [Hashtable] $Parameters = @{},
        [Object[]] $Arguments = @(),
        [String] $EntryPoint = 'Main'
    )

    $sb = {
        param ($__c, $__arguments, $__parameters)

        Invoke-Expression "
        function __placeholder () { 
            Write-Host ```
                'This is a placeholder running instead of $($__c.EntryPoint)' ```
                -ForegroundColor Yellow
        }"
        Set-Alias -Name $__c.EntryPoint -Value '__placeholder'
        
        . $__c.Path @__arguments @__parameters

        Remove-Item "alias:\$($__c.EntryPoint)" -Force
        Remove-Item 'function:\__placeholder' -Force
        Remove-Variable -Scope Local -Name '__c', '__arguments', '__parameters'
    }

    $__c = @{
        Path = $Path
        EntryPoint = $EntryPoint
    }

    Set-ScriptBlockScope -SessionState $PSCmdlet.SessionState -ScriptBlock $sb

    . $sb $__c $Arguments $Parameters
}

function Set-ScriptBlockScope {
    param (
        [Parameter(Mandatory)]
        [Management.Automation.SessionState] $SessionState,
        [Parameter(Mandatory)]
        [ScriptBlock] $ScriptBlock
    )

    $flags = [System.Reflection.BindingFlags]'Instance,NonPublic'
    $SessionStateInternal = $SessionState.GetType().GetProperty('Internal', $flags).GetValue($SessionState, $null)

    # attach the original session state to the wrapper scriptblock
    # making it invoke in the caller session state
    $ScriptBlock.GetType().GetProperty('SessionStateInternal', $flags).SetValue($ScriptBlock, $SessionStateInternal, $null)
}

Export-ModuleMember -Function Import-Script