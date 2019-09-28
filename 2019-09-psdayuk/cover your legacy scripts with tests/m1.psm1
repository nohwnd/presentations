function Get-Greeting {
    param ($Name) 

    $text = Get-GreetingText 
    $formattedGreetingText = $text -f $Name
    Write-Host $formattedGreetingText
    $formattedGreetingText
}

# another internal function that collaborates
# with Get-Greeting and that we will mock 
# in our tests
function Get-GreetingText {
    'Hello, {0}!'
}

Export-ModuleMember -Function Get-Greeting