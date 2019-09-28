param (
    [Parameter(Mandatory)]
    $Name
)

# our entry point function that holds 
# all the stuff that should happen when 
# we run this script
function Main {
    param (
        [Parameter(Mandatory)]
        $Name
    )
    
    Get-Greeting $Name
}

# internal function that writes greeting
function Get-Greeting {
    param ($Name) 

    $text = Get-GreetingText 
    $formattedGreetingText = $text -f $Name
    Write-Host $formattedGreetingText -ForegroundColor Magenta
    $formattedGreetingText
}

# another internal function that collaborates
# with Get-Greeting and that we will mock 
# in our tests
function Get-GreetingText {
    'Hello, {0}!'
}

Main -Name $Name
