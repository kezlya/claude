---
description: Draft a community post from a raw idea, client problem, member question, or industry reaction. Runs through content pipeline and voice check before presenting the draft.
argument-hint: [topic, idea, or problem to write about]
---

# Post Draft Pipeline

Input: $ARGUMENTS

You are drafting a community post for Vitaly's Skool community. Before drafting, read `playbook/icp.md` - the audience is defined there. They are revenue-focused entrepreneurs who hit a production ceiling, not beginners or hobbyists. They respond to revenue language and specific pain events, not "best practices" or tool comparisons.

## Step 1: Classify the Input

Identify what type of content this is:
- **Client Problem:** A real problem from a client engagement (will be anonymized)
- **Member Question:** A question from the community or DMs (will use "I've been getting DMs about X" framing)
- **Industry Reaction:** A response to hype, a tool launch, a bad take, or a trend

If the type is unclear from $ARGUMENTS, ask:
> "Is this based on a real client problem, a question you've been seeing, or a reaction to something in the industry?"

## Step 2: Draft the Post (use content-pipeline agent)

Run the **content-pipeline** agent with the input and the content type. Let the agent produce the full draft.

## Step 3: Voice Check (use content-voice-check agent)

Run the **content-voice-check** agent on the draft. If it passes, present to Vitaly. If it needs revision, apply the fixes first.

## Step 4: Present the Draft

Show Vitaly the final draft with:
```
POST DRAFT
==========
Type: [Client Problem / Member Question / Industry Reaction]
Topic: [one line]

---
[Full post]
---

Ready to post as-is, or want changes?
```

## Step 5: Feedback Loop

Ask:
> "Anything feel off - tone, accuracy, anything that doesn't sound like you?"

If feedback is provided:
- Apply the revision immediately
- Note any voice patterns from the feedback for saving to voice rules

To save voice feedback, append to `agency/system/voice-rules.md` under the Accumulated Rules section.

## LinkedIn Flag

After Vitaly approves the post, ask:
> "Worth adapting for LinkedIn too? Run `/linkedin` when you're ready."
