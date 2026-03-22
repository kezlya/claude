---
description: Monday weekly community cycle. 30-45 minutes. Covers health report, content plan, live session agenda, Ed sync prep, and pipeline review.
---

# Weekly Community Cycle

Run every Monday. This is the operating review for the week ahead. It covers five areas in order.

## Area 0: Progress Check

Read `next-steps.md` at the repo root. Compare against last week's state:
- Which steps were completed this week? Move them to "Completed Steps" with the date.
- Which step is current? Is it stalled or progressing?
- Are any steps blocked? Surface the blocker.
- Update the "Last updated" timestamp.

Present a quick summary before moving to Area 1.

## Area 1: Community Health (use content-health-monitor agent)

Ask Vitaly:
> "Give me a quick summary of last week - what happened in the community? Any numbers you tracked, who was active, what conversations stood out?"

Then run the **content-health-monitor** agent with what Vitaly described. Present the health report.

## Area 2: Content Plan for the Week

Based on the health report and what Vitaly shared, identify:
- The best topic for this week's flagship post (what problem or insight has the most signal-based demand?)
- Any industry news or hype worth reacting to this week
- One "evergreen" topic as backup if nothing time-sensitive comes up

Ask Vitaly:
> "Which of these feels most relevant for this week? Or is there something completely different on your mind?"

Confirm the weekly post topic.

## Area 3: Live Session Agenda (use content-live-curator agent)

Run the **content-live-curator** agent using the community activity Vitaly described in Area 1.

Present the suggested agenda and the 1-on-1 flags. Ask Vitaly to confirm or adjust.

## Area 4: Ed Sync Prep (use content-mod-tracker agent)

Ask Vitaly:
> "Quick mod update - what did you observe from each mod this week? What they posted, whether they mentioned any scouting, any conversations that came from their work?"

Run the **content-mod-tracker** agent with what Vitaly described. Present the Ed sync agenda.

## Area 5: Pipeline Review

Run through the current pipeline:
> "Let's go through your CTO pipeline. Who are you currently in conversation with? Any new warm contacts from this week? Anyone who went quiet?"

Classify each contact by status: Active conversation / Warm (needs a move) / Cold / Converted.

Surface the one highest-priority pipeline action for the week.

## Weekly Summary Output

```
WEEKLY REVIEW - Week of [date]
==============================
Community health: [Improving / Stable / Declining] - [one sentence]

This week's content:
  Post topic: [topic]
  Live session: [top 2-3 agenda items]

Mod sync with Ed:
  Focus: [top 2 agenda items]
  Performance: [overall assessment]

Pipeline:
  Active conversations: [count]
  Priority action: [specific next move]

Top priority this week:
[Single sentence on the most important thing to accomplish]
```
