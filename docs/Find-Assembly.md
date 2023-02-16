---
external help file: AssemblyChecker-help.xml
Module Name: AssemblyChecker
online version:
schema: 2.0.0
---

# Find-Assembly

## SYNOPSIS
Finds conflicting assemblies

## SYNTAX

```
Find-Assembly [-ModulePath] <DirectoryInfo> [<CommonParameters>]
```

## DESCRIPTION
PowerShell does not resolve version conflicts between assemblies loaded from different modules.
The solution is to load the assemblies in a specific order.
This command compares the DLLs of a module directory with the loaded assemblies and returns possible conflicts.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -ModulePath
Path to the module, that contains the DLLs to load.

```yaml
Type: DirectoryInfo
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
