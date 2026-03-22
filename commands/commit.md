---
name: commit
description: Stage, commit, and push changes with approval workflow
---

# Commit Command

Create a single, concise git commit in English and push it to the remote repository.

## Step 1: Gather Context

Run these commands to understand the current state:
- `git status --short --branch`
- `git diff` (unstaged changes)
- `git diff --cached` (staged changes)

## Step 2: Analyze Changes

Based on the diff and branch name, determine:
1. Which files should be included in this commit
2. Whether changes represent a single logical unit

If the diff suggests **multiple unrelated changes** that should be separate commits, stop and ask the user before proceeding.

## Step 3: Propose Commit

Present to the user:
- List of files to stage and why each is relevant
- The proposed commit message

Wait for user approval before proceeding.

## Step 4: Branch Safety

If on `main` or `master`, create a new branch first using:
- `feature/<short-description>`
- `fix/<short-description>`
- `chore/<short-description>`

Rules: lowercase, hyphens only, keep it short.

## Step 5: Execute

After approval:
1. Stage the approved files
2. Create the commit
3. Push to remote

## Commit Message Rules

- Single line, max 72 characters
- Imperative mood (e.g. "Fix auth validation")
- No footers, co-authors, or extra text

## Exclusions

Do not stage:
- Unrelated or noisy changes (lockfile churn, IDE configs)
- Files unrelated to the branch's purpose
- Anything you're uncertain about
