function PClip-Secret-List {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Company ID")]
        [string]$CompanyId,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    Invoke-PClipApi -Method GET -Path "/companies/$CompanyId/secrets" -BaseUrl $BaseUrl -Token $Token -Json:$Json
}

function PClip-Secret-Create {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Company ID")]
        [string]$CompanyId,

        [Parameter(Mandatory, Position = 1, HelpMessage = "Secret name")]
        [string]$Name,

        [Parameter(Mandatory, Position = 2, HelpMessage = "Secret value")]
        [string]$Value,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    Invoke-PClipApi -Method POST -Path "/companies/$CompanyId/secrets" -Body @{ name = $Name; value = $Value } -BaseUrl $BaseUrl -Token $Token -Json:$Json
}

function PClip-Secret-Update {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, HelpMessage = "Secret ID")]
        [string]$SecretId,

        [Parameter(Mandatory, Position = 1, HelpMessage = "New secret value")]
        [string]$Value,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        Invoke-PClipApi -Method PATCH -Path "/secrets/$SecretId" -Body @{ value = $Value } -BaseUrl $BaseUrl -Token $Token -Json:$Json
    }
}
