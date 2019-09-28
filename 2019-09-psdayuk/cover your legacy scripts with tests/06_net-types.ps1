
Get-Module Pester, Assert | Remove-Module 
Import-Module Pester -MinimumVersion 4.0
Import-Module Assert -MinimumVersion 0.9
cd $PSScriptRoot


"Initialized, run the script step by step 🚀"


break


Describe "Dealing with .NET Types" {

    It "Cannot change calls to static properties on an object" {
        # don't do this
        $now = [DateTime]::Now 
        
        # call the appropriate cmdlet or your wrapper function instead
        Mock Get-Date { [DateTime]::MinValue }
        $now = Get-Date

        $now | Should -Be ([DateTime]::MinValue)
    }

    It "Cannot change calls to static methods on an object" {
        # don't do this
        $id = [Guid]::NewGuid() 
        
        # wrap your static calls to functions instead
        function New-Guid () { [Guid]::NewGuid().Guid }
        
        $id = New-Guid

        
        $id | Should -Not -Be ([Guid]::Empty.Guid)
    }

}