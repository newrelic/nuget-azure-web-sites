#Set-StrictMode -version latest
$modulesPath = (Split-Path -parent $MyInvocation.MyCommand.Path).Replace("\tests", "\modules\")
Import-Module (Join-Path $modulesPath global_config.psm1) -Force

    Describe "package_content" {
		
		It "checks to see if content\newrelic.config exists" {
			(Test-Path $PackageRoot\content\newrelic.config) | Should Be $true
		}
		
		It "checks to see if content\newrelic\SampleClassLibrary.dll exists" {
			(Test-Path $PackageRoot\content\newrelic\SampleClassLibrary.dll) | Should Be $true
		}
		
		It "checks to see if content\newrelic\TestProfiler.dll exists" {
			(Test-Path $PackageRoot\content\newrelic\TestProfiler.dll) | Should Be $true
		}
		
		It "checks to see if content\newrelic\extensions\CoreInstrumentation.xml exists" {
			(Test-Path $PackageRoot\content\newrelic\extensions\CoreInstrumentation.xml) | Should Be $true
		}
		
		It "checks to see if content\newrelic\extensions\extension.xml exists" {
			(Test-Path $PackageRoot\content\newrelic\extensions\extension.xsd) | Should Be $true
		}
		
    }