BeforeAll {
    Write-Host "Waiting 3 second..."
    Start-Sleep -Seconds 3
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
