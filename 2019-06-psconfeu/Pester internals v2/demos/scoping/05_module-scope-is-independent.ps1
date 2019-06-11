# modules have their own sessionstate

Get-Module M | Remove-Module 
New-Module -Name M -ScriptBlock {
    $script:a = "module"

    function Get-A {
        $script:a
    }

} | Import-Module 

# module and caller scopes and session states are independent 
# $script refers to two different scopes in two different session states
# based on where it is called from

$script:a = "script"

$script:a 
Get-A  

## if you ever wrote a module you already know this :)
# - as with any other module the internal state is used to manage the data that 
# the module needs to do it's work