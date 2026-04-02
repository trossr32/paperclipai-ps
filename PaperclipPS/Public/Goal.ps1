function PClip-Goal-List {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Company ID")]
        [string]$CompanyId,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    Invoke-PClipApi -Method GET -Path "/companies/$CompanyId/goals" -BaseUrl $BaseUrl -Token $Token
}

function PClip-Goal-Get {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage = "Goal ID")]
        [string]$GoalId,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        Invoke-PClipApi -Method GET -Path "/goals/$GoalId" -BaseUrl $BaseUrl -Token $Token
    }
}

function PClip-Goal-Create {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Company ID")]
        [string]$CompanyId,

        [Parameter(Mandatory, Position = 1, HelpMessage = "Goal title")]
        [string]$Title,

        [Parameter(HelpMessage = "Goal description")]
        [string]$Description,

        [Parameter(HelpMessage = "Goal level")]
        [string]$Level = "company",

        [Parameter(HelpMessage = "Goal status")]
        [ValidateSet("active", "completed", "cancelled")]
        [string]$Status = "active",

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    $body = @{
        title  = $Title
        level  = $Level
        status = $Status
    }
    if ($Description) { $body["description"] = $Description }
    Invoke-PClipApi -Method POST -Path "/companies/$CompanyId/goals" -Body $body -BaseUrl $BaseUrl -Token $Token
}

function PClip-Goal-Update {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, HelpMessage = "Goal ID")]
        [string]$GoalId,

        [Parameter(HelpMessage = "New status")]
        [ValidateSet("active", "completed", "cancelled")]
        [string]$Status,

        [Parameter(HelpMessage = "New description")]
        [string]$Description,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        $body = @{}
        if ($PSBoundParameters.ContainsKey("Status"))      { $body["status"] = $Status }
        if ($PSBoundParameters.ContainsKey("Description")) { $body["description"] = $Description }
        Invoke-PClipApi -Method PATCH -Path "/goals/$GoalId" -Body $body -BaseUrl $BaseUrl -Token $Token
    }
}
