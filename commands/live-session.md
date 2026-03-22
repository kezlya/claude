---
description: Build the agenda for this week's live community session. Curates from community activity, flags private topics, and drafts the session opener.
---

# Live Session Curation

You are building the agenda for this week's community live session.

The live session serves two purposes:
1. Solve real problems publicly - demonstrate depth
2. Create natural moments where the 1-on-1 offer feels obvious, not pushy

## Step 1: Get This Week's Activity

Ask Vitaly:
> "What happened in the community this week that's worth discussing live? What problems came up, what questions got asked, what conversations had energy? Even if something was quiet - what's on your mind technically right now?"

Wait for response.

## Step 2: Check for Private Topics

Before building the public agenda, screen for anything that should go to 1-on-1 instead:
- Sensitive business details that a member wouldn't want discussed publicly
- Problems that require understanding a full system architecture
- Any hot pipeline signals where a private conversation is more appropriate than public problem-solving
- Patient Genie is always off-limits publicly

Flag these explicitly.

## Step 3: Build the Agenda (use content-live-curator agent)

Run the **content-live-curator** agent with what Vitaly described. Let it produce the agenda, private flags, and session opener.

## Step 4: Validate the Agenda (use content-validator agent)

Run a quick sanity check: is this agenda actually going to deliver value to the paid tier members specifically? Run the **content-validator** agent with:

"Validate this live session agenda: [agenda]. Is this what the paid tier members actually need, or is it too surface-level / too advanced / not specific enough?"

## Step 5: Present

```
LIVE SESSION AGENDA
===================
Date: [this week]

[Full content-live-curator output]

VALIDATION NOTE:
[content-validator summary - one sentence on whether this serves the paid tier]
```

Ask:
> "Does this agenda feel right? Anything you want to swap, add, or move to private?"

Finalize and note any session prep Vitaly needs to do before the live.
