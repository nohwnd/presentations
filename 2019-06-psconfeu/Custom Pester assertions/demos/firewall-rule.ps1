Describe "Alllow incoming traffic to web server" { 
    It "https is allowed" {
        $firewallRule = Get-NetFirewallRule -DisplayName 'Web server https'

        $firewallRule.Enabled | Should -BeTrue
        $firewallRule.Direction | Should -Be 'Inbound'
        $firewallRule.Action | Should -Be 'Allow'

        $firewallrule.Profile.HasFlag([Microsoft.PowerShell.Cmdletization.GeneratedTypes.NetSecurity.Profile]::Public) | Should -BeTrue -Because "the firewall rule should in the Public profile among others"

        $portRule = $firewallRule | Get-NetFirewallPortFilter 
        $portRule.Protocol | Should -Be 'TCP'
        $portRule.LocalPort | Should -Be 443
    } 
}

# problems: 
# 1) first assertion to fail will fail the whole test
# 2) we must not forget to test if the rule is enabled
# 3) checking that enum has a flag is difficult we can do -band but it does not play well with Should -BeTrue, so it takes some figuring out to do

# 4) it's complex
# 5) there is some hidden knowledge (checking that an enum has a flag can be done in at least three ways, and only one of them  works properly)
# 6) we cannot test this

# hides complexity 
# ensures implicit are not forgotten (e.g. is inbound and is enabled)
# easy to re

