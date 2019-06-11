# running in other scopes is not safe because built-in cmdlets 
# may not work there, so how do we get an internal command 
# of a user specified module and to log to screen safely

Get-Module M, P | Remove-Module 

New-Module -Name P -ScriptBlock { 
    # user is overwriting commands that we need
    # (e.g. when they mock Write-Host in a test)
    function Write-Host { "nope" }
    function Get-Command { "you are out of luck" }

    # we are trying to grab this internal function
    function Get-Avocado {
        '🥑'
    }

    Export-ModuleMember -Function @()
} | Import-Module

New-Module -Name M -ScriptBlock {
    
    function Get-CommandFromModuleBroken {
        [CmdletBinding()]
        param($ModuleName, $CommandName)

        $m = Get-Module -Name $ModuleName
        
        & ($m) {
            param ($CommandName, $ModuleName)
            Write-Host "Looking for $CommandName in $ModuleName"
            Write-Host "Running in $($ExecutionContext.SessionState.Module)"
            Get-Command $CommandName -ModuleName $ModuleName

        } $CommandName, $ModuleName
    }

    function Get-CommandFromModule {
        [CmdletBinding()]
        param($ModuleName, $CommandName)

        # in Pester this would be $SafeCommands['Write-Host'] a reference to 
        # what we know is the real command so we are not affected by mocks
        $Write_Host = Get-Command Write-Host -CommandType Cmdlet -Module Microsoft.PowerShell.Utility
        $Get_Command = Get-Command Get-Command -CommandType Cmdlet -Module Microsoft.PowerShell.Core


        $module = Get-Module -Name $ModuleName    
        $log = $false
        $parameters = @{
            CommandName = $CommandName
            ModuleName = $ModuleName
            
            Get_Command = $Get_Command
            # you can even call back to a scriptblock that 
            # wraps some of your reusable logic and will execute back in the module 
            Write_Host = { 
                param ($Message) 
                # log is resolved from parent scope
                if ($log) {
                    & $Write_Host -BackgroundColor Yellow -ForegroundColor Black " $Message "
                }
            }
        }

        & ($module) {
            # - bundle params to avoid conflics with user params
            # not necessary here, but if we used this to call user 
            # code inside of our code it would be a real problem
            # - use non-conflicting, unique name
            # - bundled params are easier to pass then passing by position
            param ($__parameters)
            & $__parameters.Write_Host "Looking for $($__parameters.CommandName) in $($__parameters.ModuleName)"
            & $__parameters.Write_Host "Running in $($ExecutionContext.SessionState.Module)"
            & $__parameters.Get_Command $__parameters.CommandName -ModuleName $__parameters.ModuleName

        } $parameters
    }
} | Import-Module 

break 

# this fails because the module "mocks" some of the built-in functions
$command = Get-CommandFromModuleBroken -ModuleName 'P' -CommandName 'Get-Avocado'
$command

break 

# this passes because we provided original versions of the commands we depend on
$command = Get-CommandFromModule -ModuleName 'P' -CommandName 'Get-Avocado'
$command
& $command

# - invocation operator can invoke references to functions as well so you can use it to hold onto a knows safe version of a command
# - scriptblocks can take parameters 
