# What happens when we execute a script block from inside of a module? 

break  

# example, don't run this :)
Describe 'Get-Planet' { 
    # this needs to be imported into the current scope
    BeforeAll { 
        $planetCount = 8
    }

    # this needs to run in its own scope
    It "Given no parameters, it lists all 8 planets" {
      $allPlanets = Get-Planet
      $allPlanets | Should -HaveCount $planetCount
    }
}

### 
break 


Get-Module M | Remove-Module 
New-Module -Name M -ScriptBlock {
    $script:a = "module M"
    function Invoke-InNewScope ($ScriptBlock) {
        & $ScriptBlock
    }

    function Invoke-InSameScope ($ScriptBlock) {
        . $ScriptBlock
    } 

    function Invoke-InSameScopeButDeeper ($ScriptBlock) {
        &{ 
            &{ 
                &{ 
                    . $ScriptBlock
                }
            }
        }
    } 

} | Import-Module 


$script:a = "script"
$b = "original value b"

$sb = { 
    $script:a 
    $b = "new value b"
}

break

# returns "script" and does 
# not overwrite $b because we run one scope 
# deeper 
& $sb
$b

Invoke-InNewScope $sb 
$b

break 

# returns "script" and overwrites 
# $b because we run in the same scope
. $sb 
$b  

break 

# reset back to original state
$b = "original value b"

# returns "original value a"  and overwrites 
# $b because we run in the same scope
Invoke-InSameScope $sb
$b

break 

# returns "original value a"  and overwrites 
# $b because we run in the same scope, even though
# in the module we are few scopes deeper
$b = "original value b"

Invoke-InSameScopeButDeeper $sb
$b

# there is an image for it in the presentation

break 


# - how deep in scopes we are is tracked per session state 
# In Pester  this is used to import BeforeAll so that variables and 
# functions from setup can be used in tests
