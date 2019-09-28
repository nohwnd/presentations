
Get-Module Pester, Assert | Remove-Module 
Import-Module Pester -MinimumVersion 4.0
Import-Module Assert -MinimumVersion 0.9
cd $PSScriptRoot

"Initialized, run the script step by step 🚀"

break

# function as you probably find it in your codebase
function Get-Pokemon ($Name) {
    $uri = [uri]"https://pokeapi.co/api/v2/pokemon/$($Name.ToLowerInvariant())/"
    $response = Invoke-WebRequest -Method GET -Uri $uri -Verbose
    $content = $response.Content | ConvertFrom-Json

    [psCustomObject]@{
        Name = $content.name
        Height = $content.height
        Weight = $content.weight
        Type = $content.types.type.name
    }
}


break 

Describe "Get-Pokemon" {
    # unit test
    It "Returns basic info about a Pokemon" {  
        # -- Arrange
        # default mock
        Mock Invoke-WebRequest
        # non-default mock
        Mock Invoke-WebRequest -ParameterFilter { $uri -like 'https://pokeapi.co*' } -MockWith {
            # the json I got by executing the actual api and saving the content
            # the date is useful when this starts failing 2 years in the future
            $content = Get-Content pikachu_2018-10-06.json
            [PsCustomObject]@{ 
                StatusCode = 200
                Content = $content
            }
        }

        # this object I got running against real api
        # and converting the result
        $expected = [pscustomobject] @{
            Name = "pikachu"
            Type = "electric"
            Weight = "60"
            Height = "4"
            # Color = "Yellow"
        }

        # -- Act
        $actual = Get-Pokemon -Name pikachu

        # -- Assert
        $actual.Name | Should -Be $expected.Name
        $actual.Type | Should -Be $expected.Type
        $actual.Weigth | Should -Be $expected.Weigth
        $actual.Height | Should -Be $expected.Height

        # or using Assert module
        Assert-Equivalent -Actual $actual -Expected $expected
    }
}

# Taking this step forward we would also write:
# - an integraion test that would actually call the api and check the basic assumptions we have (or a so called happy path)
# - possibly also "discovery" tests, that will just validate how the api works without mixing it with our own logic, those add cost but allow us to quickly identify whether our system or the external system is at fault

break 

# next step would then be to refactor the now tested code, for example by extracting the simple URL formattig function because the URL is a bit difficult to get right

function Get-PokemonUrl ($Name) {
    # the api runs on nginx so it's a bit fiddly
    # the name must be lowercase
    # and the url must end with a slash
    $url = "https://pokeapi.co/api/v2/pokemon/$($Name.ToLowerInvariant())/"
    [Uri]$url
}

function Get-Pokemon ($Name) {
    $uri = Get-PokemonUrl $Name 
    $response = Invoke-WebRequest -Method GET -Uri $uri -Verbose
    $content = $response.Content | ConvertFrom-Json

    [psCustomObject]@{
        Name = $content.name
        Height = $content.height
        Weight = $content.weight
        Type = $content.types.type.name
    }
}