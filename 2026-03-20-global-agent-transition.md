# Global Agent Architecture — Transition Plan

**Date:** 2026-03-20
**Status:** done (executed 2026-03-22)
**Type:** infrastructure / developer experience

> **Execution notes (2026-03-22):**
> - Phases 1-4 complete: global agents and commands in ~/.claude/
> - Agent naming: `dev-` prefix for dev agents, `content-` prefix for content agents
> - Local agents deleted from: mby, bk/breakkonnect-api, cs/combatsport-api, kezlya/skool, kezlya/linkedin
> - Skool rules moved to agency/system/
> - /do command removed (obsolete)
> - /simplify not created (refactor command covers it)
> - Deferred: Makefile creation for repos without make test, "For Agents" CLAUDE.md sections, cross-machine sync

---

## Problem Statement

We have ~10 repositories with nearly identical agent and command definitions duplicated in each repo's `.claude/` directory. When an agent is improved in one repo, the others stay stale. Working across 3 machines makes manual sync impossible. The current architecture conflates HOW to do something (agent behavior) with WHAT to do (project-specific knowledge).

---

## Target Architecture

### Separation of Concerns

| What | Where | Who maintains | Synced how |
|------|-------|---------------|------------|
| **Agent definitions** (HOW) | `~/.claude/agents/` | Developer (global) | Dotfiles repo |
| **Command definitions** (WHEN) | `~/.claude/commands/` | Developer (global) | Dotfiles repo |
| **Project knowledge** (WHAT) | `CLAUDE.md` + `agency/system/` in each repo | Team (per repo) | Git |
| **Task tracking** (WHY) | `agency/tasks/` in each repo, gitignored | Developer (local) | Not committed |

### Key Principles

1. **Agents say HOW, CLAUDE.md says WHAT.** Agent: "run the project's test command." CLAUDE.md: "test command is `make test`."
2. **Commands are user-triggered, agents are LLM-triggered.** User types `/refactor` when they want. Claude spawns `verifier` during a workflow.
3. **One entry point per concern.** Every project must have `make test` as the single entry point for all testing. The global verifier always calls `make test` — nothing else.
4. **Tasks are local, PRs are the artifact.** Task files in `agency/tasks/` are working documents that never get committed. When work is done, the global `/commit` command reads the task and generates a business-focused PR description.

---

## Phase 1: Establish Conventions in Each Repo

### 1.1 — Makefile: `make test` as universal entry point

Every repository MUST have a `make test` target that handles the full verification pipeline. The global verifier agent will always call `make test` — if it doesn't exist, the agent proposes creating it.

The Makefile is the repo's local knowledge of how to test itself:

```makefile
# Example for a Go API project
.PHONY: test
test: lint test-unit test-integration

.PHONY: lint
lint:
	gofmt -l . && golangci-lint run ./...

.PHONY: test-unit
test-unit:
	go test ./...

.PHONY: test-integration
test-integration:
	# Start server, run E2E tests, stop server
	./scripts/test-integration.sh
```

```makefile
# Example for a Node.js project
.PHONY: test
test: lint test-unit test-e2e

.PHONY: lint
lint:
	npm run lint

.PHONY: test-unit
test-unit:
	npm test

.PHONY: test-e2e
test-e2e:
	npm run test:e2e
```

**Rules for `make test`:**
- MUST run format checks (gofmt, prettier, etc.)
- MUST run linting
- MUST run unit tests
- MUST run integration/E2E tests against a live local server
- MUST exit non-zero if ANY step fails
- SHOULD output a coverage summary at the end
- The global verifier never needs to know the details — it just runs `make test`

### 1.2 — CLAUDE.md: "For Agents" section

Each repo's CLAUDE.md needs a section that tells global agents what they need to know. This replaces the repo-specific content currently baked into agent definitions.

```markdown
## For Agents

### Build & Verify
- **Format:** `gofmt -w .`
- **Build:** `go build ./...`
- **Lint:** `make lint`
- **All tests:** `make test` (runs lint + unit + integration)
- **Start server:** `make start` (loads .env, port 8080)

### Key Rules
- See `agency/system/` for detailed architecture documentation
- [list 3-5 critical rules agents must follow]
```

This section is concise — it links to `agency/system/` for details instead of inlining everything. Agents read it automatically when spawned.

### 1.3 — Tasks: gitignored, local-only

Add to each repo's `.gitignore`:

```
agency/tasks/
```

Task files are working documents. They track context during implementation but never pollute the repo. The business-relevant information moves into the PR description when the work is committed.

**Task file format stays the same:**

