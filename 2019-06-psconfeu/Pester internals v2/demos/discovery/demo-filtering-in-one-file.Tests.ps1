Describe "d1" {
    BeforeAll {
        Write-Host "Setup 1"
    }
    It "t1" {
        1 | Should -Be 1
    }
}

Describe "d2" {
    BeforeAll {
        Write-Host "Setup 2"
    }
    Describe "d22" {
        It "t2" -Tag "ReleaseOnly" {
            1 | Should -Be 1
        }
    }
}