# PowerShell script to create custom fields in a GitHub Project (Beta) using GraphQL API
# Requires: gh CLI authenticated and ProjectV2 ID

param(
    [string]$projectId = "YOUR_PROJECT_ID", # <-- Replace with your actual ProjectV2 ID
    [switch]$Verbose,
    [string]$Token
)

if ($Token) { $env:GH_TOKEN = $Token }

function Add-ProjectField {
    param(
        [string]$projectId,
        [string]$name,
        [string]$dataType, # 'TEXT', 'NUMBER', 'DATE', 'SINGLE_SELECT'
        [array]$options = $null
    )
    $optionsBlock = if ($options) {
        $opts = $options | ForEach-Object { '{ "name": "' + $_.name + '"' + (if ($_.description) { ', "description": "' + $_.description + '"' } else { '' }) + (if ($_.color) { ', "color": "' + $_.color + '"' } else { '' }) + ' }' }
        'options: [' + ($opts -join ', ') + ']'
    } else { '' }
    $mutation = @"
mutation {
  addProjectV2Field(input: {
    projectId: "$projectId"
    name: "$name"
    dataType: $dataType
    $optionsBlock
  }) {
    projectV2Field {
      id
      name
    }
  }
}
"@
    if ($Verbose) { Write-Host "Creating field: $name ($dataType)" }
    $result = gh api graphql -f query="$mutation" 2>&1
    if ($LASTEXITCODE -eq 0) {
        if ($Verbose) { Write-Host "  ✔ Field created: $name" }
    } else {
        Write-Warning "  ✖ Failed to create field $name: $result"
    }
}

# Example: Add Status field (Select)
Add-ProjectField -projectId $projectId -name "Status" -dataType "SINGLE_SELECT" -options @(
    @{ name = "📋 Planning" },
    @{ name = "🎨 Design" },
    @{ name = "⚙️ Development" },
    @{ name = "🧪 Testing" },
    @{ name = "🚀 Released" },
    @{ name = "🚫 Blocked" }
)

# Example: Add Priority field (Select)
Add-ProjectField -projectId $projectId -name "Priority" -dataType "SINGLE_SELECT" -options @(
    @{ name = "🆘 Critical" },
    @{ name = "⚠️ High" },
    @{ name = "📋 Medium" },
    @{ name = "🔽 Low" }
)

# Example: Add Team field (Select)
Add-ProjectField -projectId $projectId -name "Team" -dataType "SINGLE_SELECT" -options @(
    @{ name = "💻 Frontend" },
    @{ name = "🔧 Backend" },
    @{ name = "🚀 DevOps" },
    @{ name = "🎨 Design" },
    @{ name = "✅ QA" },
    @{ name = "📊 Product" }
)

# Example: Add Feature Area field (Select)
Add-ProjectField -projectId $projectId -name "Feature Area" -dataType "SINGLE_SELECT" -options @(
    @{ name = "🔥 Core" },
    @{ name = "🏗️ Infrastructure" },
    @{ name = "🔒 Security" },
    @{ name = "🔌 API" },
    @{ name = "🖥️ UI/UX" },
    @{ name = "📚 Documentation" }
)

# Example: Add Effort field (Number)
Add-ProjectField -projectId $projectId -name "Effort" -dataType "NUMBER"

# Example: Add Start Date field (Date)
Add-ProjectField -projectId $projectId -name "Start Date" -dataType "DATE"

# Example: Add Target Date field (Date)
Add-ProjectField -projectId $projectId -name "Target Date" -dataType "DATE"

# Example: Add Progress field (Number)
Add-ProjectField -projectId $projectId -name "Progress" -dataType "NUMBER"

Write-Host "All custom fields attempted. Check your project for results."
