#Requires -Version 5
$ErrorActionPreference = 'Stop'

$Repo   = 'Peter2594/claude-pr-guard'
$Branch = 'main'
$Base   = "https://raw.githubusercontent.com/$Repo/$Branch"

# Default: install for the current user (available in every project).
# Pass --project to install into .\.claude instead.
if ($args -contains '--project') {
    $Root = Join-Path (Get-Location) ".claude"
} else {
    $Root = Join-Path $HOME ".claude"
}

$SkillDir = Join-Path $Root "skills\pr-guard"
$CmdDir   = Join-Path $Root "commands"

Write-Host "Installing PR Guard -> $Root"
New-Item -ItemType Directory -Force -Path $SkillDir | Out-Null
New-Item -ItemType Directory -Force -Path $CmdDir   | Out-Null

Invoke-WebRequest -Uri "$Base/skills/pr-guard/SKILL.md" -OutFile (Join-Path $SkillDir 'SKILL.md')
Invoke-WebRequest -Uri "$Base/commands/pr-guard.md"     -OutFile (Join-Path $CmdDir 'pr-guard.md')

Write-Host "Installed skill + /pr-guard command."
Write-Host 'Restart Claude Code. Auto: "review my local changes"  -  Manual: /pr-guard'
