---
description: Principal-engineer review of your local git changes — security, correctness, conventions. Add --fix to patch issues and re-run tests.
argument-hint: "[--fix] [--strict]"
---

Run the **pr-guard** review methodology on this repository's local changes.

Read and follow exactly the skill at `~/.claude/skills/pr-guard/SKILL.md` (or `.claude/skills/pr-guard/SKILL.md` if installed per-project). Produce its exact output schema: the one-line verdict header followed by the three sections.

Arguments: `$ARGUMENTS`
- If `--fix` is present: after reporting, apply the fixes and run the project's real test command until green. Never claim tests pass without running them.
- If `--strict` is present: apply zero-tolerance scrutiny to architecture and convention deviations.
- Default (no args): read-only review.
