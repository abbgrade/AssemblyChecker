function Find-Assembly {

    <#

    .SYNOPSIS
    Finds conflicting assemblies

    .DESCRIPTION
    PowerShell does not resolve version conflicts between assemblies loaded from different modules. The solution is to load the assemblies in a specific order. This command compares the DLLs of a module directory with the loaded assemblies and returns possible conflicts.
    
    #>

    [CmdletBinding()]
    param (
        # Path to the module, that contains the DLLs to load.
        [Parameter( Mandatory )]
        [ValidateScript({ $_.Exists })]
        [System.IO.DirectoryInfo] $ModulePath
    )
    
    begin {
        $LoadedAssemblies = [System.AppDomain]::CurrentDomain.GetAssemblies()
        $LoadedAssemblyFiles = $LoadedAssemblies | ForEach-Object {
            [System.IO.FileInfo] $_.Location
        }
        $LoadedAssemblyNames = $LoadedAssemblyFiles | Select-Object -ExpandProperty BaseName
    }
    
    process {
        $RequiredAssemblies = Get-ChildItem -Path $ModulePath -Filter *.dll -Recurse
        $RequiredAssemblies | ForEach-Object {
            try {
                $_ | Add-Member AssemblyName ( [System.Reflection.AssemblyName]::GetAssemblyName($_.FullName) )
            } catch {
                Write-Verbose "Unable to determine version of '$_'"
            }
        }
        $Collisions = $RequiredAssemblies | Where-Object BaseName -in $LoadedAssemblyNames
        $Collisions | ForEach-Object {
            $_ | Add-Member RuntimeAssemblyFile ( $LoadedAssemblyFiles | Where-Object BaseName -eq $_.BaseName )
            $_ | Add-Member RuntimeAssembly ( $LoadedAssemblies | Where-Object Location -eq $_.RuntimeAssemblyFile )
        }
        Write-Output $Collisions | ForEach-Object {
            [PSCustomObject]@{
                Name = $_.BaseName
                RequiredAssemblyVersion = $_.AssemblyName.Version
                RequiredAssemblyPath = $_.FullName
                LoadedAssemblyVersion = $_.RuntimeAssembly.GetName().Version
                LoadedAssemblyPath = $_.RuntimeAssemblyFile.FullName
            }
        } | Where-Object { 
            $_.LoadedAssemblyVersion -lt $_.RequiredAssemblyVersion 
        }
    }
    
    end {
        
    }
}