function Count-Scope {

    # $error is automatic variable, constant and not allScopes

    # skip scope 0 because we are in a function so 0 (local) scope
    # will never contain $error
    $scope = 1
    
    # go through scopes 1 (Parent scope), 2, 3... until you find error variable
    while ($null -eq (Get-Variable -Name Error `
                                   -Scope $scope `
                                   -ErrorAction Ignore)) {
        $scope++
    }

    # remove one scope we are in a function
    $scope - 1 
}

"in root -> scope: $(Count-Scope)"

& {
    "in & scriptblock -> scope: $(Count-Scope)"
}

. {
    "in . scriptblock -> scope: $(Count-Scope)"
}

. {
    & {
        . {
            & {
                . { 
                    & { 
                        "in mix of . and & scriptblock -> scope: $(Count-Scope)"
                    }
                }
            }
        }
    }
}


# - . can be used to run scriptblocks in the current scope
# - & can be used to run scriptblock in own scope
# - variables are defined in parent are available in child
