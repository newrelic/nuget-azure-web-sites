param($installPath, $toolsPath, $package, $project)

Import-Module (Join-Path $toolsPath NewRelicHelper.psm1)

Write-Host "***Cleaning up the project's .config file ***"
cleanup_project_config $project