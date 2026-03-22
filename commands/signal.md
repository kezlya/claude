---
description: Classify a community member or activity as a hot signal (CTO retainer prospect), warm signal, or noise. Get a recommended action.
argument-hint: [describe the member's posts, questions, or activity pattern]
---

# Signal Detection

Input: $ARGUMENTS

You are classifying a community member or activity to determine whether it's worth pipeline follow-up, public engagement, or neither.

## Step 1: Gather Context

If $ARGUMENTS contains enough detail (what they posted, how long they've been active, their business context), proceed.

If more context would change the classification, ask one focused question:
> "Anything else about this member that would help? Their role, company size, how long they've been active, anything they said about urgency or budget?"

## Step 2: Classify (use content-signal-detector agent)

Run the **content-signal-detector** agent on the description. Let it produce the full classification.

## Step 3: Present and Act

Show the classification:

```
SIGNAL CLASSIFICATION
=====================
Member/Activity: [what was described]

CLASSIFICATION: [HOT / WARM / NOISE]

[Full content-signal-detector output]
```

## Step 4: For Hot Signals - Draft the DM

If the classification is HOT, ask:
> "Want me to draft the DM right now?"

If yes, draft a short, direct DM in Vitaly's voice:
- Not a pitch, not a soft sell - a genuine "I noticed X and wanted to connect on it"
- Reference the specific problem they described
- Suggest a short call, not a presentation

Voice check it before presenting.

## Feedback Loop

After the classification:
> "Does this read feel right? Anything about this person I might be misclassifying?"

Corrections get noted for the signals rules file.
