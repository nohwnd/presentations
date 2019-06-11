& "$PSScriptRoot\..\setup.ps1"

$runResult = Invoke-Pester -ScriptBlock {

    BeforeAll {
        function f ($Path) {}
    }
    Describe "d1" {
        BeforeAll {
            Mock f { "before all mock" }
        }
        
        It "i1" {
            Mock f { "it mock" } -ParameterFilter { "abc" -eq $Path }
            
            f -Path "abc"
            f

            Assert-MockCalled f -Exactly 2
        }
        
        AfterAll {
            f
        }
    }
} -PassThru

break 

$runResult.Blocks[0].PluginData.Mock
$runResult.Blocks[0].PluginData.Mock.CallHistory["||f"].Count
$runResult.Blocks[0].PluginData.Mock.Hooks[0]
$runResult.Blocks[0].PluginData.Mock.Behaviors["f"]

$runResult.Blocks[0].Tests[0].PluginData.Mock
$runResult.Blocks[0].Tests[0].PluginData.Mock.CallHistory["||f"].Count
# no new hook defined here, it reuses the existing one from 
# parent mock
$runResult.Blocks[0].Tests[0].PluginData.Mock.Hooks[0]
$runResult.Blocks[0].Tests[0]. PluginData.Mock.Behaviors["f"]