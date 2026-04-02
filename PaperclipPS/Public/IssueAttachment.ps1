function PClip-IssueAttachment-List {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, HelpMessage = "Issue ID")]
        [string]$IssueId,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        Invoke-PClipApi -Method GET -Path "/issues/$IssueId/attachments" -BaseUrl $BaseUrl -Token $Token
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

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    $uri = "$BaseUrl/companies/$CompanyId/issues/$IssueId/attachments"
    $headers = @{}
    if ($Token) { $headers["Authorization"] = "Bearer $Token" }

    $form = @{ file = Get-Item -LiteralPath $FilePath }
    Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Form $form
}

function PClip-IssueAttachment-Download {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage = "Attachment ID")]
        [string]$AttachmentId,

        [Parameter(Mandatory, Position = 1, HelpMessage = "Local file path to save the downloaded content")]
        [string]$OutFile,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
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

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        Invoke-PClipApi -Method DELETE -Path "/attachments/$AttachmentId" -BaseUrl $BaseUrl -Token $Token
    }
}
