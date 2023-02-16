
param(
	[string] $NuGetApiKey = $env:nuget_apikey,

	# Overwrite published versions
	[switch] $ForcePublish,

    # Add doc templates for new command.
	[switch] $ForceDocInit,

	# Version suffix to prereleases
	[int] $BuildNumber
)

$ModuleName = 'AssemblyChecker'

. ./tasks/Build.Tasks.ps1

task InstallBuildDependencies {
    Install-Module platyPs -ErrorAction Stop
}
task InstallTestDependencies {}
task InstallReleaseDependencies -Jobs {}
