---
description: Research and explain code, architecture, or features in the codebase
---

# Explain/Research Workflow

**IMPORTANT: You MUST use the Task tool to spawn the planner agent for research. Do NOT do the work yourself.**

## Execution Instructions

1. **Spawn the planner agent** using the Task tool with `subagent_type: "planner"`
   - Pass the user's question/topic in the prompt
   - Ask the planner to research and explain (no task file needed for pure research)

2. **Return the planner's findings** to the user

---

## When to Use

Use this workflow when the user asks:
- "How does X work?"
- "Explain the Y feature"
- "Where is Z implemented?"
- "What happens when...?"

## Workflow Reference

```
USER QUESTION
    ↓
[Task tool] → planner agent → researches & explains
    ↓
RESPONSE TO USER
```

**Note:** No task file needed for pure research. Only create task files for implementation work.

---

**Purpose:** When a user asks "How does X work?", this procedure analyzes the actual code implementation and produces a comprehensive explanation.

## Workflow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    EXPLAIN FEATURE WORKFLOW                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. CLIENT ASKS: "How does [feature] work?"                     │
│     │                                                           │
│     ▼                                                           │
│  2. IDENTIFY SCOPE                                              │
│     │   - Confirm which feature(s) to explain                   │
│     │   - Use AskUserQuestion if unclear                        │
│     │                                                           │
│     ▼                                                           │
│  3. TRACE CODE IMPLEMENTATION (Frontend/Backend Specific)       │
│     │   - Identify entry points (routes, components)            │
│     │   - Follow execution flow through layers/components       │
│     │   - Understand data interactions (API calls, DB queries)  │
│     │   - Identify ALL business logic and validations           │
│     │                                                           │
│     ▼                                                           │
│  4. DOCUMENT IMPLEMENTED BEHAVIOR                               │
│     │   - List all business rules found in code                 │
│     │   - Document all validations and error cases              │
│     │   - Note edge cases that are handled                      │
│     │   - Describe what happens in each scenario                │
│     │                                                           │
│     ▼                                                           │
│  5. IDENTIFY GAPS                                               │
│     │   - What common scenarios are NOT handled?                │
│     │   - What validations are missing?                         │
│     │   - What edge cases could cause problems?                 │
│     │                                                           │
│     ▼                                                           │
│  6. PRIORITIZE REQUIREMENTS                                     │
│     │   - MUST: Critical for correct operation                  │
│     │   - GOOD: Improves reliability or UX                      │
│     │   - MIGHT: Nice to have, low priority                     │
│     │                                                           │
│     ▼                                                           │
│  7. DELIVER DOCUMENT                                            │
│     - Non-technical language                                    │
│     - Ready for client review                                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Phase 1: Identify Scope

### Clarify the Request

Use **AskUserQuestion** if:
- Multiple features could match the description
- Client uses ambiguous terminology
- Scope is unclear (single endpoint vs entire flow)

### Common Feature Areas (Examples - Adapt to Project Context)

| Area           | Keywords / Concepts               | Typical Starting Points (Backend/Frontend) |
|----------------|-----------------------------------|--------------------------------------------|
| User Mgmt      | login, register, profile, permissions | Auth routes/components, user services      |
| Data Handling  | create, read, update, delete      | API endpoints, data models, forms          |
| Notifications  | email, alerts, messages           | Notification services, UI alerts           |
| Workflows      | steps, status, approval           | Process orchestration, state machines      |
| Integrations   | external APIs, webhooks           | API clients, webhook handlers              |

## Phase 2: Trace Implementation

### Investigation Steps

1. **Determine Project Type (Backend, Frontend, etc.)**
   - Identify the primary technology stack (e.g., Go, Vue, React).

2. **If Backend Project (e.g., Go with GORM):**
   - **Find Entry Points:**
     - Search for API routes/endpoints (e.g., in `routes.go` or similar routing files).
     - Note HTTP methods, paths, and middleware.
   - **Trace Handler Layer:**
     - Examine request handling: inputs, initial validations, and immediate responses.
   - **Trace Service Layer:**
     - Analyze core business logic, conditional checks, and side effects (e.g., emails, webhooks).
   - **Trace Repository Layer:**
     - Understand database operations (using GORM queries/models).
     - Identify data constraints and relationships.
   - **Check Database Schema:**
     ```sql
     -- Query database schema (read-only via appropriate tool/client)
     SELECT column_name, data_type, is_nullable
     FROM information_schema.columns
     WHERE table_name = 'your_table_name';
     ```

3. **If Frontend Project (e.g., Vue, React):**
   - **Find Entry Components/Routes:**
     - Identify the main components or routing definitions that handle the feature.
   - **Trace Component Hierarchy:**
     - Understand how data flows between parent and child components.
   - **Analyze State Management:**
     - Identify how data is stored and manipulated (e.g., Vuex, Pinia, Redux, React Context/Hooks).
   - **Examine API Interactions:**
     - Determine what backend API calls are made, their inputs, and expected outputs.
   - **Review User Interface Logic:**
     - How user actions trigger changes in state or API calls.

6. **Look for Edge Cases**
   - Error handling (`if err != nil`)
   - Conditional logic (`if/else`, `switch`)
   - Validation checks
   - Status checks

## Phase 3: Document Findings

### Output Format

The final document should be **client-readable** (non-technical).

