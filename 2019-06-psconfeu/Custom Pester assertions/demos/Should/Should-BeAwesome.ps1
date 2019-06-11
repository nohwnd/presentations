Get-Module Pester | Remove-Module 
$p = Import-Module Pester -MaximumVersion 4.9.9 -PassThru
"Reloaded, using Pester $($p.Version)."

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

break 



Describe 'awesome and disgusting stuff' {
    It 'knows the truth' {
        'Jaap' | Should -BeAwesome
    }

    It 'does not lie' {
        'attending psconfeu' | Should -EnsureAwesomeness
    } 

    It 'can distinguish awesomeness from other stuff' {
        'rotten fish' | Should -BeAwesome
    }
}

