function PClip-Project-List {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Company ID")]
        [string]$CompanyId,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    Invoke-PClipApi -Method GET -Path "/companies/$CompanyId/projects" -BaseUrl $BaseUrl -Token $Token
}

function PClip-Project-Get {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage = "Project ID")]
        [string]$ProjectId,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        Invoke-PClipApi -Method GET -Path "/projects/$ProjectId" -BaseUrl $BaseUrl -Token $Token
    }
}

function PClip-Project-Create {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Company ID")]
        [string]$CompanyId,

        [Parameter(Mandatory, Position = 1, HelpMessage = "Project name")]
        [string]$Name,

        [Parameter(HelpMessage = "Project description")]
        [string]$Description,

        [Parameter(HelpMessage = "Array of goal IDs to link")]
        [string[]]$GoalIds,

        [Parameter(HelpMessage = "Project status")]
        [string]$Status,

        [Parameter(HelpMessage = "Workspace configuration as a hashtable (name, cwd, repoUrl, repoRef, isPrimary)")]
        [hashtable]$Workspace,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    $body = @{ name = $Name }
    if ($Description) { $body["description"] = $Description }
    if ($GoalIds)     { $body["goalIds"] = @($GoalIds) }
    if ($Status)      { $body["status"] = $Status }
    if ($Workspace)   { $body["workspace"] = $Workspace }
    Invoke-PClipApi -Method POST -Path "/companies/$CompanyId/projects" -Body $body -BaseUrl $BaseUrl -Token $Token
}

function PClip-Project-Update {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, HelpMessage = "Project ID")]
        [string]$ProjectId,

        [Parameter(HelpMessage = "New project status")]
        [string]$Status,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        $body = @{}
        if ($PSBoundParameters.ContainsKey("Status")) { $body["status"] = $Status }
        if ($body.Count -eq 0) {
            throw "PClip-Project-Update: No updatable properties were specified. Provide at least one property to update, such as -Status."
        }
        Invoke-PClipApi -Method PATCH -Path "/projects/$ProjectId" -Body $body -BaseUrl $BaseUrl -Token $Token
    }
}
