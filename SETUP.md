# Claude Code Agent Setup Guide

How to set up global and local agent architecture for Claude Code on a new machine or for a new developer.

## Architecture Overview

```
~/.claude/                          # Global (shared across all projects)
├── CLAUDE.md                       # Global rules (no AI attribution, project paths)
├── agents/                         # Agent definitions (HOW to do things)
│   ├── dev-planner.md
│   ├── dev-implementer.md
│   ├── dev-verifier.md
│   ├── dev-reviewer.md
│   ├── dev-documenter.md
│   └── content-*.md                # Content/community agents
├── commands/                       # Slash commands (WHEN to trigger agents)
│   ├── commit.md                   # /commit — stage, commit, push with approval
│   ├── feature.md                  # /feature — full dev workflow
│   ├── fix.md                      # /fix — bug investigation + fix workflow
│   ├── explain.md                  # /explain — research and explain code
│   ├── refactor.md                 # /refactor — retrospective + next steps
│   └── ...                         # Other commands
└── projects/
    └── projects.yaml               # Full catalog of all repos + git origins

~/code/                             # All repositories
├── <group>/                        # Project group (pg, cs, bk, etc.)
│   ├── <repo>/                     # Individual repo
│   │   ├── CLAUDE.md               # Project-specific rules (WHAT to do)
│   │   └── agency/
│   │       └── system/             # Project knowledge docs
│   └── <repo>/
└── <group>/
```

### Separation of Concerns

| Layer | Where | Contains | Synced via |
|-------|-------|----------|------------|
| **Agents** (HOW) | `~/.claude/agents/` | Generic behavior: how to plan, implement, review | This repo |
| **Commands** (WHEN) | `~/.claude/commands/` | Workflows: which agents to spawn and in what order | This repo |
| **Project rules** (WHAT) | `CLAUDE.md` in each repo | Tech stack, conventions, test commands | Git (per repo) |
| **Project knowledge** (DEEP) | `agency/system/` in each repo | Architecture docs, DB schemas, API patterns | Git (per repo) |
| **Task tracking** (WHY) | `agency/tasks/` in each repo | Working documents, investigation notes | Local only (gitignored) |

## Step 1: Clone the Global Config

```bash
cd ~/.claude
git init
git remote add origin https://github.com/kezlya/claude.git
git fetch origin
git checkout main
```

This gives you all global agents, commands, and the project catalog.

## Step 2: Clone Project Repos

Look up the project in `projects/projects.yaml` and clone into `~/code/<group>/<repo>`:

```bash
# Example: clone combatsport-api
mkdir -p ~/code/cs
git clone https://github.com/devteamclub/combatsport-api.git ~/code/cs/combatsport-api
```

Or just tell Claude Code: "Clone the combatsport-api project" — it will read `projects.yaml` and do it.

## Step 3: Verify

Open any project in Claude Code. You should see:
- Global slash commands available (e.g., `/commit`, `/feature`, `/fix`)
- Global agents spawnable by commands (dev-planner, dev-implementer, etc.)
- Project-specific rules loaded from the repo's `CLAUDE.md`

## How It Works

### Global Agents

Agents define HOW to do something, not WHAT. They are generic:

- **dev-planner** — analyzes requirements, investigates bugs, creates task files in `agency/tasks/`
- **dev-implementer** — writes code following the approved plan exactly
- **dev-verifier** — runs `make test`, checks coverage, adds tests if needed
- **dev-reviewer** — code review for quality, security, pattern compliance
- **dev-documenter** — updates docs, generates commit messages, marks tasks done

Agents read project-specific knowledge from `CLAUDE.md` and `agency/system/` at runtime. This means the same agent works across all repos without modification.

### Slash Commands

Commands define workflows — which agents to spawn and in what order:

```
/feature  →  planner → [approval] → implementer → verifier → reviewer → [approval] → documenter
/fix      →  planner → [approval] → implementer → verifier → reviewer → [approval] → documenter
/commit   →  gather context → propose commit → [approval] → stage + commit + push
```

Two approval checkpoints: after planning (before writing code) and after review (before finalizing).

### Project-Level Setup

Each repo needs two things:

#### 1. `CLAUDE.md` (required)

Project-specific rules: tech stack, test commands, conventions. Example:

```markdown
# Project Name

Go + Fiber REST API with PostgreSQL and Firebase Auth.

## Testing
- `make test` — full E2E tests with coverage
- `go test` — unit tests only

## Conventions
- All IDs are int
- No GORM foreign keys
- Handler split: input (validation) + output (response)
```

#### 2. `agency/system/` (recommended for complex projects)

Deep project knowledge that agents reference during work. Common files:

| File | Purpose |
|------|---------|
| `handler-layer.md` | HTTP handler patterns, middleware, routing |
| `service-layer.md` | Business logic patterns, DI rules |
| `repository-layer.md` | Database access patterns, GORM conventions |
| `domain-layer.md` | Data model patterns, BaseDB, enums |
| `testing.md` | Test strategy, coverage rules, test frameworks |
| `auth.md` | Authentication flow, token formats, permissions |
| `database-schema.md` | Tables, relationships, key queries |
| `debugging.md` | Logging queries, common issues, request flows |

You don't need all of these. Start with what the agents need to know that isn't obvious from reading the code.

#### 3. `agency/tasks/` (gitignored)

Working documents created by the planner agent during sessions. These are temporary — the PR is the artifact, not the task file. Add to `.gitignore`:

```
agency/tasks/
```

## Rules

1. **Never duplicate agents locally.** If you need project-specific behavior, put the knowledge in `CLAUDE.md` or `agency/system/`, not in a local agent copy.
2. **Agents say HOW, CLAUDE.md says WHAT.** Agent: "run the project's test command." CLAUDE.md: "test command is `make test`."
3. **One entry point: `make test`.** Every repo should have a `make test` target. The global verifier always calls `make test`.
4. **No AI attribution.** Never add "Generated with Claude Code", "Co-Authored-By", or similar to commits, PRs, or any output.
