#Requires -Version 5
$ErrorActionPreference = 'Stop'

$Repo   = 'Peter2594/claude-pr-guard'
$Branch = 'main'
$Skill  = 'pr-guard'
$Raw    = "https://raw.githubusercontent.com/$Repo/$Branch/skills/$Skill/SKILL.md"

# Default: install for the current user (available in every project).
# Pass --project to install into .\.claude\skills instead.
if ($args -contains '--project') {
    $Dest = Join-Path (Get-Location) ".claude\skills\$Skill"
} else {
    $Dest = Join-Path $HOME ".claude\skills\$Skill"
}

Write-Host "Installing PR Guard skill -> $Dest"
New-Item -ItemType Directory -Force -Path $Dest | Out-Null

Invoke-WebRequest -Uri $Raw -OutFile (Join-Path $Dest 'SKILL.md')

Write-Host "Installed."
Write-Host 'Restart Claude Code, then ask: "review my local changes" - PR Guard auto-triggers.'
