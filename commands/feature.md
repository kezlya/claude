---
description: Implement new features using the dev-planner - dev-implementer - dev-verifier - dev-reviewer - dev-documenter workflow
---

# Feature Workflow

**Spawn agents with only the task file path. Never override agent instructions.**

## Workflow

1. **Spawn dev-planner** - pass the feature request
2. **Wait for user approval** of the plan
3. **Spawn dev-implementer** - pass the task file path
4. **Spawn dev-verifier** - pass the task file path
5. **Spawn dev-reviewer** - pass the task file path
6. **Wait for user review**
7. **Spawn dev-documenter** - pass the task file path

If any agent reports a failure or blocker, surface it to the user immediately. Never skip or rationalize.

ARGUMENTS: $ARGUMENTS