```markdown
# Task: Brief Description

**Date:** 2026-03-20
**Status:** planning | implementing | testing | done

## Why
[Business reason for this change]

## What
[What we're trying to achieve]

## Hypothesis
[Why we think this approach will work]

## Changes
[Technical implementation plan]

## Test Strategy
[How we verified it works]

## Migration Notes
[Any database or infrastructure changes]
```

---

## Phase 2: Create Global Agents

Move to `~/.claude/agents/`. Each agent is project-agnostic — it reads CLAUDE.md for project specifics.

### 2.1 — planner.md

```markdown
---
name: planner
description: Analyzes requirements, investigates issues, creates implementation plans
model: sonnet
tools:
  - Read
  - Grep
  - Glob
  - Bash
  - AskUserQuestion
  - mcp__postgres-dev__execute_sql
  - mcp__postgres-dev__search_objects
  - mcp__postgres-prod-readonly__execute_sql
  - mcp__postgres-prod-readonly__search_objects
---

# Planner Agent

You analyze requirements and create implementation plans. You investigate the codebase, query databases, and produce a task file that the implementer will follow exactly.

## Process

1. Read CLAUDE.md to understand this project's architecture, patterns, and constraints
2. Read any referenced documentation in `agency/system/` if it exists
3. Investigate the codebase to understand current implementation
4. Query the database if needed (read-only) to understand data state
5. Create a task file in `agency/tasks/YYYY-MM-DD-brief-description.md`
6. Use AskUserQuestion to clarify ambiguities — do not guess

## Task File Format

Include these sections:
- **Why** — business reason for this change
- **What** — what we're trying to achieve
- **Hypothesis** — why we think this approach will work
- **Changes** — specific files and modifications needed
- **Test Strategy** — how to verify it works
- **Migration Notes** — any database or infrastructure changes

## Rules

- Investigate before proposing — read existing code first
- Plans must be specific enough that the implementer can follow without guessing
- Flag risks and tradeoffs explicitly
- Never propose changes to code you haven't read
```

### 2.2 — implementer.md

```markdown
---
name: implementer
description: Writes code following approved plans
model: opus
tools:
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - Bash
---

# Implementer Agent

You implement code changes following an approved task file exactly. No extra features, no opportunistic refactoring.

## Process

1. Read CLAUDE.md to understand this project's conventions, build commands, and architecture
2. Read any referenced documentation (e.g., `agency/system/`) for patterns to follow
3. Read the task file you were given
4. Implement each step in the plan exactly as specified
5. After all changes, run the project's format + build + lint commands (specified in CLAUDE.md)
6. Update the task file status to `implementing` and note progress

## Rules

- Follow the plan exactly — no extra features, no refactoring outside scope
- Read existing code before modifying it
- Run format, build, and lint commands after changes (check CLAUDE.md for the specific commands)
- If the plan is ambiguous, stop and report — do not guess
- Never commit code — only implement
```

### 2.3 — verifier.md

```markdown
---
name: verifier
description: Runs the full verification pipeline for the project
model: sonnet
tools:
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - Bash
---

# Verifier Agent

You verify implementations by running the project's full test and quality pipeline.

## Process

1. Read the task file you were given
2. Read CLAUDE.md to learn this project's test commands
3. Run `make test`
   - This is the universal entry point — every project defines its full pipeline here
   - If `make test` does not exist, STOP and report this as a blocker. Propose creating it.
4. If `make test` fails at ANY step, report the EXACT failure. Do not skip, rationalize, or work around it.
5. If additional test files are needed (e.g., for new endpoints), write them
6. Document all results in the task file

## What `make test` should cover (for reference, not for you to run individually)

- Format checking
- Linting
- Unit tests
- Integration / E2E tests against a live local server
- Coverage reporting

You do NOT run these individually. You run `make test` and it handles everything. If it doesn't, that's a problem to report.

## Critical Rules

- **Always run `make test`.** This is non-negotiable.
- **Never skip integration tests.** If the server won't start, that IS the finding — report it.
- **Never rationalize failures.** "Pre-existing issue" is not an excuse to proceed. Report it.
- **If `make test` doesn't exist,** report it as a blocker and propose a Makefile target.
```

### 2.4 — reviewer.md

