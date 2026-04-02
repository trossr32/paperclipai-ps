function PClip-Activity-List {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, HelpMessage = "Company ID")]
        [string]$CompanyId,

        [Parameter(HelpMessage = "Filter by actor agent ID")]
        [string]$AgentId,

        [Parameter(HelpMessage = "Filter by entity type")]
        [ValidateSet("issue", "agent", "approval")]
        [string]$EntityType,

        [Parameter(HelpMessage = "Filter by entity ID")]
        [string]$EntityId,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token
    )
    $query = @{}
    if ($AgentId)    { $query["agentId"] = $AgentId }
    if ($EntityType) { $query["entityType"] = $EntityType }
    if ($EntityId)   { $query["entityId"] = $EntityId }
    Invoke-PClipApi -Method GET -Path "/companies/$CompanyId/activity" -Query $query -BaseUrl $BaseUrl -Token $Token
}