```markdown
# [Feature Name]: Business Requirements

## Overview
[2-3 sentences explaining what this feature does]

---

## Current Implementation

### How It Works

1. **[Step 1 Name]**
   - What happens: [plain language description]
   - Who can do this: [user type / permissions]
   - When: [timing, conditions]

2. **[Step 2 Name]**
   - ...

### Validations & Rules

| Rule | What Happens |
|------|--------------|
| [Validation] | [Result if triggered] |

### Edge Cases Handled

| Scenario | Current Behavior |
|----------|------------------|
| [Unlikely scenario] | [What the system does] |

### Error Messages Users May See

| Situation | Message |
|-----------|---------|
| [Condition] | [Error text] |

---

## Gap Analysis

### MUST Have (Critical)

Requirements that should exist but don't. Missing these could cause:
- Data corruption
- Security issues
- Legal/compliance problems
- Core functionality failures

| Gap | Risk | Recommendation |
|-----|------|----------------|
| [Missing requirement] | [What could go wrong] | [Fix] |

### GOOD to Have (Recommended)

Requirements that would significantly improve the feature:
- Better user experience
- Prevent common mistakes
- Reduce support requests

| Gap | Benefit | Recommendation |
|-----|---------|----------------|
| [Missing requirement] | [Why it helps] | [Fix] |

### MIGHT Have (Nice to Have)

Low priority improvements:
- Convenience features
- Edge cases unlikely to occur
- Polish items

| Gap | Benefit | Recommendation |
|-----|---------|----------------|
| [Missing requirement] | [Why it helps] | [Fix] |

---

## Summary

**Currently Implemented:**
- [Bullet list of working features]

**Recommended Additions:**
- [Prioritized list of improvements]
```

## Writing Guidelines

### Language Rules

**DO:**
- Use everyday language
- Describe behavior from user perspective
- Give concrete examples
- Explain "what" and "why"

**DON'T:**
- Use code snippets or technical jargon
- Reference file names or line numbers
- Assume technical knowledge
- Use abbreviations without explanation

### Examples

**Technical (avoid):**
> The handler validates `tierID` is a valid UUID and queries the repository for the associated `TicketTier` record.

**Client-friendly (use):**
> The system checks that you've selected a valid ticket tier. If the tier doesn't exist or has been deleted, you'll see an error message.

---

**Technical (avoid):**
> Returns 400 if `qty > tier.Capacity - tier.Sold`

**Client-friendly (use):**
> You cannot purchase more tickets than are available. If you try to buy 5 tickets but only 3 remain, the purchase will be declined.

## Gap Analysis Guidelines

### MUST Have Criteria

- **Security**: Could this be exploited?
- **Data integrity**: Could data become corrupted?
- **Core function**: Does the feature work without this?
- **Legal/compliance**: Are there regulatory requirements?

### GOOD to Have Criteria

- **User experience**: Would users be confused without this?
- **Error prevention**: Does this prevent common mistakes?
- **Support burden**: Would this reduce support requests?
- **Reliability**: Does this handle realistic scenarios?

### MIGHT Have Criteria

- **Edge cases**: Scenarios unlikely to occur
- **Convenience**: Nice but not necessary
- **Future-proofing**: Might be needed someday
- **Polish**: Makes things slightly better

## Example Output

```markdown
# Ticket Refunds: Business Requirements

## Overview

Event organizers can issue refunds to attendees who purchased tickets.
Refunds return money to the original payment method and update ticket
status so it can't be used for entry.

---

## Current Implementation

### How It Works

1. **Organizer Initiates Refund**
   - Who: Event organizers and admins only
   - Where: Event management dashboard
   - When: Before or after the event

2. **System Validates Request**
   - Checks the ticket exists and belongs to this event
   - Verifies the ticket hasn't already been refunded
   - Confirms the original payment was successful

3. **Stripe Processes Refund**
   - Full refund sent to original payment method
   - Takes 5-10 business days to appear on statement

4. **Ticket Updated**
   - Status changed to "Refunded"
   - Cannot be used for event check-in
   - Attendee receives email confirmation

### Validations & Rules

| Rule | What Happens |
|------|--------------|
| Ticket already refunded | Error: "This ticket has already been refunded" |
| Ticket not found | Error: "Ticket not found" |
| No permission | Error: "You don't have permission to refund this ticket" |

### Edge Cases Handled

| Scenario | Current Behavior |
|----------|------------------|
| Stripe API is down | Refund queued, retry automatically |
| Partial payment (rare) | Full amount refunded |

---

## Gap Analysis

### MUST Have (Critical)

| Gap | Risk | Recommendation |
|-----|------|----------------|
| No refund for free tickets | System errors on free ticket refund | Allow "refund" to just cancel the ticket |
| No refund deadline | Refunds possible years later | Add configurable refund cutoff period |

### GOOD to Have (Recommended)

| Gap | Benefit | Recommendation |
|-----|---------|----------------|
| No partial refunds | Organizers want flexibility | Allow refunding percentage of ticket price |
| No refund reason required | Hard to track why refunds happen | Require reason when processing refund |

### MIGHT Have (Nice to Have)

| Gap | Benefit | Recommendation |
|-----|---------|----------------|
| No bulk refund option | Convenience for cancelled events | Allow refunding all tickets at once |

---

## Summary

**Currently Implemented:**
- Full refund to original payment method
- Email notification to attendee
- Automatic retry if payment provider unavailable

**Recommended Additions:**
- Handle free ticket cancellations (MUST)
- Add refund deadline configuration (MUST)
- Support partial refunds (GOOD)
```

## Checklist

Before delivering the document:

- [ ] All business rules from code are documented
- [ ] All validations are explained in plain language
- [ ] All error scenarios are covered
- [ ] Edge cases are identified and documented
- [ ] Gaps are prioritized (MUST/GOOD/MIGHT)
- [ ] No technical jargon or code references
- [ ] Examples use realistic scenarios
- [ ] Document is readable by non-technical client
