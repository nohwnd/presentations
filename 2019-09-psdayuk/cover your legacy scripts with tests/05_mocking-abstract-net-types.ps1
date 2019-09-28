
Get-Module Pester, Assert | Remove-Module 
Import-Module Pester -MinimumVersion 4.0
Import-Module Assert -MinimumVersion 0.9
cd $PSScriptRoot

Import-Module "$PSScriptRoot/ComputerCommands/ComputerCommands/bin/Debug/ComputerCommands.dll"

"Initialized, run the script step by step 🚀"


break


Get-Command -Module ComputerCommands


$c = Get-AComputer -Name "MyComputer"

$c.GetType() | select FullName, IsPublic, IsAbstract, BaseType
$c.GetType().Assembly.Location

Set-AComputer -InputObject $c -Verbose
 

break 

# the idea here is to write
# Get-AComputer | Update-Computer -Description "computer1" | Set-AComputer

# check what types of values the Set-AComputer receives in the decompiler
#   - show inheritors
#   - show abstract class and interface

[ComputerCommands.LocalComputer]::new # <- fails the type is not public

break 

Add-Type -ReferencedAssemblies "./ComputerCommands/ComputerCommands/bin/Debug/ComputerCommands.dll" -TypeDefinition @" 
using ComputerCommands; 

public class TestComputer : Computer
{
    public string Name { get; set; }
    public string Description { get; set; }
}
"@

function Update-Computer {
    param( 
        [ComputerCommands.Computer] $InputObject,

        [String] $Description
    )

    $InputObject.Description = $Description.ToUpperInvariant()
    $InputObject
}

Describe "Wedging our code in between binary cmdlets" {

    It "updates description on the computer" {
        
       $computer = New-Object "TestComputer"
       $computer.Name = "Computer1"       
       
       $actual = Update-Computer -InputObject $computer -Description "This is our description." 

       $actual.Name | Should -BeExactly "Computer1"
       $actual.Description | Should -BeExactly "THIS IS OUR DESCRIPTION."
    }
}