```markdown
---
name: reviewer
description: Reviews code for quality, security, and pattern compliance
model: opus
tools:
  - Read
  - Grep
  - Glob
---

# Reviewer Agent

You perform code review focusing on quality, security, and compliance with the project's documented patterns.

## Process

1. Read the task file you were given
2. Read CLAUDE.md to understand this project's architecture rules and conventions
3. Read any referenced architecture docs (e.g., `agency/system/`)
4. Confirm the verifier ran `make test` successfully. If not — REJECT. Send back to verifier.
5. Review every modified file against the project's documented patterns
6. Check for security issues, error handling, and architectural compliance
7. Document findings using the verdict format below

## Review Checklist

- [ ] All errors handled (no swallowed errors)
- [ ] No security vulnerabilities (injection, auth bypass, etc.)
- [ ] Follows project's documented architecture patterns
- [ ] No dead code or unnecessary changes
- [ ] New endpoints have corresponding tests
- [ ] Format and lint pass (verified by `make test`)

## Verdict Format

```
### Critical (Must Fix)
[Issues that block approval]

### Warning (Should Fix)
[Important issues to address]

### Suggestion (Consider)
[Optional improvements]

**Verdict:** APPROVED | NEEDS CHANGES | BLOCKED
```

## Rules

- Review ALL modified files — don't skip any
- Reference specific file paths and line numbers
- Provide actionable feedback — explain both the issue and the fix
- Never approve if there are critical issues
```

### 2.5 — documenter.md

```markdown
---
name: documenter
description: Updates documentation and finalizes tasks
model: sonnet
tools:
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - Bash
---

# Documenter Agent

You update project documentation and finalize completed tasks.

## Process

1. Read the task file you were given
2. Read CLAUDE.md to understand the project's documentation structure
3. Update any architecture docs that need to reflect the changes made
4. Mark the task as `done`
5. Generate a commit message

## Rules

- Only update docs that are directly affected by the implementation
- Keep documentation concise — don't add prose that restates the code
- Follow the project's existing documentation style
```

---

## Phase 3: Create/Update Global Commands

Move to `~/.claude/commands/`. These are user-triggered workflows.

### 3.1 — feature.md (updated)

```markdown
---
description: Implement new features using the planner → implementer → verifier → reviewer → documenter workflow
---

# Feature Workflow

**Spawn agents with only the task file path. Never override agent instructions.**

## Workflow

1. **Spawn planner** — pass the feature request
2. **Wait for user approval** of the plan
3. **Spawn implementer** — pass the task file path
4. **Spawn verifier** — pass the task file path
5. **Spawn reviewer** — pass the task file path
6. **Wait for user review**
7. **Spawn documenter** — pass the task file path

If any agent reports a failure or blocker, surface it to the user immediately. Never skip or rationalize.

ARGUMENTS: $ARGUMENTS
```

### 3.2 — fix.md (updated)

```markdown
---
description: Investigate and fix bugs using the planner → implementer → verifier → reviewer → documenter workflow
---

# Fix Workflow

**Spawn agents with only the task file path. Never override agent instructions.**

## Workflow

1. **Spawn planner** — pass the bug report / issue description. Planner investigates root cause and creates a task file.
2. **Wait for user approval** of the fix plan
3. **Spawn implementer** — pass the task file path
4. **Spawn verifier** — pass the task file path
5. **Spawn reviewer** — pass the task file path
6. **Wait for user review**
7. **Spawn documenter** — pass the task file path

If any agent reports a failure or blocker, surface it to the user immediately.

ARGUMENTS: $ARGUMENTS
```

### 3.3 — wrap.md (new — end-of-session synthesis)

```markdown
---
description: End-of-session synthesis — rename session, draft PR description from conversation context, surface unfinished work
---

# Wrap — End of Session

You have full conversation context. Use it. The user's own words, reasoning, brainstorming, corrections, and pivots during this session are the richest source of truth — richer than any task file or git diff.

## Step 1: Rename the Session

Generate a descriptive session name (5-8 words) that captures what was actually accomplished. Not the technical diff — the business intent.

**Bad:** "Chat 47" or "Code changes March 20"
**Good:** "Org premium subscriptions with anonymous payments"
**Good:** "Fix bracket generation for 5-player tournaments"

## Step 2: Draft PR Description

Synthesize from the CONVERSATION — the user's words, intent, decisions, and reasoning. Do not just read the diff or task file. Write for a non-technical stakeholder or a teammate reviewing the PR async.

```
## Why
[What problem the user was solving — from THEIR words in the session]

