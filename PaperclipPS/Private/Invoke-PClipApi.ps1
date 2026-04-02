function Invoke-PClipApi {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, HelpMessage = "HTTP method (GET, POST, PATCH, PUT, DELETE)")]
        [ValidateSet("GET", "POST", "PATCH", "PUT", "DELETE")]
        [string]$Method,

        [Parameter(Mandatory, HelpMessage = "API path relative to base URL (e.g. /companies)")]
        [string]$Path,

        [Parameter(HelpMessage = "Request body as a hashtable, converted to JSON")]
        [hashtable]$Body,

        [Parameter(HelpMessage = "Query string parameters as a hashtable")]
        [hashtable]$Query,

        [Parameter(HelpMessage = "Paperclip API base URL")]
        [string]$BaseUrl = "http://localhost:3100/api",

        [Parameter(HelpMessage = "Bearer token for authentication")]
        [string]$Token,

        [Parameter(HelpMessage = "Run ID for audit tracking on mutations")]
        [string]$RunId,

        [Parameter(HelpMessage = "Output as a JSON string")]
        [switch]$Json
    )

    $uri = "$BaseUrl$Path"

    if ($Query -and $Query.Count -gt 0) {
        $pairs = foreach ($k in $Query.Keys) {
            if ($null -ne $Query[$k] -and $Query[$k] -ne "") {
                "$k=$([System.Uri]::EscapeDataString($Query[$k]))"
            }
        }
        if ($pairs) {
            $uri += "?" + ($pairs -join "&")
        }
    }

    $headers = @{ "Content-Type" = "application/json" }

    if ($Token) {
        $headers["Authorization"] = "Bearer $Token"
    }
    if ($RunId) {
        $headers["X-Paperclip-Run-Id"] = $RunId
    }

    $splat = @{
        Uri     = $uri
        Method  = $Method
        Headers = $headers
    }

    if ($Body -and $Body.Count -gt 0) {
        $splat["Body"] = ($Body | ConvertTo-Json -Depth 10)
    }

    $result = Invoke-RestMethod @splat
    if ($Json) {
        $result | ConvertTo-Json -Depth 10
    } else {
        $result
    }
}
