#Set-StrictMode -version latest
$modulesPath = (Split-Path -parent $MyInvocation.MyCommand.Path).Replace("\tests", "\modules\")
Import-Module (Join-Path $modulesPath global_config.psm1) -Force

    Describe "package_content" {
		
		$agentVersion = "3.11.283.0"
		
		Context "When package exists" {
			$newRelicHome = "$PackageRoot\content\newrelic";
			$expectedFiles = @(
				"$newRelicHome\newrelic.config",
				"$newRelicHome\NewRelic.Agent.Core.dll",
				"$newRelicHome\NewRelic.Profiler.dll",
				"$newRelicHome\NewRelic.Agent.Extensions.dll",
				"$newRelicHome\newrelic.xsd",
				"$newRelicHome\extensions\CoreInstrumentation.xml",
				"$newRelicHome\extensions\extension.xsd",
				"$newRelicHome\extensions\NewRelic.Providers.TransactionContext.Asp.dll",
				"$newRelicHome\extensions\NewRelic.Providers.TransactionContext.Default.dll",
				"$newRelicHome\extensions\NewRelic.Providers.TransactionContext.Wcf3.dll",
				"$newRelicHome\extensions\NewRelic.Providers.Wrapper.NServiceBus.dll",
				"$newRelicHome\extensions\NewRelic.Providers.Wrapper.NServiceBus.Instrumentation.xml"
			);
			$actualFiles = Get-ChildItem -Rec -Path $newRelicHome |
					Where-Object {!($_.PSIsContainer)} |
					ForEach-Object -Process {$_.FullName};
			
			It "has all expected files in home directory" {
				$missingFiles = $expectedFiles | Where-Object {!($actualFiles -Contains $_)}
				
				if ($missingFiles.length -gt 0) {
					$filesString = [string]::join("','", $missingFiles);				
					throw "Could not find expected file(s) '$filesString'";
				}
			}
			
			It "has no unexpected files in home directory" {			
				$unexpectedFiles = $actualFiles | Where-Object {!($expectedFiles -Contains $_)}
				
				if ($unexpectedFiles.length -gt 0) {
					$filesString = [string]::join("','", $unexpectedFiles);				
					throw "Found unexpected file(s) '$filesString'";
				}
			}
			
			It "checks to see if content\newrelic\NewRelic.Agent.Core.dll is architecture x86" {
				Get-PEArchitecture $PackageRoot\content\newrelic\NewRelic.Agent.Core.dll | Should Be "X86"
			}
			
			It "checks to see if content\newrelic\NewRelic.Agent.Core.dll is set to version $agentVersion" {
				[System.Diagnostics.FileVersionInfo]::GetVersionInfo("$PackageRoot\content\newrelic\NewRelic.Agent.Core.dll").FileVersion | Should be $agentVersion
			}
			
			It "checks to see if content\newrelic\NewRelic.Profiler.dll is set to version $agentVersion" {
				[System.Diagnostics.FileVersionInfo]::GetVersionInfo("$PackageRoot\content\newrelic\NewRelic.Profiler.dll").FileVersion | Should be $agentVersion
			}
			
			It "checks to see if content\newrelic\NewRelic.Profiler.dll is architecture x86" {
				Get-PEArchitecture $PackageRoot\content\newrelic\NewRelic.Profiler.dll | Should Be "X86"
			}
		}
		
		Context "When newrelic.config has not been applied to the application" {
			[xml] $configXml = Get-Content $PackageRoot\content\newrelic\newrelic.config
			$ns = @{ e = "urn:newrelic-config" }
			$ns = New-Object Xml.XmlNamespaceManager $configXml.NameTable
			$ns.AddNamespace( "e", "urn:newrelic-config" )

		
			It "Should have the static value REPLACE_WITH_LICENSE_KEY" {
				$node = $configXml.configuration.service
				$node.licenseKey | Should be "REPLACE_WITH_LICENSE_KEY"
			}
			
			It "Should not have the static value My Application for Application / Name" {
				$node = $configXml.SelectSingleNode("//e:application[e:name/text()]", $ns)
				$node.name | Should Be $null
			}
			
			It "Should have agentEnabled set to true" {
				$node = $configXml.configuration
				$node.agentEnabled | Should be "true"
			}
			
			It "Should have ssl set to true" {
				$node = $configXml.configuration.service
				$node.ssl | Should be "true"
			}
			
			It "Should have the directory attribute set on the log element" {
				$node = $configXml.configuration.log
				$node.directory | Should be "C:\Home\LogFiles\NewRelic"
			}
			
			It "Should have the level attribute set on the log element set to info" {
				$node = $configXml.configuration.log
				$node.level | Should be "info"
			}
		}
		
		Context "When .nuspec file exists and has a metadata element" {
			[xml] $nuspecXml = Get-Content $PackageRoot\*.nuspec
			$node = $nuspecXml.package.metadata
		
			It "Should have id element with value NewRelic.Azure.WebSites" {
				$node.id | Should be "NewRelic.Azure.WebSites"
			}
			
			It "Should have version element with value $agentVersion" {
				$node.version | Should be $agentVersion
			}
			
			It "Should have title element with value New Relic for Windows Azure Web Sites (x86)" {
				$node.title | Should be "New Relic for Windows Azure Web Sites (x86)"
			}
			
			It "Should have owners element with value New Relic" {
				$node.owners | Should be "New Relic"
			}
			
			It "Should have projectUrl element with value https://newrelic.com/windowsazure" {
				$node.projectUrl | Should be "https://newrelic.com/windowsazure"
			}
			
			It "Should have iconUrl element with value http://newrelic.com/images/avatar-newrelic.png" {
				$node.iconUrl | Should be "http://newrelic.com/images/avatar-newrelic.png"
			}
			
			It "Should have requireLicenseAcceptance element that is false" {
				$node.requireLicenseAcceptance | Should be "false"
			}
		}
		
		Context "When .nuspec file exists and has a file element" {
			[xml] $nuspecXml = Get-Content $PackageRoot\*.nuspec
			$ns = @{ e = "urn:newrelic-config" }
			$ns = New-Object Xml.XmlNamespaceManager $nuspecXml.NameTable
			$ns.AddNamespace( "e", "http://schemas.microsoft.com/packaging/2010/07/nuspec.xsd" )
		
			It "Should have file element for CoreInstrumentation.xml" {
				$result = $nuspecXml.SelectSingleNode("//e:file[@src = 'content\newrelic\extensions\CoreInstrumentation.xml']", $ns)
				$result.src | Should be $result.target
			}
			
			It "Should have file element for extension.xsd" {
				$result = $nuspecXml.SelectSingleNode("//e:file[@src = 'content\newrelic\extensions\extension.xsd']", $ns)
				$result.src | Should be $result.target
			}		
			
			It "Should have file element for NewRelic.Agent.Core.dll" {
				$result = $nuspecXml.SelectSingleNode("//e:file[@src = 'content\newrelic\NewRelic.Agent.Core.dll']", $ns)
				$result.src | Should be $result.target
			}	
			
			It "Should have file element for NewRelic.Profiler.dll" {
				$result = $nuspecXml.SelectSingleNode("//e:file[@src = 'content\newrelic\NewRelic.Profiler.dll']", $ns)
				$result.src | Should be $result.target
			}

			It "Should have file element for newrelic.config" {
				$result = $nuspecXml.SelectSingleNode("//e:file[@src = 'content\newrelic\newrelic.config']", $ns)
				$result.src | Should be $result.target
			}
		
			It "Should have file element for NewRelic.Api.Agent.dll" {
				$result = $nuspecXml.SelectSingleNode("//e:file[@src = 'lib\NewRelic.Api.Agent.dll']", $ns)
				$result.src | Should be $result.target
			}
			
			It "Should have file element for install.ps1" {
				$result = $nuspecXml.SelectSingleNode("//e:file[@src = 'tools\install.ps1']", $ns)
				$result.src | Should be $result.target
			}
			
			It "Should have file element for tools\uninstall.ps1" {
				$result = $nuspecXml.SelectSingleNode("//e:file[@src = 'tools\uninstall.ps1']", $ns)
				$result.src | Should be $result.target
			}
		
		}
    }
