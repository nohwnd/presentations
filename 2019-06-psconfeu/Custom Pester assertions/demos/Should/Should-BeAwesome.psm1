
function Should-BeAwesome {
    param ($ActualValue)

    if ("Jaap" -eq $ActualValue -or "attending psconfeu" -eq $ActualValue) {
        return [PSCustomObject]@{
            Succeeded  = $true
            FailureMessage = $null
        }
    }
    else {
        return [PSCustomObject]@{
            Succeeded  = $false
            FailureMessage = "Expected something awsome but got >>$ActualValue<<."
        }
    }
}

# add the operator to should
# define one or more aliases
Add-ShouldOperator `
    -Name BeAwesome `
    -Alias "EnsureAwesomeness" `
    -InternalName "Should-BeAwesome" `
    -Test ${function:Should-BeAwesome}


Export-ModuleMember -Function @() 


# Get-Module Pester | Remove-Module ; Import-Module Pester -MaximumVersion 4.9.9 ; Import-Module ./Should-BeAwesome.psm1