## What
[What was achieved — written for someone who wasn't in this session]

## Hypothesis
[Why this approach was chosen — include pivots and reasoning from the discussion]

## Key Decisions
[Decisions made during the session and why — especially non-obvious ones]

## How We Tested
[What was verified — test results, E2E, manual checks]

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
- Write in the user's voice — reflect their reasoning, not your interpretation
- Business language, not code language
- Show everything to the user before executing
- This command synthesizes. `/commit` executes. They work together.
```

### 3.4 — commit.md (updated — lean, mechanical)

```markdown
---
description: Stage, commit, and push changes with approval workflow
---

# Commit Command

## Step 1: Gather Context

- `git status --short --branch`
- `git diff` and `git diff --cached`
- `git log --oneline -5`

## Step 2: Determine Scope

**If on main/master with a small change:** Direct commit — single-line message, push.
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
- Always show the proposed commit to the user before executing
- For PRs: if no `/wrap` was run, ask the user if they want to run it first
```

---

## Phase 4: Clean Up Per-Repo Agent Definitions

For each repository:

1. **Verify global agents work** — run `/feature` or `/fix` on a small task and confirm agents read CLAUDE.md correctly
2. **Delete `.claude/agents/`** from the repo — global agents take over
3. **Delete `.claude/commands/` duplicates** — keep only repo-specific commands if any exist (most won't)
4. **Add `agency/tasks/` to `.gitignore`**
5. **Ensure CLAUDE.md has the "For Agents" section** with build/test/lint commands

### Transition Checklist (per repo)

```
- [ ] `make test` exists and runs full pipeline (format + lint + unit + E2E)
- [ ] CLAUDE.md has "For Agents" section with build/test/lint commands
- [ ] `agency/tasks/` added to .gitignore
- [ ] `.claude/agents/` deleted (global agents take over)
- [ ] `.claude/commands/` cleaned (only truly repo-specific commands remain, if any)
- [ ] Tested: spawned verifier, confirmed it runs `make test` successfully
- [ ] Tested: ran `/commit` on a change, confirmed PR description generated correctly
```

---

## Phase 5: Sync Across Machines

### Recommended: Dotfiles Repo

```
dotfiles/
├── .claude/
│   ├── agents/
│   │   ├── planner.md
│   │   ├── implementer.md
│   │   ├── verifier.md
│   │   ├── reviewer.md
│   │   └── documenter.md
│   ├── commands/
│   │   ├── commit.md
│   │   ├── wrap.md
│   │   ├── feature.md
│   │   ├── fix.md
│   │   ├── explain.md
│   │   ├── refactor.md
│   │   ├── diagram.md
│   │   └── do.md
│   └── CLAUDE.md  (global user preferences)
```

**Setup on each machine:**
```bash
git clone <dotfiles-repo> ~/dotfiles
ln -sf ~/dotfiles/.claude ~/.claude
```

**Updating agents:**
```bash
cd ~/dotfiles
# edit agents/commands
git add . && git commit -m "improve verifier agent" && git push
```

**On other machines:**
```bash
cd ~/dotfiles && git pull
```

---

## Pitfalls to Avoid

### 1. Don't put project-specific commands in global agents
**Bad:** Agent says "run `gofmt -w .` then `go build ./...`"
**Good:** Agent says "run format and build commands from CLAUDE.md"
**Best:** Agent says "run `make test`"

### 2. Don't make agents too vague
**Bad:** "Do whatever the project needs"
**Good:** "Run `make test`. If it doesn't exist, report as blocker and propose creating it."

### 3. Don't forget the CLAUDE.md "For Agents" section
Global agents are only as good as the project context they read. If CLAUDE.md doesn't say how to run tests, the agent will guess wrong.

### 4. Don't leave stale per-repo agents
If you accidentally leave a `.claude/agents/verifier.md` in a repo, it silently overrides your improved global verifier. Clean up thoroughly during Phase 4.

### 5. Don't commit task files
Tasks are working documents. The business-relevant content moves into the PR description. The task file itself is disposable once the PR is created.

### 6. Don't duplicate agent logic in commands
Commands define WORKFLOW ORDER and APPROVAL GATES. Agents define HOW to do each step. Never restate agent instructions in a command.

### 7. Don't skip testing the transition
Before deleting per-repo agents, run a full `/feature` cycle with global agents to confirm they read CLAUDE.md correctly and `make test` works.

---

## Success Criteria

After transition is complete:

1. **Zero agent definitions in any repo** — `~/.claude/agents/` is the single source of truth
2. **Improving one agent improves all repos** — edit once in dotfiles, pull on other machines
3. **Every repo has `make test`** — one command, full pipeline, no agent needs to know the details
4. **Tasks are local, PRs are the artifact** — no task files polluting git history
5. **PRs have business-focused descriptions** — synthesized from the conversation, not code diffs
6. **`/wrap` → `/commit` is the end-of-session flow** — synthesize intent, then execute mechanically
7. **Works identically on all 3 machines** — dotfiles repo keeps everything in sync
