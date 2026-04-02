function PClip-Issue-List {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Company ID")]
        [string]$CompanyId,

        [Parameter(HelpMessage = "Filter by status (comma-separated: backlog,todo,in_progress,in_review,done,cancelled)")]
        [string]$Status,

        [Parameter(HelpMessage = "Filter by assigned agent ID")]
        [string]$AssigneeAgentId,

        [Parameter(HelpMessage = "Filter by project ID")]
        [string]$ProjectId,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    $query = @{}
    if ($Status)          { $query["status"] = $Status }
    if ($AssigneeAgentId) { $query["assigneeAgentId"] = $AssigneeAgentId }
    if ($ProjectId)       { $query["projectId"] = $ProjectId }
    Invoke-PClipApi -Method GET -Path "/companies/$CompanyId/issues" -Query $query -BaseUrl $BaseUrl -Token $Token
}

function PClip-Issue-Get {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage = "Issue ID")]
        [string]$IssueId,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        Invoke-PClipApi -Method GET -Path "/issues/$IssueId" -BaseUrl $BaseUrl -Token $Token
    }
}

function PClip-Issue-Create {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Company ID")]
        [string]$CompanyId,

        [Parameter(Mandatory, Position = 1, HelpMessage = "Issue title")]
        [string]$Title,

        [Parameter(HelpMessage = "Issue description")]
        [string]$Description,

        [Parameter(HelpMessage = "Initial status")]
        [ValidateSet("backlog", "todo", "in_progress", "in_review", "done", "cancelled")]
        [string]$Status,

        [Parameter(HelpMessage = "Issue priority (integer)")]
        [int]$Priority,

        [Parameter(HelpMessage = "Agent ID to assign")]
        [string]$AssigneeAgentId,

        [Parameter(HelpMessage = "Parent issue ID")]
        [string]$ParentId,

        [Parameter(HelpMessage = "Project ID")]
        [string]$ProjectId,

        [Parameter(HelpMessage = "Goal ID")]
        [string]$GoalId,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    $body = @{ title = $Title }
    if ($Description)     { $body["description"] = $Description }
    if ($Status)          { $body["status"] = $Status }
    if ($PSBoundParameters.ContainsKey("Priority")) { $body["priority"] = $Priority }
    if ($AssigneeAgentId) { $body["assigneeAgentId"] = $AssigneeAgentId }
    if ($ParentId)        { $body["parentId"] = $ParentId }
    if ($ProjectId)       { $body["projectId"] = $ProjectId }
    if ($GoalId)          { $body["goalId"] = $GoalId }
    Invoke-PClipApi -Method POST -Path "/companies/$CompanyId/issues" -Body $body -BaseUrl $BaseUrl -Token $Token
}

function PClip-Issue-Update {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName, HelpMessage = "Issue ID")]
        [string]$IssueId,

        [Parameter(HelpMessage = "New status")]
        [ValidateSet("backlog", "todo", "in_progress", "in_review", "done", "cancelled")]
        [string]$Status,

        [Parameter(HelpMessage = "New priority (integer)")]
        [int]$Priority,

        [Parameter(HelpMessage = "New title")]
        [string]$Title,

        [Parameter(HelpMessage = "New description")]
        [string]$Description,

        [Parameter(HelpMessage = "Agent ID to assign")]
        [string]$AssigneeAgentId,

        [Parameter(HelpMessage = "Project ID")]
        [string]$ProjectId,

        [Parameter(HelpMessage = "Goal ID")]
        [string]$GoalId,

        [Parameter(HelpMessage = "Parent issue ID")]
        [string]$ParentId,

        [Parameter(HelpMessage = "Billing code")]
        [string]$BillingCode,

        [Parameter(HelpMessage = "Optional comment to attach with the update")]
        [string]$Comment,

        [Parameter(HelpMessage = "Run ID for audit tracking")]
        [string]$RunId,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        $body = @{}
        if ($PSBoundParameters.ContainsKey("Status"))    { $body["status"] = $Status }
        if ($PSBoundParameters.ContainsKey("Priority"))  { $body["priority"] = $Priority }
        if ($PSBoundParameters.ContainsKey("Title"))     { $body["title"] = $Title }
        if ($PSBoundParameters.ContainsKey("Description"))     { $body["description"] = $Description }
        if ($PSBoundParameters.ContainsKey("AssigneeAgentId")) { $body["assigneeAgentId"] = $AssigneeAgentId }
        if ($PSBoundParameters.ContainsKey("ProjectId"))       { $body["projectId"] = $ProjectId }
        if ($PSBoundParameters.ContainsKey("GoalId"))          { $body["goalId"] = $GoalId }
        if ($PSBoundParameters.ContainsKey("ParentId"))        { $body["parentId"] = $ParentId }
        if ($PSBoundParameters.ContainsKey("BillingCode"))     { $body["billingCode"] = $BillingCode }
        if ($PSBoundParameters.ContainsKey("Comment"))         { $body["comment"] = $Comment }
        if ($body.Count -eq 0) {
            throw "PClip-Issue-Update: No updatable fields were provided. Specify at least one of: Status, Priority, Title, Description, AssigneeAgentId, ProjectId, GoalId, ParentId, BillingCode, Comment."
        }
        Invoke-PClipApi -Method PATCH -Path "/issues/$IssueId" -Body $body -BaseUrl $BaseUrl -Token $Token -RunId $RunId
    }
}

function PClip-Issue-Checkout {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Issue ID to check out")]
        [string]$IssueId,

        [Parameter(Mandatory, HelpMessage = "Agent ID claiming the issue")]
        [string]$AgentId,

        [Parameter(HelpMessage = "Expected current statuses for atomic checkout")]
        [ValidateSet("backlog", "todo", "in_progress", "in_review", "done", "cancelled")]
        [string[]]$ExpectedStatuses,

        [Parameter(HelpMessage = "Run ID for audit tracking")]
        [string]$RunId,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    $body = @{ agentId = $AgentId }
    if ($ExpectedStatuses) { $body["expectedStatuses"] = @($ExpectedStatuses) }
    Invoke-PClipApi -Method POST -Path "/issues/$IssueId/checkout" -Body $body -BaseUrl $BaseUrl -Token $Token -RunId $RunId
}

function PClip-Issue-Release {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage = "Issue ID to release")]
        [string]$IssueId,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    process {
        Invoke-PClipApi -Method POST -Path "/issues/$IssueId/release" -BaseUrl $BaseUrl -Token $Token
    }
}
