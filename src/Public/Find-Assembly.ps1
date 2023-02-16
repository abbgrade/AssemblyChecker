function Find-Assembly {
    [CmdletBinding()]
    param (
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