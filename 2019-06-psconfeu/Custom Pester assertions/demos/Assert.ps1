Get-Module Assert | Remove-Module
Import-Module Assert

1,2,3 | Assert-All { $_ % 2 -eq 0 }

break 

1,1,1 | Assert-Any { $_ % 2 -eq 0 }

break 

" text     " | Assert-StringEqual -CaseSensitive -IgnoreWhitespace "text"
 
break 

$expected = [PSCustomObject] @{ 
    Name = "Jakub"; 
    Age = 30
    Languages = [PSCustomObject] @{
        Speaking = "Czech", "English"
        Programming = "C#", "F#", "PowerShell", "Go"
    }
} 

$actual = [PSCustomObject] @{ 
    Name = "Jakub"; 
    Age = 12
    Languages = [PSCustomObject] @{
        Speaking = "Czech"
        Programming = "Delphi", "Pascal"
    }
} 

Assert-Equivalent -Expected $expected -Actual $actual