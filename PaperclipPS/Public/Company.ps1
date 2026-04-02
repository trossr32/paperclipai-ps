function PClip-Company-List {
    [CmdletBinding()]
    param(
        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    Invoke-PClipApi -Method GET -Path "/companies" -BaseUrl $BaseUrl -Token $Token
}

function PClip-Company-Get {
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
        Invoke-PClipApi -Method GET -Path "/companies/$CompanyId" -BaseUrl $BaseUrl -Token $Token
    }
}

function PClip-Company-Create {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Company name")]
        [string]$Name,

        [Parameter(Position = 1, HelpMessage = "Company description")]
        [string]$Description,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    $body = @{ name = $Name }
    if ($Description) { $body["description"] = $Description }
    Invoke-PClipApi -Method POST -Path "/companies" -Body $body -BaseUrl $BaseUrl -Token $Token
}

function PClip-Company-Update {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, HelpMessage = "Company ID")]
        [string]$CompanyId,

        [Parameter(HelpMessage = "New company name")]
        [string]$Name,

        [Parameter(HelpMessage = "New company description")]
        [string]$Description,

        [Parameter(HelpMessage = "Monthly budget in cents")]
        [int]$BudgetMonthlyCents,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        $body = @{}
        if ($PSBoundParameters.ContainsKey("Name"))               { $body["name"] = $Name }
        if ($PSBoundParameters.ContainsKey("Description"))        { $body["description"] = $Description }
        if ($PSBoundParameters.ContainsKey("BudgetMonthlyCents")) { $body["budgetMonthlyCents"] = $BudgetMonthlyCents }
        if ($body.Count -eq 0) {
            throw "PClip-Company-Update: At least one updatable parameter (Name, Description, BudgetMonthlyCents) must be specified."
        }
        Invoke-PClipApi -Method PATCH -Path "/companies/$CompanyId" -Body $body -BaseUrl $BaseUrl -Token $Token
    }
}

function PClip-Company-Archive {
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
        Invoke-PClipApi -Method POST -Path "/companies/$CompanyId/archive" -BaseUrl $BaseUrl -Token $Token
    }
}
