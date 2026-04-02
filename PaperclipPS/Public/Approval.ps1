function PClip-Approval-List {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Company ID")]
        [string]$CompanyId,

        [Parameter(HelpMessage = "Filter by approval status")]
        [ValidateSet("pending", "approved", "rejected", "revision_requested")]
        [string]$Status,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    $query = @{}
    if ($Status) { $query["status"] = $Status }
    Invoke-PClipApi -Method GET -Path "/companies/$CompanyId/approvals" -Query $query -BaseUrl $BaseUrl -Token $Token -Json:$Json
}

function PClip-Approval-Get {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage = "Approval ID")]
        [string]$ApprovalId,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        Invoke-PClipApi -Method GET -Path "/approvals/$ApprovalId" -BaseUrl $BaseUrl -Token $Token -Json:$Json
    }
}

function PClip-Approval-Create {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Company ID")]
        [string]$CompanyId,

        [Parameter(Mandatory, HelpMessage = "Approval type (e.g. approve_ceo_strategy)")]
        [string]$Type,

        [Parameter(Mandatory, HelpMessage = "Agent ID requesting the approval")]
        [string]$RequestedByAgentId,

        [Parameter(Mandatory, HelpMessage = "Approval payload as a hashtable")]
        [hashtable]$Payload,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    $body = @{
        type               = $Type
        requestedByAgentId = $RequestedByAgentId
        payload            = $Payload
    }
    Invoke-PClipApi -Method POST -Path "/companies/$CompanyId/approvals" -Body $body -BaseUrl $BaseUrl -Token $Token -Json:$Json
}

function PClip-Approval-Approve {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, HelpMessage = "Approval ID")]
        [string]$ApprovalId,

        [Parameter(Position = 1, HelpMessage = "Decision note")]
        [string]$DecisionNote,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        $body = @{}
        if ($DecisionNote) { $body["decisionNote"] = $DecisionNote }
        Invoke-PClipApi -Method POST -Path "/approvals/$ApprovalId/approve" -Body $body -BaseUrl $BaseUrl -Token $Token -Json:$Json
    }
}

function PClip-Approval-Reject {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, HelpMessage = "Approval ID")]
        [string]$ApprovalId,

        [Parameter(Position = 1, HelpMessage = "Decision note")]
        [string]$DecisionNote,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        $body = @{}
        if ($DecisionNote) { $body["decisionNote"] = $DecisionNote }
        Invoke-PClipApi -Method POST -Path "/approvals/$ApprovalId/reject" -Body $body -BaseUrl $BaseUrl -Token $Token -Json:$Json
    }
}

function PClip-Approval-RequestRevision {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, HelpMessage = "Approval ID")]
        [string]$ApprovalId,

        [Parameter(Position = 1, HelpMessage = "Decision note")]
        [string]$DecisionNote,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        $body = @{}
        if ($DecisionNote) { $body["decisionNote"] = $DecisionNote }
        Invoke-PClipApi -Method POST -Path "/approvals/$ApprovalId/request-revision" -Body $body -BaseUrl $BaseUrl -Token $Token -Json:$Json
    }
}

function PClip-Approval-Resubmit {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, HelpMessage = "Approval ID")]
        [string]$ApprovalId,

        [Parameter(Mandatory, HelpMessage = "Updated payload as a hashtable")]
        [hashtable]$Payload,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        Invoke-PClipApi -Method POST -Path "/approvals/$ApprovalId/resubmit" -Body @{ payload = $Payload } -BaseUrl $BaseUrl -Token $Token -Json:$Json
    }
}

function PClip-Approval-Issues {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, HelpMessage = "Approval ID")]
        [string]$ApprovalId,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        Invoke-PClipApi -Method GET -Path "/approvals/$ApprovalId/issues" -BaseUrl $BaseUrl -Token $Token -Json:$Json
    }
}

function PClip-Approval-CommentList {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, HelpMessage = "Approval ID")]
        [string]$ApprovalId,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        Invoke-PClipApi -Method GET -Path "/approvals/$ApprovalId/comments" -BaseUrl $BaseUrl -Token $Token -Json:$Json
    }
}

function PClip-Approval-CommentCreate {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Approval ID")]
        [string]$ApprovalId,

        [Parameter(Mandatory, Position = 1, ValueFromPipeline, HelpMessage = "Comment body")]
        [string]$Body,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        Invoke-PClipApi -Method POST -Path "/approvals/$ApprovalId/comments" -Body @{ body = $Body } -BaseUrl $BaseUrl -Token $Token -Json:$Json
    }
}

function PClip-AgentHire-Create {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Company ID")]
        [string]$CompanyId,

        [Parameter(Mandatory, Position = 1, HelpMessage = "Agent name")]
        [string]$Name,

        [Parameter(Mandatory, HelpMessage = "Agent role")]
        [string]$Role,

        [Parameter(Mandatory, HelpMessage = "Manager agent ID")]
        [string]$ReportsTo,

        [Parameter(HelpMessage = "Agent capabilities description")]
        [string]$Capabilities,

        [Parameter(HelpMessage = "Monthly budget in cents")]
        [int]$BudgetMonthlyCents,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    $body = @{
        name      = $Name
        role      = $Role
        reportsTo = $ReportsTo
    }
    if ($Capabilities) { $body["capabilities"] = $Capabilities }
    if ($PSBoundParameters.ContainsKey("BudgetMonthlyCents")) { $body["budgetMonthlyCents"] = $BudgetMonthlyCents }
    Invoke-PClipApi -Method POST -Path "/companies/$CompanyId/agent-hires" -Body $body -BaseUrl $BaseUrl -Token $Token -Json:$Json
}
