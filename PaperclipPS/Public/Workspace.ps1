function PClip-Workspace-List {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Project ID")]
        [string]$ProjectId,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    Invoke-PClipApi -Method GET -Path "/projects/$ProjectId/workspaces" -BaseUrl $BaseUrl -Token $Token -Json:$Json
}

function PClip-Workspace-Create {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Project ID")]
        [string]$ProjectId,

        [Parameter(Mandatory, Position = 1, HelpMessage = "Workspace name")]
        [string]$Name,

        [Parameter(HelpMessage = "Working directory path")]
        [string]$Cwd,

        [Parameter(HelpMessage = "Repository URL")]
        [string]$RepoUrl,

        [Parameter(HelpMessage = "Repository ref (branch/tag)")]
        [string]$RepoRef,

        [Parameter(HelpMessage = "Mark as primary workspace")]
        [switch]$IsPrimary,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    $body = @{ name = $Name }
    if ($Cwd)     { $body["cwd"] = $Cwd }
    if ($RepoUrl) { $body["repoUrl"] = $RepoUrl }
    if ($RepoRef) { $body["repoRef"] = $RepoRef }
    if ($IsPrimary.IsPresent) { $body["isPrimary"] = $true }
    Invoke-PClipApi -Method POST -Path "/projects/$ProjectId/workspaces" -Body $body -BaseUrl $BaseUrl -Token $Token -Json:$Json
}

function PClip-Workspace-Update {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Project ID")]
        [string]$ProjectId,

        [Parameter(Mandatory, Position = 1, HelpMessage = "Workspace ID")]
        [string]$WorkspaceId,

        [Parameter(HelpMessage = "New workspace name")]
        [string]$Name,

        [Parameter(HelpMessage = "New working directory path")]
        [string]$Cwd,

        [Parameter(HelpMessage = "New repository URL")]
        [string]$RepoUrl,

        [Parameter(HelpMessage = "New repository ref")]
        [string]$RepoRef,

        [Parameter(HelpMessage = "Mark as primary workspace")]
        [switch]$IsPrimary,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    $body = @{}
    if ($PSBoundParameters.ContainsKey("Name"))    { $body["name"] = $Name }
    if ($PSBoundParameters.ContainsKey("Cwd"))     { $body["cwd"] = $Cwd }
    if ($PSBoundParameters.ContainsKey("RepoUrl")) { $body["repoUrl"] = $RepoUrl }
    if ($PSBoundParameters.ContainsKey("RepoRef")) { $body["repoRef"] = $RepoRef }
    if ($IsPrimary.IsPresent)                      { $body["isPrimary"] = $true }
    if ($body.Count -eq 0) {
        throw "PClip-Workspace-Update: No workspace update parameters were provided. Specify at least one of -Name, -Cwd, -RepoUrl, -RepoRef, or -IsPrimary."
    }
    Invoke-PClipApi -Method PATCH -Path "/projects/$ProjectId/workspaces/$WorkspaceId" -Body $body -BaseUrl $BaseUrl -Token $Token -Json:$Json
}

function PClip-Workspace-Delete {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Project ID")]
        [string]$ProjectId,

        [Parameter(Mandatory, Position = 1, HelpMessage = "Workspace ID")]
        [string]$WorkspaceId,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    Invoke-PClipApi -Method DELETE -Path "/projects/$ProjectId/workspaces/$WorkspaceId" -BaseUrl $BaseUrl -Token $Token -Json:$Json
}
