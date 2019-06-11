function Test-InSubnet {
    param (
        [string] $IP,
        [string] $Subnet
    )
    
    $a1, $a2, $a3, $a4  = $IP -split '\.'
    $e1, $e2, $e3, $e4, $suffix = $Subnet -split '[.\\/]'

    if ($suffix -notin @(8, 16, 24)) {
       throw "The provided subnet $Subnet uses suffix /$suffix that is not supported, supported suffixes are /8, /16 and /24."
    }
    
    (8 -eq $suffix -and $e1 -eq $a1) `
    -or (16 -eq $suffix -and $e1 -eq $a1 -and $e2 -eq $a2) `
    -or (24 -eq $suffix -and $e1 -eq $a1 -and $e2 -eq $a2 -and $e3 -eq $a3)
}

function Should-BeInSubnet {
    
     <#
.SYNOPSIS
Compares a given IP address with a CIDR subnet. Passes when 
the IP address is part of that subnet, fails when given IP 
address outside of the subnet or an invalid ip address.

.EXAMPLE
$actual = '192.168.1.32'
PS C:\>$actual | Should -BeInSubnet 192.168.1.0/24

This test will pass the given address is within the 
given subnet.

.EXAMPLE
$actual = '10.0.0.16'
PS C:\>$actual | Should -BeInSubnet 192.168.1.0/24

This test will fail, the given address is outside of the
given subnet.
#>   
param ($ActualValue, $Subnet, [switch] $Negate, [string] $Because)
    # # this is a bit hacky and will fail in strict mode
    # # but you can do whatever you want, so why not start 
    # # from a quick solution that works  
    if ($null -ne $ActualValue.IPAddress) { 
        $ActualValue = $ActualValue.IPAddress
    }

    [bool] $succeeded = Test-InSubnet -IP $ActualValue -Subnet $Subnet

    if ($Negate) { 
        $succeeded = -not $succeeded 
    }

    if ($succeeded) {
        return [PSCustomObject] @{
            Succeeded = $true
            FailureMessage = $null
        }
    }

    $failureMessage = if (-not $Negate) {
            "Expected address to be in subnet $Subnet,$(if ($Because) {" because $Because," }) but address $ActualValue was outside of it."
        }
        else { 
            "Expected address to not be in subnet $Subnet,$(if ($Because) {" because $Because," }) but address $ActualValue was in it."
        }

    return [PSCustomObject]@{
        Succeeded = $false 
        FailureMessage = $failureMessage
    }
}

Add-ShouldOperator -Name BeInSubnet `
    -InternalName       Should-BeInSubnet `
    -Test               ${function:Should-BeInSubnet}
