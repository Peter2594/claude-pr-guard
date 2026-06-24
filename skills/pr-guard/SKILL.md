---
name: pr-guard
description: Use when reviewing local uncommitted git changes before a commit, push, or pull request - the user asks to "review my changes", "check my diff", "audit before pushing", "pr guard", or wants a security and quality pass on staged or unstaged work. Not for reviewing an already-open remote PR.
---

# PR Guard

## Overview

Principal-engineer review of the **local working tree** (staged + unstaged changes), not a remote PR. Find real correctness, security, and convention problems in the diff — and report nothing when nothing is wrong.

**Core principle: report only what the diff actually shows. A confident "No issues" beats a hallucinated vulnerability.** A review that invents problems to look thorough is worse than no review.

## When to Use

- Before `git commit`, `git push`, or opening a pull request
- User asks to review / audit local changes, the diff, or staged work
- **Not** for: reviewing an already-open remote GitHub PR (use `gh pr` tooling), or a clean working tree (nothing to review)

## Workflow

1. **Scope the change.** Run `git status --porcelain` to see the working tree. Then determine the full review range:
   - **Working tree** (staged + unstaged): `git diff HEAD`.
   - **Unpushed commits** (critical for a pre-push guard): if an upstream exists (`git rev-parse --abbrev-ref @{upstream}` succeeds), also review `git diff @{upstream}...HEAD`. A secret committed two commits ago but not yet pushed is exactly what this tool must catch — diffing only the working tree would miss it.
   - If there's no upstream, review all of `git diff HEAD` plus, if asked before a push, the branch's commits with `git log --oneline @{push}..HEAD 2>/dev/null` or against the default branch.
   If this isn't a git repo, or there's nothing to review, say so plainly and stop — don't manufacture findings.
2. **Read the diff with context.** Diff the range from step 1. For every non-trivial hunk, open the surrounding code in the file. A 2-line change can break a 200-line function — never judge a hunk in isolation.
3. **Security audit (highest priority):**
   - Hardcoded secrets introduced by the diff: API keys, tokens, passwords, connection strings, private keys.
   - **Before flagging any secret file (`.env`, credentials) as a leak, verify git actually tracks it.** Check `git ls-files` and `.gitignore`. A real key in a gitignored, never-committed file is **NOT** a leak — do not cry wolf. A secret in a *tracked* file IS critical.
   - Injection (SQL / command / XSS), unsafe deserialization, weakened or bypassed auth/signature checks, missing input validation at trust boundaries.
   - Stray files that would be committed by accident (logs, dumps, build output) and aren't gitignored.
4. **Correctness & performance:** logic errors the diff introduces, unhandled errors and edge cases, redundant computation, leaks (unclosed handles, dangling listeners/timers), and framework footguns. Match the project's **actual** stack — do not assume React/TypeScript when it's Python, Go, Rust, etc.
5. **Conventions:** consult `CLAUDE.md`, linter/formatter config, and neighboring code; flag deviations from established patterns.
6. **Report** using the schema below — nothing else, no filler.
7. **Fix ONLY when explicitly asked** ("fix it", "patch it", `--fix`): edit the files, then run the project's **real** test command (detect it: `package.json` scripts, `pytest`, `go test`, `cargo test`, `make test`…). Iterate until green. Never claim tests pass without running them; if there is no test suite, say so.

## Output Schema

Output exactly these sections. Omit conversational filler.

### 🚨 Critical Vulnerabilities
- *None* — or — `path:line` — the flaw and its concrete exploit/impact

### ⚡ Optimization & Correctness
- **Issue**: [bottleneck, bug, or bad practice]
- **Fix**:
```
// minimal corrected code, in the file's actual language
```

### 🎯 Test Coverage
- Untested code paths this change introduces. List the exact edge cases that need tests.

## Common Mistakes

- **Hallucinating vulnerabilities** to appear thorough. Clean diff → report *None*.
- **Flagging gitignored, never-committed secrets as leaks.** Verify tracking first.
- **Reviewing hunks without their surrounding code.** Always read context.
- **Only diffing the working tree before a push.** Unpushed commits ship too — include `@{upstream}...HEAD`.
- **Assuming the stack** (React/Node) when the repo is Python/Go/Rust/etc.
- **Claiming "tests pass" without running them.** Run them, or state you did not.
- **Auto-fixing without being asked.** Default is read-only review.
