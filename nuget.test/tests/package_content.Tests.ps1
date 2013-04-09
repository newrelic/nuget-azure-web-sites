#Set-StrictMode -version latest
$modulesPath = (Split-Path -parent $MyInvocation.MyCommand.Path).Replace("\tests", "\modules\")
Import-Module (Join-Path $modulesPath global_config.psm1) -Force

    Describe "package_content" {
		
		It "checks to see if content\newrelic.config exists" {
			(Test-Path $PackageRoot\content\newrelic.config) | Should Be $true
		}
		
		It "checks to see if content\newrelic\SampleClassLibrary.dll exists" {
			(Test-Path $PackageRoot\content\newrelic\NewRelic.Agent.Core.dll) | Should Be $true
		}
		
		It "checks to see if content\newrelic\TestProfiler.dll exists" {
			(Test-Path $PackageRoot\content\newrelic\NewRelic.Profiler.dll) | Should Be $true
		}
		
		It "checks to see if content\newrelic\extensions\CoreInstrumentation.xml exists" {
			(Test-Path $PackageRoot\content\newrelic\extensions\CoreInstrumentation.xml) | Should Be $true
		}
		
		It "checks to see if content\newrelic\extensions\extension.xml exists" {
			(Test-Path $PackageRoot\content\newrelic\extensions\extension.xsd) | Should Be $true
		}
		
		Context "When newrelic.config has not been applied to the application" {
			[xml] $configXml = Get-Content $PackageRoot\content\newrelic.config
			$ns = @{ e = "urn:newrelic-config" }
			$ns = New-Object Xml.XmlNamespaceManager $configXml.NameTable
			$ns.AddNamespace( "e", "urn:newrelic-config" )

		
			It "Should have the static value REPLACE_WITH_LICENSE_KEY" {
				$node = $configXml.configuration.service
				$node.licenseKey | Should be "REPLACE_WITH_LICENSE_KEY"
			}
			
			It "Should have the static value My Application for Application / Name" {
				$node = $configXml.SelectSingleNode("//e:application[e:name/text()]", $ns)
				$node.name | Should Be "My Application"
			}
			
			It "Should have agentEnabled set to true" {
				$node = $configXml.configuration
				$node.agentEnabled | Should be "true"
			}
			
			It "Should have ssl set to true" {
				$node = $configXml.configuration.service
				$node.ssl | Should be "true"
			}
		}
    }