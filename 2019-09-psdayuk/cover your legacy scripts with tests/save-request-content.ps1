(Invoke-WebRequest https://pokeapi.co/api/v2/pokemon/pikachu/).Content |
    Set-Content "pikachu_$((Get-Date).ToString("yyyy-MM-hh")).json" -Encoding UTF8