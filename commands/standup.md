---
description: Daily 15-minute community standup. Run every morning. Scans yesterday's activity, classifies signals, checks content queue, surfaces any required actions.
---

# Daily Standup

You are running Vitaly's daily community operating check. This takes 15 minutes. Stay tight.

## Step 0: Check Next Steps

Read `next-steps.md` at the repo root. This is the active task list. Start by showing Vitaly:
- Which step he's currently on
- What the next action is
- Any steps completed since last standup (update the file if Vitaly confirms progress)

If steps have been completed, move them from "Active Steps" to "Completed Steps" with the date.

## Step 0.5: Check Pending Applications

Ask Vitaly:
> "Any pending applications on Skool? If yes, let's review them now - read me the answers."

For each application, evaluate against the onboarding protocol (`playbook/onboarding-protocol.md`):
- Q1: Do they have a real system with real pain?
- Q2: Are they in the technical sweet spot?
- Q3: Do they have real dependents and growth ambition?

For approvals, draft a personal diagnostic note based on their Q1 answer. One sentence showing Vitaly understood their problem.

Flag any hot signals for pipeline follow-up.

## Step 1: Gather Yesterday's Activity (ask Vitaly)

Ask Vitaly to describe what happened in the community yesterday. Prompt him with:

> "Quick standup - what happened in the community yesterday? Any posts that stood out, new members, anything that felt like a signal? Even if nothing happened, say that."

Wait for his response before continuing.

## Step 2: Signal Scan

For anything Vitaly described, use the **content-signal-detector** agent to classify each item. Run the agent with the description Vitaly provided.

Triage output:
- Hot signals: immediate action required, flag clearly
- Warm signals: note for public engagement today
- Noise: acknowledge, move on

## Step 3: Content Queue Check

Ask:
> "Anything on your mind you want to post today? A problem you solved, something you noticed, a bad take you want to respond to?"

If yes: note it for the `/post` command later.
If no: suggest one content prompt based on the week's theme or any warm signals from Step 2.

## Step 4: Pipeline Check

Ask:
> "Any warm conversations in your DMs that need a move? Anyone you've been meaning to follow up with?"

If yes: note the action and who it's with.
If no: check if there are any hot signals from Step 2 that need a DM sent today.

## Step 5: Standup Summary

Output a clean daily summary:

```
DAILY STANDUP - [date]
======================
Applications: [count pending] pending, [count approved] approved today
Signals identified: [count hot] hot, [count warm] warm
Action required today:
  - [Specific action 1]
  - [Specific action 2]
Content: [post today / nothing queued]
Pipeline: [DM needed / pipeline move / nothing]
Focus: [Single sentence on the one most important thing to do today]
```

Total time target: 15 minutes. If it's taking longer, something is being over-analyzed.
