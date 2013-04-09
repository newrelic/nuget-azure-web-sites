#Set-StrictMode -version latest
$modulesPath = (Split-Path -parent $MyInvocation.MyCommand.Path).Replace("\tests", "\modules\")
Import-Module (Join-Path $modulesPath global_config.psm1) -Force

    Describe "package_tools" {
		
		It "checks to see if tools\install.ps1 exists" {
			#Write-Host $packageDir\tools\install.ps1
			(Test-Path $PackageRoot\tools\install.ps1) | Should Be $true
		}
		
		It "checks to see if tools\uninstall.ps1 exists" {
			(Test-Path $PackageRoot\tools\install.ps1) | Should Be $true
		}
		
		It "checks to see if tools\NewRelicHelper.psm1 exists" {
			(Test-Path $PackageRoot\tools\install.ps1) | Should Be $true
		}
		
    }