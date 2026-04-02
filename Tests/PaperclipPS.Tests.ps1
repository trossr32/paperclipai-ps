BeforeAll {
    $modulePath = Join-Path $PSScriptRoot '..' 'PaperclipPS' 'PaperclipPS.psd1'
    Import-Module $modulePath -Force

    $script:AllFunctions = Get-Command -Module PaperclipPS

    $script:CommonParamNames = @(
        'Verbose','Debug','ErrorAction','ErrorVariable','WarningAction','WarningVariable',
        'OutBuffer','OutVariable','PipelineVariable','InformationAction','InformationVariable','ProgressAction'
    )
}

Describe 'Module: PaperclipPS' {

    Context 'Module loading' {
        It 'should import without errors' {
            { Import-Module (Join-Path $PSScriptRoot '..' 'PaperclipPS' 'PaperclipPS.psd1') -Force } | Should -Not -Throw
        }

        It 'should export 69 functions' {
            (Get-Command -Module PaperclipPS).Count | Should -Be 69
        }

        It 'should not export private helper Invoke-PClipApi' {
            Get-Command -Module PaperclipPS -Name 'Invoke-PClipApi' -ErrorAction SilentlyContinue | Should -BeNullOrEmpty
        }
    }

    Context 'All expected functions are exported' {
        It 'should export <_>' -ForEach @(
            'PClip-Activity-List'
            'PClip-Agent-ConfigRevisions'
            'PClip-Agent-Create'
            'PClip-Agent-CreateKey'
            'PClip-Agent-Get'
            'PClip-Agent-GetMe'
            'PClip-AgentHire-Create'
            'PClip-Agent-InvokeHeartbeat'
            'PClip-Agent-List'
            'PClip-Agent-Org'
            'PClip-Agent-Pause'
            'PClip-Agent-Resume'
            'PClip-Agent-RollbackConfig'
            'PClip-Agent-Terminate'
            'PClip-Agent-Update'
            'PClip-Approval-Approve'
            'PClip-Approval-CommentCreate'
            'PClip-Approval-CommentList'
            'PClip-Approval-Create'
            'PClip-Approval-Get'
            'PClip-Approval-Issues'
            'PClip-Approval-List'
            'PClip-Approval-Reject'
            'PClip-Approval-RequestRevision'
            'PClip-Approval-Resubmit'
            'PClip-Auth-CreateAgentKey'
            'PClip-Auth-Whoami'
            'PClip-Company-Archive'
            'PClip-Company-Create'
            'PClip-Company-Get'
            'PClip-Company-List'
            'PClip-Company-Update'
            'PClip-Cost-ByAgent'
            'PClip-Cost-ByProject'
            'PClip-Cost-ReportEvent'
            'PClip-Cost-Summary'
            'PClip-Dashboard-Get'
            'PClip-Goal-Create'
            'PClip-Goal-Get'
            'PClip-Goal-List'
            'PClip-Goal-Update'
            'PClip-IssueAttachment-Delete'
            'PClip-IssueAttachment-Download'
            'PClip-IssueAttachment-List'
            'PClip-IssueAttachment-Upload'
            'PClip-Issue-Checkout'
            'PClip-IssueComment-Create'
            'PClip-IssueComment-List'
            'PClip-Issue-Create'
            'PClip-IssueDocument-Delete'
            'PClip-IssueDocument-Get'
            'PClip-IssueDocument-List'
            'PClip-IssueDocument-Put'
            'PClip-IssueDocument-Revisions'
            'PClip-Issue-Get'
            'PClip-Issue-List'
            'PClip-Issue-Release'
            'PClip-Issue-Update'
            'PClip-Project-Create'
            'PClip-Project-Get'
            'PClip-Project-List'
            'PClip-Project-Update'
            'PClip-Secret-Create'
            'PClip-Secret-List'
            'PClip-Secret-Update'
            'PClip-Workspace-Create'
            'PClip-Workspace-Delete'
            'PClip-Workspace-List'
            'PClip-Workspace-Update'
        ) {
            $script:AllFunctions.Name | Should -Contain $_
        }
    }

    Context 'Common parameters: BaseUrl and Token' {
        It 'every function should have -BaseUrl with HelpMessage' {
            $allFunctions = Get-Command -Module PaperclipPS
            foreach ($fn in $allFunctions) {
                $param = $fn.Parameters['BaseUrl']
                $param | Should -Not -BeNullOrEmpty -Because "$($fn.Name) should have BaseUrl"
                $attr = $param.Attributes.Where({ $_ -is [System.Management.Automation.ParameterAttribute] })[0]
                $attr.HelpMessage | Should -Not -BeNullOrEmpty -Because "$($fn.Name) BaseUrl should have HelpMessage"
            }
        }

        It 'every function source should default BaseUrl to http://localhost:3100/api' {
            $publicDir = Join-Path $PSScriptRoot '..' 'PaperclipPS' 'Public'
            $files = Get-ChildItem $publicDir -Filter '*.ps1'
            foreach ($file in $files) {
                $content = Get-Content $file.FullName -Raw
                $matches = [regex]::Matches($content, '\$BaseUrl\s*=\s*"([^"]+)"')
                foreach ($m in $matches) {
                    $m.Groups[1].Value | Should -Be 'http://localhost:3100/api' -Because "$($file.Name) BaseUrl default"
                }
            }
        }

        It 'every function should have -Token parameter' {
            $allFunctions = Get-Command -Module PaperclipPS
            foreach ($fn in $allFunctions) {
                $fn.Parameters['Token'] | Should -Not -BeNullOrEmpty -Because "$($fn.Name) should have Token"
            }
        }
    }

    Context 'Json switch parameter' {
        It 'every function should have -Json as a switch parameter' {
            $allFunctions = Get-Command -Module PaperclipPS
            foreach ($fn in $allFunctions) {
                $param = $fn.Parameters['Json']
                $param | Should -Not -BeNullOrEmpty -Because "$($fn.Name) should have -Json"
                $param.ParameterType.Name | Should -Be 'SwitchParameter' -Because "$($fn.Name) -Json should be a switch"
            }
        }

        It 'public function should pass -Json through to Invoke-PClipApi' {
            Mock Invoke-PClipApi { } -ModuleName PaperclipPS
            PClip-Company-Get -CompanyId 'test' -Json
            Should -Invoke Invoke-PClipApi -ModuleName PaperclipPS -ParameterFilter { $Json -eq $true }
        }

        It 'Invoke-PClipApi -Json should convert result to JSON string' {
            Mock Invoke-RestMethod { @{ id = 'c1'; name = 'Test' } } -ModuleName PaperclipPS
            $result = & (Get-Module PaperclipPS) { Invoke-PClipApi -Method GET -Path '/test' -Json }
            $result | Should -BeOfType [string]
            ($result | ConvertFrom-Json).id | Should -Be 'c1'
        }

        It 'Invoke-PClipApi without -Json should return object' {
            Mock Invoke-RestMethod { [pscustomobject]@{ id = 'c1'; name = 'Test' } } -ModuleName PaperclipPS
            $result = & (Get-Module PaperclipPS) { Invoke-PClipApi -Method GET -Path '/test' }
            $result.id | Should -Be 'c1'
        }
    }

    Context 'HelpMessage on every parameter' {
        It 'every user-facing parameter should have a HelpMessage' {
            $commonParams = @(
                'Verbose','Debug','ErrorAction','ErrorVariable','WarningAction','WarningVariable',
                'OutBuffer','OutVariable','PipelineVariable','InformationAction','InformationVariable','ProgressAction'
            )
            $allFunctions = Get-Command -Module PaperclipPS
            foreach ($fn in $allFunctions) {
                $params = $fn.Parameters.GetEnumerator() | Where-Object { $_.Key -notin $commonParams }
                foreach ($p in $params) {
                    $attr = $p.Value.Attributes.Where({ $_ -is [System.Management.Automation.ParameterAttribute] })[0]
                    $attr.HelpMessage | Should -Not -BeNullOrEmpty -Because "$($fn.Name) -$($p.Key) should have HelpMessage"
                }
            }
        }
    }

    Context 'Company functions' {
        It 'PClip-Company-Get -CompanyId should be mandatory, position 0, pipeline' {
            $param = (Get-Command PClip-Company-Get).Parameters['CompanyId']
            $attr = $param.Attributes.Where({ $_ -is [System.Management.Automation.ParameterAttribute] })[0]
            $attr.Mandatory | Should -BeTrue
            $attr.Position | Should -Be 0
            $attr.ValueFromPipeline | Should -BeTrue
        }

        It 'PClip-Company-Create -Name should be mandatory, position 0' {
            $param = (Get-Command PClip-Company-Create).Parameters['Name']
            $attr = $param.Attributes.Where({ $_ -is [System.Management.Automation.ParameterAttribute] })[0]
            $attr.Mandatory | Should -BeTrue
            $attr.Position | Should -Be 0
        }

        It 'PClip-Company-Update should throw when no updatable parameters are supplied' {
            { PClip-Company-Update -CompanyId 'test-id' } | Should -Throw -ExpectedMessage '*At least one updatable parameter*'
        }

        It 'PClip-Company-Update should not throw when -Name is supplied' {
            Mock Invoke-PClipApi { } -ModuleName PaperclipPS
            { PClip-Company-Update -CompanyId 'test-id' -Name 'NewName' } | Should -Not -Throw
        }

        It 'PClip-Company-Update should not throw when -Description is supplied' {
            Mock Invoke-PClipApi { } -ModuleName PaperclipPS
            { PClip-Company-Update -CompanyId 'test-id' -Description 'New desc' } | Should -Not -Throw
        }

        It 'PClip-Company-Update should not throw when -BudgetMonthlyCents is supplied' {
            Mock Invoke-PClipApi { } -ModuleName PaperclipPS
            { PClip-Company-Update -CompanyId 'test-id' -BudgetMonthlyCents 5000 } | Should -Not -Throw
        }
    }

    Context 'Agent functions' {
        It 'PClip-Agent-Get -AgentId should be mandatory, position 0, pipeline' {
            $param = (Get-Command PClip-Agent-Get).Parameters['AgentId']
            $attr = $param.Attributes.Where({ $_ -is [System.Management.Automation.ParameterAttribute] })[0]
            $attr.Mandatory | Should -BeTrue
            $attr.Position | Should -Be 0
            $attr.ValueFromPipeline | Should -BeTrue
        }

        It 'PClip-Agent-List -CompanyId should be mandatory' {
            $param = (Get-Command PClip-Agent-List).Parameters['CompanyId']
            $attr = $param.Attributes.Where({ $_ -is [System.Management.Automation.ParameterAttribute] })[0]
            $attr.Mandatory | Should -BeTrue
        }

        It 'PClip-Agent-RollbackConfig should require AgentId and RevisionId' {
            $cmd = Get-Command PClip-Agent-RollbackConfig
            $cmd.Parameters['AgentId'].Attributes.Where({ $_ -is [System.Management.Automation.ParameterAttribute] })[0].Mandatory | Should -BeTrue
            $cmd.Parameters['RevisionId'].Attributes.Where({ $_ -is [System.Management.Automation.ParameterAttribute] })[0].Mandatory | Should -BeTrue
        }

        It 'PClip-Agent-Update should throw when no updatable parameters are supplied' {
            { PClip-Agent-Update -AgentId 'test-id' } | Should -Throw -ExpectedMessage '*At least one updatable parameter*'
        }

        It 'PClip-Agent-Update should not throw when -AdapterConfig is supplied' {
            Mock Invoke-PClipApi { } -ModuleName PaperclipPS
            { PClip-Agent-Update -AgentId 'test-id' -AdapterConfig @{ key = 'value' } } | Should -Not -Throw
        }

        It 'PClip-Agent-Update should not throw when -BudgetMonthlyCents is supplied' {
            Mock Invoke-PClipApi { } -ModuleName PaperclipPS
            { PClip-Agent-Update -AgentId 'test-id' -BudgetMonthlyCents 1000 } | Should -Not -Throw
        }
    }

    Context 'Issue functions' {
        It 'PClip-Issue-Get -IssueId should be mandatory, position 0, pipeline' {
            $param = (Get-Command PClip-Issue-Get).Parameters['IssueId']
            $attr = $param.Attributes.Where({ $_ -is [System.Management.Automation.ParameterAttribute] })[0]
            $attr.Mandatory | Should -BeTrue
            $attr.Position | Should -Be 0
            $attr.ValueFromPipeline | Should -BeTrue
        }

        It 'PClip-Issue-Create -Status should have ValidateSet' {
            $param = (Get-Command PClip-Issue-Create).Parameters['Status']
            $vs = $param.Attributes.Where({ $_ -is [System.Management.Automation.ValidateSetAttribute] })
            $vs.Count | Should -BeGreaterThan 0
            $vs[0].ValidValues | Should -Contain 'todo'
            $vs[0].ValidValues | Should -Contain 'in_progress'
            $vs[0].ValidValues | Should -Contain 'done'
            $vs[0].ValidValues | Should -Contain 'cancelled'
        }

        It 'PClip-Issue-Checkout -ExpectedStatuses should accept array with ValidateSet' {
            $param = (Get-Command PClip-Issue-Checkout).Parameters['ExpectedStatuses']
            $param.ParameterType.Name | Should -Be 'String[]'
            $vs = $param.Attributes.Where({ $_ -is [System.Management.Automation.ValidateSetAttribute] })
            $vs.Count | Should -BeGreaterThan 0
        }

        It 'PClip-Issue-Update should throw when no updatable fields are supplied' {
            { PClip-Issue-Update -IssueId 'test-id' } | Should -Throw -ExpectedMessage '*No updatable fields were provided*'
        }

        It 'PClip-Issue-Update should not throw when -Status is supplied' {
            Mock Invoke-PClipApi { } -ModuleName PaperclipPS
            { PClip-Issue-Update -IssueId 'test-id' -Status 'todo' } | Should -Not -Throw
        }

        It 'PClip-Issue-Update should not throw when -Title is supplied' {
            Mock Invoke-PClipApi { } -ModuleName PaperclipPS
            { PClip-Issue-Update -IssueId 'test-id' -Title 'New Title' } | Should -Not -Throw
        }

        It 'PClip-Issue-Update should not throw when -Description is supplied' {
            Mock Invoke-PClipApi { } -ModuleName PaperclipPS
            { PClip-Issue-Update -IssueId 'test-id' -Description 'New desc' } | Should -Not -Throw
        }
    }

    Context 'Approval functions' {
        It 'PClip-Approval-Get -ApprovalId should be mandatory, position 0, pipeline' {
            $param = (Get-Command PClip-Approval-Get).Parameters['ApprovalId']
            $attr = $param.Attributes.Where({ $_ -is [System.Management.Automation.ParameterAttribute] })[0]
            $attr.Mandatory | Should -BeTrue
            $attr.Position | Should -Be 0
            $attr.ValueFromPipeline | Should -BeTrue
        }

        It 'PClip-Approval-List -Status should have ValidateSet with pending, approved, rejected, revision_requested' {
            $param = (Get-Command PClip-Approval-List).Parameters['Status']
            $vs = $param.Attributes.Where({ $_ -is [System.Management.Automation.ValidateSetAttribute] })
            $vs.Count | Should -BeGreaterThan 0
            $vs[0].ValidValues | Should -Contain 'pending'
            $vs[0].ValidValues | Should -Contain 'approved'
            $vs[0].ValidValues | Should -Contain 'rejected'
            $vs[0].ValidValues | Should -Contain 'revision_requested'
        }
    }

    Context 'Goal functions' {
        It 'PClip-Goal-Get -GoalId should be mandatory, position 0, pipeline' {
            $param = (Get-Command PClip-Goal-Get).Parameters['GoalId']
            $attr = $param.Attributes.Where({ $_ -is [System.Management.Automation.ParameterAttribute] })[0]
            $attr.Mandatory | Should -BeTrue
            $attr.Position | Should -Be 0
            $attr.ValueFromPipeline | Should -BeTrue
        }

        It 'PClip-Goal-Create -Status should have ValidateSet' {
            $param = (Get-Command PClip-Goal-Create).Parameters['Status']
            $vs = $param.Attributes.Where({ $_ -is [System.Management.Automation.ValidateSetAttribute] })
            $vs.Count | Should -BeGreaterThan 0
            $vs[0].ValidValues | Should -Contain 'active'
        }

        It 'PClip-Goal-Update should throw when no updatable parameters are supplied' {
            { PClip-Goal-Update -GoalId 'test-id' } | Should -Throw -ExpectedMessage '*At least one of -Status or -Description*'
        }

        It 'PClip-Goal-Update should not throw when -Status is supplied' {
            Mock Invoke-PClipApi { } -ModuleName PaperclipPS
            { PClip-Goal-Update -GoalId 'test-id' -Status 'active' } | Should -Not -Throw
        }

        It 'PClip-Goal-Update should not throw when -Description is supplied' {
            Mock Invoke-PClipApi { } -ModuleName PaperclipPS
            { PClip-Goal-Update -GoalId 'test-id' -Description 'New desc' } | Should -Not -Throw
        }
    }

    Context 'Project functions' {
        It 'PClip-Project-Get -ProjectId should be mandatory, position 0, pipeline' {
            $param = (Get-Command PClip-Project-Get).Parameters['ProjectId']
            $attr = $param.Attributes.Where({ $_ -is [System.Management.Automation.ParameterAttribute] })[0]
            $attr.Mandatory | Should -BeTrue
            $attr.Position | Should -Be 0
            $attr.ValueFromPipeline | Should -BeTrue
        }

        It 'PClip-Project-Update should throw when no updatable properties are supplied' {
            { PClip-Project-Update -ProjectId 'test-id' } | Should -Throw -ExpectedMessage '*No updatable properties were specified*'
        }

        It 'PClip-Project-Update should not throw when -Status is supplied' {
            Mock Invoke-PClipApi { } -ModuleName PaperclipPS
            { PClip-Project-Update -ProjectId 'test-id' -Status 'active' } | Should -Not -Throw
        }
    }

    Context 'Workspace functions' {
        It 'PClip-Workspace-Update should throw when no updatable parameters are supplied' {
            { PClip-Workspace-Update -ProjectId 'test-project' -WorkspaceId 'test-ws' } | Should -Throw -ExpectedMessage '*No workspace update parameters were provided*'
        }

        It 'PClip-Workspace-Update should not throw when -Name is supplied' {
            Mock Invoke-PClipApi { } -ModuleName PaperclipPS
            { PClip-Workspace-Update -ProjectId 'test-project' -WorkspaceId 'test-ws' -Name 'NewName' } | Should -Not -Throw
        }

        It 'PClip-Workspace-Update should not throw when -IsPrimary is supplied' {
            Mock Invoke-PClipApi { } -ModuleName PaperclipPS
            { PClip-Workspace-Update -ProjectId 'test-project' -WorkspaceId 'test-ws' -IsPrimary } | Should -Not -Throw
        }
    }

    Context 'Dashboard function' {
        It 'PClip-Dashboard-Get -CompanyId should be mandatory, position 0, pipeline' {
            $param = (Get-Command PClip-Dashboard-Get).Parameters['CompanyId']
            $attr = $param.Attributes.Where({ $_ -is [System.Management.Automation.ParameterAttribute] })[0]
            $attr.Mandatory | Should -BeTrue
            $attr.Position | Should -Be 0
            $attr.ValueFromPipeline | Should -BeTrue
        }
    }

    Context 'Activity function' {
        It 'PClip-Activity-List -EntityType should have ValidateSet issue, agent, approval' {
            $param = (Get-Command PClip-Activity-List).Parameters['EntityType']
            $vs = $param.Attributes.Where({ $_ -is [System.Management.Automation.ValidateSetAttribute] })
            $vs.Count | Should -BeGreaterThan 0
            $vs[0].ValidValues | Should -Contain 'issue'
            $vs[0].ValidValues | Should -Contain 'agent'
            $vs[0].ValidValues | Should -Contain 'approval'
        }
    }

    Context 'Attachment functions' {
        It 'PClip-IssueAttachment-Upload -FilePath should have ValidateScript' {
            $param = (Get-Command PClip-IssueAttachment-Upload).Parameters['FilePath']
            $vs = $param.Attributes.Where({ $_ -is [System.Management.Automation.ValidateScriptAttribute] })
            $vs.Count | Should -BeGreaterThan 0
        }

        It 'PClip-IssueAttachment-Download -OutFile should be mandatory' {
            $param = (Get-Command PClip-IssueAttachment-Download).Parameters['OutFile']
            $attr = $param.Attributes.Where({ $_ -is [System.Management.Automation.ParameterAttribute] })[0]
            $attr.Mandatory | Should -BeTrue
        }
    }

    Context 'Cost functions' {
        It 'PClip-Cost-ReportEvent should require all cost fields' {
            $cmd = Get-Command PClip-Cost-ReportEvent
            foreach ($name in @('CompanyId','AgentId','Provider','Model','InputTokens','OutputTokens','CostCents')) {
                $cmd.Parameters[$name].Attributes.Where({ $_ -is [System.Management.Automation.ParameterAttribute] })[0].Mandatory | Should -BeTrue -Because "$name should be mandatory"
            }
        }
    }

    Context 'Secret functions' {
        It 'PClip-Secret-Create should require CompanyId, Name, Value' {
            $cmd = Get-Command PClip-Secret-Create
            foreach ($name in @('CompanyId','Name','Value')) {
                $cmd.Parameters[$name].Attributes.Where({ $_ -is [System.Management.Automation.ParameterAttribute] })[0].Mandatory | Should -BeTrue -Because "$name should be mandatory"
            }
        }
    }
}
