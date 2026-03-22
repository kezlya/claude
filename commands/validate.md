---
description: Run any idea, decision, or system change through the full validation pipeline. Checks for wishful thinking, first principles, and Hormozi offer logic. Use before committing to anything significant.
argument-hint: [idea or decision to validate]
---

# Idea Validation Pipeline

Input: $ARGUMENTS

You are running Vitaly's full idea validation pipeline. No idea gets acted on without going through this. Every idea is checked against the ICP (`playbook/icp.md`) - if it doesn't serve the defined customer, it needs strong justification. The output is a GO / REVISIT / NO-GO verdict with specific reasoning.

## Step 1: Wishful Thinking and Reality Check (use content-validator agent)

Run the **content-validator** agent on the input. This produces:
- Wishful thinking score
- Reality check score
- 80/20 leverage score
- Goal proximity score
- Initial verdict

Present the content-validator report.

## Step 2: First Principles Audit (use content-first-principles agent)

Run the **content-first-principles** agent on the same input. This:
- Strips out inherited conventions
- Identifies which assumptions are real constraints vs habits
- Rebuilds the reasoning from fundamentals

Present the first principles audit.

## Step 3: Hormozi Check (if relevant)

If the idea involves: a membership tier, a content product, pricing, an offer to members, or the community's value proposition - run the **content-hormozi-check** agent.

Skip this step for purely operational ideas (process changes, tooling decisions, scheduling).

## Step 4: Synthesis Verdict

After all checks, synthesize a final verdict:

```
VALIDATION COMPLETE
===================
Idea: [restate in one sentence]

Validator:        [GO / REVISIT / NO-GO]
First Principles: [Sound / Over-engineered / Convention-based]
Hormozi Check:    [Compelling / Needs Work / Weak] (if run)

FINAL VERDICT: [GO / REVISIT / NO-GO]

Why:
[2-3 sentences. Name the specific factor that drove the verdict. Don't hedge.]

If REVISIT or NO-GO:
What needs to change before this is a GO:
[Specific, actionable condition]

If GO:
First action to take:
[The single next step]
```

## Feedback Loop

After presenting the synthesis, ask:
> "Does this feel like an accurate read? Did any of the agents miss something important?"

If Vitaly corrects the assessment, note it for saving to the validation rules file.

To save feedback, append to `agency/system/validation-rules.md` under the Accumulated Patterns section.
