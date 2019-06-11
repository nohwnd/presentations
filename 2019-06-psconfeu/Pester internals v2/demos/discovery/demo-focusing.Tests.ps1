function Get-Text () {
    "text"
}
Describe "d1" {
    It "t1" {
        (Get-Text).Length | Should -Be 4
    }

    It -Focus "t2" {
        # I want to run just this test and debug it
        Get-Text | Should -Be 'toxt'
    }
}
