---
name: refactor
description: End-of-session retrospective — while context is full, ask the agent what it would do differently, identify dead code, surface refactoring opportunities, and produce a MoSCoW-prioritized next-steps plan.
version: "1.0"
author: Vitaly
tags: [refactor, retrospective, dead-code, technical-debt, moscow]
---

The context window for this session is nearly full. Do a **single-pass retrospective** and output one concise MoSCoW action table. Do not produce separate sections for dead code, refactoring, and next steps — every finding goes directly into the table as one row.

## Hard Rules

- **Each finding appears exactly once.** Never rephrase or re-list the same issue.
- **No prose paragraphs.** Table rows only, plus one closing sentence.
- **Be specific.** Reference actual file names, function names, or patterns from this session. Generic advice is not useful here.
- If a MoSCoW bucket has nothing real to put in it, omit it entirely rather than padding.

## Output

Produce four sections. Use only the sections that have real findings — omit empty ones entirely.

---

### 🔴 Must
*Blockers or regression risks — address before the next session.*

- **M1** `[type]` — Finding. Why it matters.
- **M2** `[type]` — Finding. Why it matters.

### 🟠 Should
*High value, low risk — schedule immediately after Must items.*

- **S1** `[type]` — Finding. Why it matters.

### 🟡 Could
*Worth doing when bandwidth allows — no urgency.*

- **C1** `[type]` — Finding. Why it matters.

### ⚪ Won't (this cycle)
*Consciously deferred — one-word reason in parentheses.*

- **W1** `[type]` — Finding. (reason)

---

**`[type]`** — one of: `dead-code` · `refactor` · `process` · `tests` · `docs` · `infra` · `agency`

For `agency` items: name the target subfolder in the finding — e.g. `agency/system/`, `agency/tasks/`, `agency/qa/`.
For Go-specific findings: flag unused exported symbols, swallowed errors (`_ =`), missing `context.Context` propagation, hardcoded GCP resource IDs.

---

Close with a single **"Fresh start" sentence** — the one biggest decision you'd make differently if this session began today.