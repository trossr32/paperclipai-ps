function PClip-IssueDocument-List {
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
        Invoke-PClipApi -Method GET -Path "/issues/$IssueId/documents" -BaseUrl $BaseUrl -Token $Token -Json:$Json
    }
}

function PClip-IssueDocument-Get {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Issue ID")]
        [string]$IssueId,

        [Parameter(Mandatory, Position = 1, HelpMessage = "Document key")]
        [string]$Key,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    Invoke-PClipApi -Method GET -Path "/issues/$IssueId/documents/$Key" -BaseUrl $BaseUrl -Token $Token -Json:$Json
}

function PClip-IssueDocument-Put {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Issue ID")]
        [string]$IssueId,

        [Parameter(Mandatory, Position = 1, HelpMessage = "Document key")]
        [string]$Key,

        [Parameter(Mandatory, HelpMessage = "Document title")]
        [string]$Title,

        [Parameter(Mandatory, HelpMessage = "Document format (e.g. markdown)")]
        [string]$Format,

        [Parameter(Mandatory, HelpMessage = "Document body content")]
        [string]$Body,

        [Parameter(HelpMessage = "Base revision ID (required for updates to existing documents)")]
        [string]$BaseRevisionId,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    $reqBody = @{
        title  = $Title
        format = $Format
        body   = $Body
    }
    if ($BaseRevisionId) { $reqBody["baseRevisionId"] = $BaseRevisionId }
    Invoke-PClipApi -Method PUT -Path "/issues/$IssueId/documents/$Key" -Body $reqBody -BaseUrl $BaseUrl -Token $Token -Json:$Json
}

function PClip-IssueDocument-Revisions {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Issue ID")]
        [string]$IssueId,

        [Parameter(Mandatory, Position = 1, HelpMessage = "Document key")]
        [string]$Key,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    Invoke-PClipApi -Method GET -Path "/issues/$IssueId/documents/$Key/revisions" -BaseUrl $BaseUrl -Token $Token -Json:$Json
}

function PClip-IssueDocument-Delete {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Issue ID")]
        [string]$IssueId,

        [Parameter(Mandatory, Position = 1, HelpMessage = "Document key")]
        [string]$Key,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    Invoke-PClipApi -Method DELETE -Path "/issues/$IssueId/documents/$Key" -BaseUrl $BaseUrl -Token $Token -Json:$Json
}
