function PClip-Dashboard-Get {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage = "Company ID")]
        [string]$CompanyId,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        Invoke-PClipApi -Method GET -Path "/companies/$CompanyId/dashboard" -BaseUrl $BaseUrl -Token $Token
    }
}
