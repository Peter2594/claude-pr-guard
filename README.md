# 🛡️ PR Guard — a Claude Code skill

[![GitHub stars](https://img.shields.io/github/stars/Peter2594/claude-pr-guard?style=social)](https://github.com/Peter2594/claude-pr-guard)
[![License: MIT](https://img.shields.io/badge/License-MIT-black.svg)](LICENSE)

A Principal-Engineer code review for your **local, uncommitted changes** — before you commit or push. Ask Claude Code to *"review my changes"* and PR Guard audits the diff for security, correctness, and convention issues, then reports in a tight, scannable format.

Its one job done well: **it doesn't cry wolf.** A real API key sitting in a `.gitignore`d, never-committed `.env` is *not* a leak — PR Guard checks what git actually tracks before flagging anything. Clean diff? It says *"None"* instead of inventing problems.

> This is a **skill**, not a slash command — Claude triggers it automatically when you ask for a local review. It reviews **read-only** by default and only edits files when you explicitly say *"fix it"*.

---

## ⚡ Install

**macOS / Linux**
```bash
curl -fsSL https://raw.githubusercontent.com/Peter2594/claude-pr-guard/main/install.sh | bash
```

**Windows (PowerShell)**
```powershell
irm https://raw.githubusercontent.com/Peter2594/claude-pr-guard/main/install.ps1 | iex
```

Installs to `~/.claude/skills/pr-guard/` (every project). Add `--project` to install into the current repo's `.claude/skills/` instead.

> 🔒 **Piping a remote script to your shell runs whatever it contains.** That's the cost of a one-liner. Prefer to read it first? Open [`install.sh`](install.sh) / [`install.ps1`](install.ps1) — they only `curl` one markdown file into a folder — or just copy [`skills/pr-guard/SKILL.md`](skills/pr-guard/SKILL.md) into your `.claude/skills/pr-guard/` by hand.

---

## 🚀 Use

Two ways, same review — pick your style:

**Automatic (skill)** — just describe the task; Claude triggers PR Guard:
```
review my local changes
```

**Manual (slash command)** — type it explicitly:
```
/pr-guard
/pr-guard --fix      # also patch issues and run your tests
/pr-guard --strict   # zero-tolerance on architecture & conventions
```

Either way, PR Guard scopes the diff (working tree **and** unpushed commits), reads each change in context, and reports:

```
### 🚨 Critical Vulnerabilities
### ⚡ Optimization & Correctness
### 🎯 Test Coverage
```

Want it to fix what it finds and run your tests until green? Say so explicitly:

```
review my changes and fix the issues
```

---

## 🧠 What it actually checks

- **Secrets** introduced by the diff — and whether they're genuinely tracked by git (not just present locally and gitignored)
- **Injection** (SQL / command / XSS), weakened auth or signature checks, missing boundary validation
- **Correctness & performance** — logic bugs, unhandled edge cases, leaks, redundant work — matched to your *actual* stack, not assumed to be React
- **Stray files** (logs, dumps) that would get committed by accident
- **Conventions** from your `CLAUDE.md`, linters, and neighboring code

---

## 🛠️ Customize

Edit `skills/pr-guard/SKILL.md` (or the installed copy under `~/.claude/skills/pr-guard/`). Add your team's review rules under the workflow section — they become part of every review.

---

## License

MIT — see [LICENSE](LICENSE).
