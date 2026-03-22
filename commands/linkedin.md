---
description: Repurpose a community post for LinkedIn. Same voice, adapted structure. Community content always comes first - LinkedIn gets the adapted version.
argument-hint: [paste the community post or describe which post to adapt]
---

# LinkedIn Repurpose

Input: $ARGUMENTS

You are adapting a community post for LinkedIn. The rule: same Vitaly, different stage. LinkedIn readers haven't opted into a premium community. They're scrolling and don't know him yet. Context that's obvious in the community needs to be earned on LinkedIn.

## Step 1: Get the Source Post

If $ARGUMENTS contains the post content, use it directly.

If $ARGUMENTS is a description or "last post" - ask:
> "Paste the community post you want to adapt, or describe the topic and I'll draft based on that."

## Step 2: Check If It Translates

Before adapting, consider: does this post work for LinkedIn?

Posts that don't translate well:
- Highly specific tool debugging (too niche for LinkedIn's broader audience)
- Posts that only make sense with community context
- Posts that reference specific members or internal conversations

If it doesn't translate, say so:
> "This post is too inside-the-community to work on LinkedIn. The [specific reason] means it would lose the general LinkedIn audience. Want to pick a different post?"

## Step 3: Adapt (use content-linkedin-agent agent)

Run the **content-linkedin-agent** agent on the source post. Let it produce the LinkedIn adaptation.

## Step 4: Voice Check (use content-voice-check agent)

Run the **content-voice-check** agent on the LinkedIn draft. Apply any fixes.

## Step 5: Present

```
LINKEDIN ADAPTATION
===================
Source: [first line of community post]

---
[Full LinkedIn post]
---

What changed from the community version:
- [Key difference 1]
- [Key difference 2]
```

Ask:
> "Does this feel like you on LinkedIn? Anything that needs adjusting?"
