---
description: Stage, commit, and push changes with approval workflow
---

# Commit Command

## Step 1: Gather Context

- `git status --short --branch`
- `git diff` and `git diff --cached`
- `git log --oneline -5`

## Step 2: Determine Scope

**If on main/master with a small change:** Direct commit - single-line message, push.
**If on main/master with significant changes:** Create a feature branch first.
**If a PR description was already drafted by `/wrap`:** Use it.

## Step 3: Execute

1. Stage relevant files
2. Create a concise commit (single line, imperative mood, max 72 chars)
3. Push
4. If PR-worthy: create PR with `gh pr create` using the `/wrap` description, or ask the user to run `/wrap` first

## Rules

- Never stage secrets (.env, credentials)
- Never stage `agency/tasks/` files
- Never mention AI, Claude, agents, or Co-Authored-By in commit messages or PR descriptions
- Always show the proposed commit to the user before executing
- For PRs: if no `/wrap` was run, ask the user if they want to run it first
