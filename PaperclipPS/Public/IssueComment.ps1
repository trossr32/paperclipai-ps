function PClip-IssueComment-List {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, HelpMessage = "Issue ID")]
        [string]$IssueId,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        Invoke-PClipApi -Method GET -Path "/issues/$IssueId/comments" -BaseUrl $BaseUrl -Token $Token -Json:$Json
    }
}

function PClip-IssueComment-Create {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Issue ID")]
        [string]$IssueId,

        [Parameter(Mandatory, Position = 1, ValueFromPipeline, HelpMessage = "Comment body (markdown)")]
        [string]$Body,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        Invoke-PClipApi -Method POST -Path "/issues/$IssueId/comments" -Body @{ body = $Body } -BaseUrl $BaseUrl -Token $Token -Json:$Json
    }
}
