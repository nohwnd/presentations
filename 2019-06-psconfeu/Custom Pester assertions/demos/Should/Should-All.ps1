function Should-All {
    param ($ActualValue, [ScriptBlock] $Filter, [switch] $Negate, [string] $Because)

    # Actual value is the array that was piped in
    $succeded = $true 
    $nonPass = @()
    foreach ($i in $ActualValue) {
        # this is naive, see {}.InvokeWithContext, or https://gist.github.com/nohwnd/3ca1c5f2240ee187303867ddb7422665 for universal solution 
        $pass = &{ 
            $_ = $i
            &$Filter 
        }
        if (-not $pass) {
            $succeded = $false
            $nonpass += $i 
        }
    }

    if ($succeded) { 
        return [PSCustomObject]@{
            Succeeded = $true
            FailureMessage = $null
        }
    }
    else {
        return [PSCustomObject]@{
            Succeeded = $false 
            FailureMessage = "Expected all items from @($($ActualValue -join ",")) to pass the filter {$Filter}, but @($($nonpass -join ",")) did not pass it."
        }
    }
    
}


Add-ShouldOperator -Name All `
    -InternalName       Should-All `
    -Test               ${function:Should-All} `
    -SupportsArrayInput # <- allows consuming arrays