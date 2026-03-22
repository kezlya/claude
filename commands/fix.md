---
description: Investigate and fix bugs using the dev-planner - dev-implementer - dev-verifier - dev-reviewer - dev-documenter workflow
---

# Fix Workflow

**Spawn agents with only the task file path. Never override agent instructions.**

## Workflow

1. **Spawn dev-planner** - pass the bug report / issue description. Planner investigates root cause and creates a task file.
2. **Wait for user approval** of the fix plan
3. **Spawn dev-implementer** - pass the task file path
4. **Spawn dev-verifier** - pass the task file path
5. **Spawn dev-reviewer** - pass the task file path
6. **Wait for user review**
7. **Spawn dev-documenter** - pass the task file path

If any agent reports a failure or blocker, surface it to the user immediately.

ARGUMENTS: $ARGUMENTS
