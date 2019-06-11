. $PSScriptRoot\..\setup.ps1
$root = $PSScriptRoot

break

$file = "$root/demo-filtering-in-one-file.Tests.ps1"

code $file

$runResult = Invoke-Pester -PassThru -Path $file

$runResult = Invoke-Pester -PassThru -Path $file -ExcludeTag "ReleaseOnly"

# this works because the discovery 
# sets shouldRun based on the tests
# and propagates it upwards
$runResult.ShouldRun # <- $true because there are some tests that will run
$runResult.Blocks[0].ShouldRun # <- $true because there are some tests that will run
$runResult.Blocks[1].ShouldRun # <- $false because no tests (not even in child blocks) will run


break

$file = "$root/demo-filtering-whole-file.Tests.ps1"
code $file
# it also applies to whole files that won't run if there are no tests to run
$runResult = Invoke-Pester -PassThru -Path $file

$runResult = Invoke-Pester -PassThru -Path $file -ExcludeTag "ReleaseOnly"

$runResult.ShouldRun

break

$file = "$root/demo-focusing.Tests.ps1"
code $file
$runResult = Invoke-Pester -PassThru -Path $file
