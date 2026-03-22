---
description: Monthly deep retrospective. Full cycle review of health, strategy, pipeline, mod system, and agent rule set evolution. 60 minutes. Run on the last Monday of each month.
---

# Monthly Retrospective

This is the deep review. Not a standup, not a weekly check - this is where the system itself gets examined and evolved. Budget 60 minutes.

## Area 1: Month in Review (use content-health-monitor agent)

Ask Vitaly for a full month summary:
> "Let's do the monthly retro. Give me the full picture of this month - numbers if you have them, what happened with paid tier, any CTO pipeline moves, how the mods did, what content performed, what fell flat. Take your time."

Run the **content-health-monitor** agent with the full month view. Present the health report.

## Area 2: Strategy Reality Check (use content-validator + content-first-principles agents)

Evaluate the core strategy against results so far:

Run **content-validator** on: "The current community strategy is working as designed. The free tier is building credibility, paid tier is growing, and CTO retainer pipeline is generating leads."

Then run **content-first-principles** on: "What is actually driving any results we've seen? What assumptions from the original strategy have been proven or disproven in the first [X] weeks?"

Present both outputs.

## Area 3: Offer Review (use content-hormozi-check agent)

Evaluate the paid tier offer monthly:
> "Does the $250/month paid tier still feel like a no-brainer to the right member? What evidence do we have from this month?"

Run **content-hormozi-check** on the current paid tier offer and any digital products launched.

## Area 4: Pipeline Deep Dive

Map the full pipeline:
- Every CTO retainer conversation: status, timeline, next move
- Conversion rate: how many hot signals became actual conversations?
- Average time from first signal to first conversation

Ask:
> "Looking at the pipeline this month - where are deals getting stuck? What's the most common reason a warm contact didn't become a real conversation?"

Run **content-validator** on the answer to identify wishful thinking in the pipeline assessment.

## Area 5: Agent Rule Set Evolution

Review and evolve each agent's rule set based on the month's accumulated feedback:

For each rules file, ask:
> "Open `agency/system/voice-rules.md` / `validation-rules.md` / `signals.md`. Are there patterns from this month that should be formalized into permanent rules?"

Add any new patterns to the accumulated sections of the relevant rules files.

## Area 6: System Self-Check

Evaluate the community operating system itself:
> "What's working well in how we're running this? What's creating friction? What agent or workflow is underperforming?"

Run **content-first-principles** on any significant process that "feels right" but hasn't been tested.

## Monthly Summary Output

```
MONTHLY RETROSPECTIVE - [Month Year]
=====================================
Community health: [Improving / Stable / Declining]
Paid tier: [X] / 20 members
CTO pipeline: [X] active conversations, [X] converted
Content: [X] posts, [what performed / what didn't]
Mods: [overall performance summary]

STRATEGY VERDICT: [On track / Needs adjustment / Off track]
[2-3 sentences on why]

TOP WIN THIS MONTH:
[Specific]

TOP MISS THIS MONTH:
[Specific - no sugarcoating]

CHANGES TO MAKE NEXT MONTH:
1. [Specific change]
2. [Specific change]
3. [Specific change - max 3, prioritize ruthlessly]

RULE SET UPDATES MADE:
[List any rules added to agency/system/ files]
```

## After the Retro

Commit all rule set changes to git. The system should be visibly smarter after every monthly retro.
