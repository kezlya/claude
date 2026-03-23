---
description: End-of-session synthesis - rename session, draft PR description from conversation context, surface unfinished work
---

# Wrap - End of Session

You have full conversation context. Use it. The user's own words, reasoning, brainstorming, corrections, and pivots during this session are the richest source of truth - richer than any task file or git diff.

## Step 1: Rename the Session

Generate a descriptive session name (5-8 words) that captures what was actually accomplished. Not the technical diff - the business intent.

**Bad:** "Chat 47" or "Code changes March 20"
**Good:** "Org premium subscriptions with anonymous payments"
**Good:** "Fix bracket generation for 5-player tournaments"

## Step 2: Draft PR Description

**Before writing anything**, check if a PR already exists for the current branch:

```bash
gh pr view --json body,url --jq '{body, url}' 2>/dev/null
```

- **If a PR exists with a description**: Read it carefully. This is the baseline — it may already be well-written from a previous session. Your job is to **update what's missing or outdated** based on THIS session's work, not rewrite from scratch. Show the user what you'd change and why.
- **If no PR exists or the description is empty**: Draft a new one from scratch using the template below.

Synthesize from the CONVERSATION - the user's words, intent, decisions, and reasoning. Do not just read the diff or task file. Write for a non-technical stakeholder or a teammate reviewing the PR async.

```
## Why
[What problem the user was solving - from THEIR words in the session]

## What
[What was achieved - written for someone who wasn't in this session]

## Hypothesis
[Why this approach was chosen - include pivots and reasoning from the discussion]

## Key Decisions
[Decisions made during the session and why - especially non-obvious ones]

## How We Tested
[What was verified - test results, E2E, manual checks]

## Migrations
[Database or infrastructure changes. "None" if none.]

## What's Obsolete
[Code, features, or patterns removed/replaced. "Nothing" if none.]

## Impact
[How this changes things for users or our ICP]
```

Show the draft to the user for approval before creating anything.

## Step 3: Surface Unfinished Work

List anything discussed but deferred:
- Follow-up tasks mentioned
- Ideas brainstormed but not implemented
- Known limitations acknowledged
- "We'll do this later" items

## Step 4: Extract Decisions Worth Remembering

If the session revealed user preferences, project decisions, or corrections that should carry forward, note them. The user can decide whether to save them.

## Rules

- The conversation IS the source of truth, not just the task file
- Write in the user's voice - reflect their reasoning, not your interpretation
- Business language, not code language
- Show everything to the user before executing
- This command synthesizes. `/commit` executes. They work together.
