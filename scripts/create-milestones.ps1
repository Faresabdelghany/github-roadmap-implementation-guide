# PowerShell script to create quarterly milestones for a given year using GitHub API
# Requires: gh CLI authenticated and repo access

param(
    [string]$owner = "Faresabdelghany",
    [string]$repo = "github-roadmap-implementation-guide",
    [int]$year = 2025,
    [switch]$Verbose,
    [switch]$Quiet,
    [string]$Token
)

# Set GH_TOKEN for automation/CI if provided
if ($Token) {
    $env:GH_TOKEN = $Token
    if (-not $Quiet) { Write-Host "Using provided GitHub token for authentication." }
}

# Check for gh CLI
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Error "GitHub CLI (gh) is not installed or not in PATH. Please install it before running this script."
    exit 1
}

$milestones = @(
    @{ title = "Q1 $year - Foundation & Setup"; due_on = "$year-03-31T23:59:59Z"; description = @"
## 🎯 Primary Focus
Establish foundation and core infrastructure

## 📋 Key Objectives
- Set up development environment and tooling
- Implement core architecture and APIs
- Establish team processes and workflows
- Create initial documentation and guidelines

## 🚀 Major Deliverables
- Development environment configured
- Core API framework implemented
- Basic authentication system
- Initial CI/CD pipeline
- Team onboarding completed

## 📊 Success Metrics
- 100% team members onboarded
- Core APIs achieving 99.9% uptime
- All development tools operational
"@ 
    },
    @{ title = "Q2 $year - Core Features"; due_on = "$year-06-30T23:59:59Z"; description = @"
## 🎯 Primary Focus
Build primary user-facing features

## 📋 Key Objectives
- Develop MVP feature set
- Implement user interface components
- Establish data management systems
- Begin user testing and feedback collection

## 🚀 Major Deliverables
- User dashboard implemented
- Data processing engine
- Basic reporting features
- Mobile-responsive design
- Initial user feedback collected

## 📊 Success Metrics
- 90% of MVP features completed
- Performance benchmarks met
- Positive user feedback scores
"@ 
    },
    @{ title = "Q3 $year - Enhancement & Scale"; due_on = "$year-09-30T23:59:59Z"; description = @"
## 🎯 Primary Focus
Enhance features and prepare for scale

## 📋 Key Objectives
- Implement advanced features based on feedback
- Optimize performance and scalability
- Expand integration capabilities
- Strengthen security and compliance

## 🚀 Major Deliverables
- Advanced analytics features
- Third-party integrations
- Performance optimizations
- Security audit completion
- Load testing results

## 📊 Success Metrics
- System handles 10x current load
- Security compliance achieved
- Integration success rate >95%
"@ 
    },
    @{ title = "Q4 $year - Launch & Growth"; due_on = "$year-12-31T23:59:59Z"; description = @"
## 🎯 Primary Focus
Production launch and growth initiatives

## 📋 Key Objectives
- Execute production launch
- Monitor system performance
- Implement growth features
- Plan next year's roadmap

## 🚀 Major Deliverables
- Production deployment
- Monitoring and alerting
- User onboarding automation
- Growth features implemented
- $($year + 1) roadmap planned

## 📊 Success Metrics
- Successful production launch
- 99.9% uptime in production
- Target user acquisition achieved
"@ 
    }
)

$existingMilestones = @()
try {
    $existingMilestones = gh api repos/$owner/$repo/milestones | ConvertFrom-Json
}
catch {
    Write-Warning "Could not fetch existing milestones. Proceeding without duplicate check."
}

$created = 0
$skipped = 0
$failed = 0

foreach ($m in $milestones) {
    $alreadyExists = $false
    if ($existingMilestones) {
        $alreadyExists = $existingMilestones | Where-Object { $_.title -eq $m.title }
    }
    if ($alreadyExists) {
        if (-not $Quiet) { Write-Host "Skipping existing milestone: $($m.title)" }
        $skipped++
        continue
    }
    if (-not $Quiet) { Write-Host "Creating milestone: $($m.title)" }
    try {
        $result = gh api repos/$owner/$repo/milestones -f title="$($m.title)" -f state="open" -f description="$($m.description)" -f due_on="$($m.due_on)" 2>&1
        if ($LASTEXITCODE -eq 0) {
            if ($Verbose -and -not $Quiet) { Write-Host "  ✔ Created successfully" }
            $created++
        }
        else {
            if (-not $Quiet) { Write-Warning "  ✖ Failed to create: $result" }
            $failed++
        }
    }
    catch {
        if (-not $Quiet) { Write-Warning "  ✖ Exception: $_" }
        $failed++
    }
}

if (-not $Quiet) {
    Write-Host "`nSummary: $created created, $skipped skipped (already exist), $failed failed."
}

# Exit with nonzero code if any failures (for CI/CD automation)
if ($failed -gt 0) {
    exit 2
}
elseif ($created -eq 0 -and $skipped -gt 0) {
    exit 0 # All already exist
}
else {
    exit 0
}
