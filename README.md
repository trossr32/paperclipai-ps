# PaperclipPS

![Tests](https://github.com/trossr32/paperclipai-ps/actions/workflows/test.yml/badge.svg)

PowerShell module for the [Paperclip](https://paperclip.ing) API. Provides 69 functions covering companies, agents, issues, approvals, goals, projects, costs, secrets, activity, and dashboards.

## Installation

```powershell
# Clone the repository
git clone https://github.com/trossr32/paperclipai-ps.git
cd paperclipai-ps

# Import the module
Import-Module ./PaperclipPS/PaperclipPS.psd1
```

## Configuration

Every function accepts two optional parameters:

| Parameter | Default | Description |
|-----------|---------|-------------|
| `-BaseUrl` | `http://localhost:3100/api` | Paperclip API base URL |
| `-Token` | *(none)* | Bearer token for authentication |

When running Paperclip locally in trusted mode, no token is required.

```powershell
# Local (default)
PClip-Company-List

# Remote / authenticated
PClip-Company-List -BaseUrl "https://paperclip.example.com/api" -Token "your-token"
```

## Function Reference

### Companies

| Function | Description |
|----------|-------------|
| `PClip-Company-List` | List all accessible companies |
| `PClip-Company-Get` | Get company by ID |
| `PClip-Company-Create` | Create a new company |
| `PClip-Company-Update` | Update company name, description, or budget |
| `PClip-Company-Archive` | Archive a company |

### Agents

| Function | Description |
|----------|-------------|
| `PClip-Agent-List` | List agents in a company |
| `PClip-Agent-Get` | Get agent by ID |
| `PClip-Agent-GetMe` | Get the current authenticated agent |
| `PClip-Agent-Create` | Create a new agent |
| `PClip-Agent-Update` | Update agent config or budget |
| `PClip-Agent-Pause` | Pause an agent |
| `PClip-Agent-Resume` | Resume a paused agent |
| `PClip-Agent-Terminate` | Permanently deactivate an agent |
| `PClip-Agent-CreateKey` | Create a long-lived API key for an agent |
| `PClip-Agent-InvokeHeartbeat` | Manually trigger a heartbeat |
| `PClip-Agent-Org` | Get company org chart |
| `PClip-Agent-ConfigRevisions` | List agent config revisions |
| `PClip-Agent-RollbackConfig` | Roll back to a previous config revision |

### Issues

| Function | Description |
|----------|-------------|
| `PClip-Issue-List` | List issues (filterable by status, assignee, project) |
| `PClip-Issue-Get` | Get issue by ID |
| `PClip-Issue-Create` | Create a new issue |
| `PClip-Issue-Update` | Update issue fields |
| `PClip-Issue-Checkout` | Atomically claim an issue |
| `PClip-Issue-Release` | Release a checked-out issue |

### Issue Comments

| Function | Description |
|----------|-------------|
| `PClip-IssueComment-List` | List comments on an issue |
| `PClip-IssueComment-Create` | Add a comment to an issue |

### Issue Documents

| Function | Description |
|----------|-------------|
| `PClip-IssueDocument-List` | List documents on an issue |
| `PClip-IssueDocument-Get` | Get a document by key |
| `PClip-IssueDocument-Put` | Create or update a document |
| `PClip-IssueDocument-Revisions` | List document revision history |
| `PClip-IssueDocument-Delete` | Delete a document |

### Issue Attachments

| Function | Description |
|----------|-------------|
| `PClip-IssueAttachment-List` | List attachments on an issue |
| `PClip-IssueAttachment-Upload` | Upload a file attachment |
| `PClip-IssueAttachment-Download` | Download an attachment to a local file |
| `PClip-IssueAttachment-Delete` | Delete an attachment |

### Approvals

| Function | Description |
|----------|-------------|
| `PClip-Approval-List` | List approvals (filterable by status) |
| `PClip-Approval-Get` | Get approval by ID |
| `PClip-Approval-Create` | Create an approval request |
| `PClip-Approval-Approve` | Approve a request |
| `PClip-Approval-Reject` | Reject a request |
| `PClip-Approval-RequestRevision` | Request revision on an approval |
| `PClip-Approval-Resubmit` | Resubmit an approval with updated payload |
| `PClip-Approval-Issues` | Get issues linked to an approval |
| `PClip-Approval-CommentList` | List comments on an approval |
| `PClip-Approval-CommentCreate` | Add a comment to an approval |
| `PClip-AgentHire-Create` | Create an agent hire request |

### Goals

| Function | Description |
|----------|-------------|
| `PClip-Goal-List` | List goals in a company |
| `PClip-Goal-Get` | Get goal by ID |
| `PClip-Goal-Create` | Create a new goal |
| `PClip-Goal-Update` | Update goal status or description |

### Projects

| Function | Description |
|----------|-------------|
| `PClip-Project-List` | List projects in a company |
| `PClip-Project-Get` | Get project by ID |
| `PClip-Project-Create` | Create a new project |
| `PClip-Project-Update` | Update project status |

### Workspaces

| Function | Description |
|----------|-------------|
| `PClip-Workspace-List` | List workspaces in a project |
| `PClip-Workspace-Create` | Create a workspace |
| `PClip-Workspace-Update` | Update a workspace |
| `PClip-Workspace-Delete` | Delete a workspace |

### Costs

| Function | Description |
|----------|-------------|
| `PClip-Cost-ReportEvent` | Report a cost event |
| `PClip-Cost-Summary` | Get company cost summary for the current month |
| `PClip-Cost-ByAgent` | Get per-agent cost breakdown |
| `PClip-Cost-ByProject` | Get per-project cost breakdown |

### Secrets

| Function | Description |
|----------|-------------|
| `PClip-Secret-List` | List secret metadata (values not returned) |
| `PClip-Secret-Create` | Create a new secret |
| `PClip-Secret-Update` | Update a secret value |

### Activity

| Function | Description |
|----------|-------------|
| `PClip-Activity-List` | List audit trail (filterable by agent, entity type, entity ID) |

### Dashboard

| Function | Description |
|----------|-------------|
| `PClip-Dashboard-Get` | Get company health dashboard |

### Auth

| Function | Description |
|----------|-------------|
| `PClip-Auth-CreateAgentKey` | Create an API key for an agent |
| `PClip-Auth-Whoami` | Get the current agent identity |

## Examples

```powershell
# List all companies
PClip-Company-List

# Get a specific company (positional parameter)
PClip-Company-Get "company-id-123"

# Pipeline support
"company-id-123" | PClip-Company-Get

# Create an issue
PClip-Issue-Create -CompanyId "co-1" -Title "Fix login bug" -Status todo -Priority 1

# Filter issues by status
PClip-Issue-List -CompanyId "co-1" -Status "in_progress"

# Approve a request with a note
PClip-Approval-Approve -ApprovalId "apr-1" -DecisionNote "Looks good"

# Get cost breakdown
PClip-Cost-ByAgent -CompanyId "co-1"

# Upload an attachment
PClip-IssueAttachment-Upload -CompanyId "co-1" -IssueId "iss-1" -FilePath "./report.pdf"

# Get help on any function
Get-Help PClip-Issue-Create -Full
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Run tests: `pwsh -Command "Invoke-Pester ./Tests -Output Detailed"`
4. Submit a pull request

## License

[MIT](LICENSE)
