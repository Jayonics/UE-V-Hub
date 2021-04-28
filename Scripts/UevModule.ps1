function Get-SettingsTemplateCatalogPath {
    $ErrorActionPreference = "Stop"
    Try {
        $UevTemplatePath = $(Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\UEV\Agent\Configuration -Name SettingsTemplateCatalogPath `
                -ErrorAction:Stop | Select-Object -Property SettingsTemplateCatalogPath).SettingsTemplateCatalogPath
    }
    Catch {
        $UevTemplatePath = $(Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Uev\Agent\Configuration -Name SettingsTemplateCatalogPath `
                -ErrorAction:Stop | Select-Object -Property SettingsTemplateCatalogPath).SettingsTemplateCatalogPath
    }
    return $UevTemplatePath
}

class UevTemplate {
    # Properties of the XML Template
    [String] $Name
    [String] $ID
    [int]$Version
    $Process
    [Boolean]$Registered
    $SchemaVersion
    UevTemplate([String]$Name, [String]$ID) {
        $this.Name = $Name
        $this.ID = $ID
        if ($null -eq $Name) {
            Get-UevTemplate | Get-PropertiesFromTemplate
        }
    }
}
function Get-PropertiesFromRegisteredTemplate {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        $TemplateId,
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        $TemplateName,
        [Parameter(ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
        $TemplateVersion
    )
}

function Get-NS{
    [CmdletBinding()]
    param (
    [Parameter(ValueFromPipeline = $true)]
    [String]$Version = "2013A" # Default NameSpace Schema 2013A if undefined.
    )
    $2012 = @{ns="http://schemas.microsoft.com/UserExperienceVirtualization/2012/SettingsLocationTemplate"}
    $2013 = @{ns="http://schemas.microsoft.com/UserExperienceVirtualization/2013/SettingsLocationTemplate"}
    $2013A = @{ns="http://schemas.microsoft.com/UserExperienceVirtualization/2013A/SettingsLocationTemplate"}
    switch($Version){
        "2012" {$Schema = $2012}
        "2013" {$Schema = $2013}
        "2013A" {$Schema = $2013A}
    }
    return $Schema
}
function Get-UevXMLObj{
    [CmdletBinding(DefaultParameterSetName = 'File')]
    param(
        [Parameter(ValueFromPipeline = $true,ParameterSetName = 'File')] # Pass either a FileSystem.Object
        [Object]$FileItem,
        [Parameter(ParameterSetName = 'Path')] # Or pass a full path to a UEV XML Template
        [String]$FilePath
    )
    BEGIN {
        if($FileItem){
            Try {
                $FileItem | Test-Path -Filter "*.xml" -ErrorAction:Stop | Out-Null
            } Catch {
                Write-Host -ForegroundColor:Red "Failed to interpret XML from provided file."
                Throw
            }
        }
        elseif($FilePath){
            Try {
                Test-Path -LiteralPath $FilePath -Filter "*.xml" -ErrorAction:Stop | Out-Null
                $FileItem = Get-Item -LiteralPath $FilePath -Filter "*.xml"
            } Catch {
                Write-Host -ForegroundColor:Red "Failed to interpret XML file from provided path."
                Throw
            }
        }
    }
    PROCESS {
        [xml]$XML = Get-Content -Path "$($FileItem.FullName)"
    } END {
        return $XML
    }
}
function Get-UevTemplateProperties {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [xml]$XML
    )
    $Name = $(($XML | Select-Xml -Xpath '/ns:SettingsLocationTemplate/ns:Name' -Namespace $(Get-NS)).Node).InnerXml
    $ID = $(($XML | Select-Xml -Xpath '/ns:SettingsLocationTemplate/ns:ID' -Namespace $(Get-NS)).Node).InnerXml
    $ProcessesTmp = ((($XML | Select-Xml -Xpath '/ns:SettingsLocationTemplate//ns:Process' -Namespace $(Get-NS)).Node).InnerText)
    $Processes = @()
    ForEach($Process in $ProcessesTmp){$Processes += $Process}
    Write-Host "Stop"
}

function Get-FaultyUevApps {
    [CmdletBinding()]
    param (
        [Parameter()]
        [TypeName]
        $ParameterName
    )
}

$File = Get-Item -Path "A:\Server\Scripts\UE-V-hub\Templates\Git\Git.xml" -Force
$XmlObj = Get-UevXMLObj -FileItem $File
$XmlObj | Get-UevTemplateProperties