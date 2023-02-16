$ModuleName = 'AssemblyChecker'
. ./tasks/Build.Tasks.ps1

task InstallBuildDependencies {
    Install-Module platyPs -ErrorAction Stop
}
task InstallTestDependencies {}
task InstallReleaseDependencies -Jobs {}