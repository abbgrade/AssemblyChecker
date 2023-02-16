#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.0.0' }

Describe Find-Assembly {
    BeforeAll {
        Import-Module $PSScriptRoot/../src/AssemblyChecker.psd1 -Force -ErrorAction Stop
    }

    It works {
        Import-Module PsSqlClient
        $Findings = Find-Assembly -ModulePath $PSScriptRoot/../../PsDac/publish/PsDac
        $Findings | Should -Not -BeNullOrEmpty
    }
}