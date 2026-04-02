function PClip-Agent-List {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Company ID")]
        [string]$CompanyId,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    Invoke-PClipApi -Method GET -Path "/companies/$CompanyId/agents" -BaseUrl $BaseUrl -Token $Token
}

function PClip-Agent-Get {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage = "Agent ID")]
        [string]$AgentId,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        Invoke-PClipApi -Method GET -Path "/agents/$AgentId" -BaseUrl $BaseUrl -Token $Token
    }
}

function PClip-Agent-GetMe {
    [CmdletBinding()]
    param(
        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    Invoke-PClipApi -Method GET -Path "/agents/me" -BaseUrl $BaseUrl -Token $Token
}

function PClip-Agent-Create {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Company ID")]
        [string]$CompanyId,

        [Parameter(Mandatory, Position = 1, HelpMessage = "Agent name")]
        [string]$Name,

        [Parameter(Mandatory, HelpMessage = "Agent role")]
        [string]$Role,

        [Parameter(HelpMessage = "Agent title")]
        [string]$Title,

        [Parameter(HelpMessage = "Agent ID this agent reports to")]
        [string]$ReportsTo,

        [Parameter(HelpMessage = "Agent capabilities description")]
        [string]$Capabilities,

        [Parameter(HelpMessage = "Adapter type (e.g. claude, openai)")]
        [string]$AdapterType,

        [Parameter(HelpMessage = "Adapter configuration as a hashtable")]
        [hashtable]$AdapterConfig,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    $body = @{ name = $Name; role = $Role }
    if ($Title)         { $body["title"] = $Title }
    if ($ReportsTo)     { $body["reportsTo"] = $ReportsTo }
    if ($Capabilities)  { $body["capabilities"] = $Capabilities }
    if ($AdapterType)   { $body["adapterType"] = $AdapterType }
    if ($AdapterConfig) { $body["adapterConfig"] = $AdapterConfig }
    Invoke-PClipApi -Method POST -Path "/companies/$CompanyId/agents" -Body $body -BaseUrl $BaseUrl -Token $Token
}

function PClip-Agent-Update {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, HelpMessage = "Agent ID")]
        [string]$AgentId,

        [Parameter(HelpMessage = "Adapter configuration as a hashtable")]
        [hashtable]$AdapterConfig,

        [Parameter(HelpMessage = "Monthly budget in cents")]
        [int]$BudgetMonthlyCents,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        $body = @{}
        if ($PSBoundParameters.ContainsKey("AdapterConfig"))      { $body["adapterConfig"] = $AdapterConfig }
        if ($PSBoundParameters.ContainsKey("BudgetMonthlyCents")) { $body["budgetMonthlyCents"] = $BudgetMonthlyCents }
        if ($body.Count -eq 0) {
            throw "PClip-Agent-Update: At least one updatable parameter (AdapterConfig, BudgetMonthlyCents) must be specified."
        }
        Invoke-PClipApi -Method PATCH -Path "/agents/$AgentId" -Body $body -BaseUrl $BaseUrl -Token $Token
    }
}

function PClip-Agent-Pause {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage = "Agent ID")]
        [string]$AgentId,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        Invoke-PClipApi -Method POST -Path "/agents/$AgentId/pause" -BaseUrl $BaseUrl -Token $Token
    }
}

function PClip-Agent-Resume {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage = "Agent ID")]
        [string]$AgentId,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        Invoke-PClipApi -Method POST -Path "/agents/$AgentId/resume" -BaseUrl $BaseUrl -Token $Token
    }
}

function PClip-Agent-Terminate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage = "Agent ID to permanently deactivate")]
        [string]$AgentId,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        Invoke-PClipApi -Method POST -Path "/agents/$AgentId/terminate" -BaseUrl $BaseUrl -Token $Token
    }
}

function PClip-Agent-CreateKey {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, HelpMessage = "Agent ID")]
        [string]$AgentId,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        Invoke-PClipApi -Method POST -Path "/agents/$AgentId/keys" -BaseUrl $BaseUrl -Token $Token
    }
}

function PClip-Agent-InvokeHeartbeat {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, HelpMessage = "Agent ID")]
        [string]$AgentId,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        Invoke-PClipApi -Method POST -Path "/agents/$AgentId/heartbeat/invoke" -BaseUrl $BaseUrl -Token $Token
    }
}

function PClip-Agent-Org {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Company ID")]
        [string]$CompanyId,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    Invoke-PClipApi -Method GET -Path "/companies/$CompanyId/org" -BaseUrl $BaseUrl -Token $Token
}

function PClip-Agent-ConfigRevisions {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, HelpMessage = "Agent ID")]
        [string]$AgentId,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        Invoke-PClipApi -Method GET -Path "/agents/$AgentId/config-revisions" -BaseUrl $BaseUrl -Token $Token
    }
}

function PClip-Agent-RollbackConfig {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Agent ID")]
        [string]$AgentId,

        [Parameter(Mandatory, Position = 1, HelpMessage = "Config revision ID to roll back to")]
        [string]$RevisionId,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    Invoke-PClipApi -Method POST -Path "/agents/$AgentId/config-revisions/$RevisionId/rollback" -BaseUrl $BaseUrl -Token $Token
}
