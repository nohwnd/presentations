Get-Module Pester | Remove-Module 
# you don't need to use 4.6.0, it just has nicer Should -Be failure message output right now
$p = Import-Module Pester -RequiredVersion 4.6.0 -PassThru

. $PSSCriptRoot\Should-BeInSubnet.ps1

function Get-NetIPAddress {
    # this is my mock
    [PSCustomObject] @{ IPAddress = '192.168.1.32' }
}

"Reloaded, using Pester $($p.Version)."

break 

Describe "Network" {
    It "has IP in the correct subnet"  {
        Get-NetIPAddress -AddressFamily IPv4 |
            Should -BeInSubnet 192.168.1.0/24
    }
}

break 

Describe "Test-InSubnet" {
    It "succeeds when the subnet is /24 and the first 3 parts of the address are the same" {
        $actual = Test-InSubnet "192.168.1.1" "192.168.1.0/24"

        $actual | Should -Not -BeNullOrEmpty
        $actual | Should -BeTrue
    }

    It "fails when the subnet is /24 and the first 3 parts of the address are different" {
        $actual = Test-InSubnet "192.168.128.32" "192.168.1.0/24" 

        $actual | Should -Not -BeNullOrEmpty
        $actual | Should -BeFalse
    }
}

break

Describe "Should -BeInSubnet" {
    It "passes when the ip is in the subnet" {
        "192.168.1.1" | Should -BeInSubnet "192.168.1.0/24"
    }

    It "fails when the ip is outside of the subnet" {
        { 
            "192.168.128.32" | Should -BeInSubnet "192.168.1.0/24"
        } | Should -Throw -ErrorId 'PesterAssertionFailed'
    } 
}

Describe "Should -BeInSubnet messages" {
    It "fails with the correct message" {
        $err = { 
            "192.168.128.32" | Should -BeInSubnet "192.168.1.0/24"
        } | Should -Throw -PassThru

        $err.Exception.Message | 
            Should -Be ("Expected address to be in subnet 192.168.1.0/24, " +
                        "but address 192.168.128.32 was outside of it.")
    }   

    It "allows because to be used" {
        $err = { 
            "192.168.128.32" | Should -BeInSubnet "192.168.1.0/24" -Because "it should be in DMZ" 
        } | Should -Throw -PassThru

        $err.Exception.Message | 
            Should -Be ("Expected address to be in subnet 192.168.1.0/24, " +
                        "because it should be in DMZ, but address 192.168.128.32 was outside of it.")
    }
}

Describe "Should -Not -BeInSubnet" {

    It "passes when the ip is in outside of the subnet" {
        "192.168.128.32" | Should -Not -BeInSubnet "192.168.1.0/24"
    }

    It "fails when the ip is in the subnet" {
        { 
            "192.168.1.1" | Should -Not -BeInSubnet "192.168.1.0/24"
        } | Should -Throw -ErrorId 'PesterAssertionFailed'
    }
}

Describe "Should -Not BeInSubnet messages" {
    It "fails with the correct message" {
        $err = { 
            "192.168.1.1" | Should -Not -BeInSubnet "192.168.1.0/24"
        } | Should -Throw -PassThru

        $err.Exception.Message | 
            Should -Be ("Expected address to not be in subnet 192.168.1.0/24, " +
                        "but address 192.168.1.1 was in it.")
    }

    It "allows because to be used" {
        $err = { 
            "192.168.1.1" | Should -Not -BeInSubnet "192.168.1.0/24" -Because "it should be in DMZ" 
        } | Should -Throw -PassThru

        $err.Exception.Message | 
            Should -Be ("Expected address to not be in subnet 192.168.1.0/24, " +
                        "because it should be in DMZ, but address 192.168.1.1 was in it.")
    }
}
