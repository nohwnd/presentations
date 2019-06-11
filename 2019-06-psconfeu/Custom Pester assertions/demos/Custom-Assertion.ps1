function Assert-True {
    param (
        [Parameter(ValueFromPipeline)]
        $ActualValue
    )
    
    if ($ActualValue -is [bool] -and $true -eq $ActualValue) {
        return 
    }

    throw "Expected the value to be `$true but got '$ActualValue'"
}

break 

1 | Assert-True
$false | Assert-True
$true | Assert-True