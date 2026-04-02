function PClip-Cost-ReportEvent {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Company ID")]
        [string]$CompanyId,

        [Parameter(Mandatory, HelpMessage = "Agent ID that incurred the cost")]
        [string]$AgentId,

        [Parameter(Mandatory, HelpMessage = "LLM provider name")]
        [string]$Provider,

        [Parameter(Mandatory, HelpMessage = "Model name")]
        [string]$Model,

        [Parameter(Mandatory, HelpMessage = "Number of input tokens")]
        [int]$InputTokens,

        [Parameter(Mandatory, HelpMessage = "Number of output tokens")]
        [int]$OutputTokens,

        [Parameter(Mandatory, HelpMessage = "Cost in cents")]
        [int]$CostCents,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    $body = @{
        agentId      = $AgentId
        provider     = $Provider
        model        = $Model
        inputTokens  = $InputTokens
        outputTokens = $OutputTokens
        costCents    = $CostCents
    }
    Invoke-PClipApi -Method POST -Path "/companies/$CompanyId/cost-events" -Body $body -BaseUrl $BaseUrl -Token $Token
}

function PClip-Cost-Summary {
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
        Invoke-PClipApi -Method GET -Path "/companies/$CompanyId/costs/summary" -BaseUrl $BaseUrl -Token $Token
    }
}

function PClip-Cost-ByAgent {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, HelpMessage = "Company ID")]
        [string]$CompanyId,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        Invoke-PClipApi -Method GET -Path "/companies/$CompanyId/costs/by-agent" -BaseUrl $BaseUrl -Token $Token
    }
}

function PClip-Cost-ByProject {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, HelpMessage = "Company ID")]
        [string]$CompanyId,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        Invoke-PClipApi -Method GET -Path "/companies/$CompanyId/costs/by-project" -BaseUrl $BaseUrl -Token $Token
    }
}
