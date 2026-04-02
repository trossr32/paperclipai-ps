function PClip-IssueAttachment-List {
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
        Invoke-PClipApi -Method GET -Path "/issues/$IssueId/attachments" -BaseUrl $BaseUrl -Token $Token -Json:$Json
    }
}

function PClip-IssueAttachment-Upload {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Company ID")]
        [string]$CompanyId,

        [Parameter(Mandatory, Position = 1, HelpMessage = "Issue ID")]
        [string]$IssueId,

        [Parameter(Mandatory, Position = 2, HelpMessage = "Path to the file to upload")]
        [ValidateScript({ Test-Path $_ -PathType Leaf })]
        [string]$FilePath,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    $uri = "$BaseUrl/companies/$CompanyId/issues/$IssueId/attachments"
    $headers = @{}
    if ($Token) { $headers["Authorization"] = "Bearer $Token" }

    $form = @{ file = Get-Item -LiteralPath $FilePath }
    $result = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Form $form
    if ($Json) {
        $result | ConvertTo-Json -Depth 10
    } else {
        $result
    }
}

function PClip-IssueAttachment-Download {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage = "Attachment ID")]
        [string]$AttachmentId,

        [Parameter(Mandatory, Position = 1, HelpMessage = "Local file path to save the downloaded content")]
        [string]$OutFile,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        if ($Json) {
            Write-Warning "PClip-IssueAttachment-Download: -Json is ignored because this function writes to a file via -OutFile."
        }
        $uri = "$BaseUrl/attachments/$AttachmentId/content"
        $headers = @{}
        if ($Token) { $headers["Authorization"] = "Bearer $Token" }
        Invoke-RestMethod -Uri $uri -Method GET -Headers $headers -OutFile $OutFile
    }
}

function PClip-IssueAttachment-Delete {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage = "Attachment ID")]
        [string]$AttachmentId,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        Invoke-PClipApi -Method DELETE -Path "/attachments/$AttachmentId" -BaseUrl $BaseUrl -Token $Token -Json:$Json
    }
}
