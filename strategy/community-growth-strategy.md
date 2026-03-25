# Community Growth Strategy
**Status:** NEEDS WORK
**Date:** March 2026
**Validated:** 2026-03-13 (validator, first-principles, hormozi-check)

---

## Validation Summary

**ICP targeting and business model hierarchy: APPROVED** - take as confirmed foundation.

**Funnel, messaging, partner channel: NEEDS WORK** - specific fixes listed below.

### What Passed Validation
- Primary ICP definition (n8n/Make graduates who hit the ceiling)
- Secondary ICP definition (non-technical founders, 20-150 employees)
- Business model hierarchy (community as trust engine, retainers as primary revenue)
- $250/month pricing and 20-member cap
- "Post-graduate level" positioning
- Audit call as a mechanism (but not as a gate - see fixes)

### What Needs Work Before Execution
1. **Partner channel is untested** - test with 2 organizers before building a program
2. **No social proof** - run 10-15 audit calls, document 3 case studies before launch
3. **Funnel is over-engineered** - drop audit call as a gate, keep it as an offer
4. **Paid tier described in features, not outcomes** - rewrite with dollar-anchored comparisons
5. **Mod scouting scope too wide** - reduce from 9+ communities to 3-4 total

---

## 1. Target Audience (APPROVED)

Full ICP definition is in `playbook/icp.md` (canonical source). Additional context in `strategy/school-strategy-brief.md` Section 2 (Positioning). Summary here for quick reference:

- **Primary ICP:** n8n/Make graduates who hit the production ceiling - founders making money with automations but can't scale them safely
- **Key Signal:** Posts like "my automation crashed and I lost a client" or "how do I make this more reliable?"
- **Secondary ICP:** Non-technical founders (20-150 employees) who need a technical executive to evaluate AI quality

---

## 2. The Funnel (APPROVED 2026-03-13)

### Two Separate Paths

The community funnel and the retainer path are **separate**. The community feeds the retainer path, but they are not the same pipeline.

### Free Community Purpose

The free community is NOT a waiting room for paid. It is a **content engine**, **word of mouth machine**, and **trust builder**. The filter for entry is "do they have real stakes?" - not "will they pay?" Someone who never upgrades but has 10 clients with real problems is valuable because their problems become content, their network becomes word of mouth, and solving their problems publicly builds the reputation that attracts retainer clients.

### Community Funnel

```
Discovery (LinkedIn, partner communities, word of mouth)
    ↓
Landing page / About page (speaks directly to the ceiling)
    ↓
3 qualifying questions (Skool's built-in gate)
    ↓
Manual approval by Vitaly (read answers, decide)
    ↓
Free community
    ↓
Phase 2 (Month 3+): Invitation to paid tier ($250/month)
    - Not a button they click - Vitaly invites them
    - 20-member hard cap
```

### Retainer Path (runs in parallel)

Retainer buyers may come from:
- Paid community members whose business outgrows the group format
- Direct referrals (someone says "talk to Vitaly")
- LinkedIn (founder sees content, DMs, books a call)
- Investor meetings (Vitaly joins as Fractional CTO to handle technical questions)

Retainer is **never sold through the community funnel.** It develops naturally through trust or arrives through referral.

### Qualifying Questions (3 on Skool) - APPROVED 2026-03-13

Validated by: validator (GO, 2/8/7/8), first-principles, hormozi-check. Designed using Mom Test principles - ask about behavior and present reality, don't signal "right" answers.

**Q1:** "Tell me about the automation or AI system you're running right now. What does it do, and what's been the most frustrating thing about it lately?"
- Reveals: production reality, tools, business context, pain - all in one question
- "Running right now" eliminates dreamers. Specificity of answer is the signal.

**Q2:** "When something goes wrong with your setup, what do you usually do first?"
- Reveals: technical level through behavior, not self-assessment
- Too technical ("I SSH into the server") = don't need us. Sweet spot ("I check Make's history, Google the error") = ICP. Too non-technical ("I contact my developer") = can't appreciate the value.

**Q3:** "How many people or clients are depending on your automation right now, and what is your ideal target or goal?"
- Reveals: economic stakes through dependents, current scale, growth ambition
- The number of people depending on the system proxies for money at risk
- "Ideal target" reveals scalability goals and whether they're thinking bigger than their current setup can handle

**Framing:** Skool has no framing space on the question form. The About page must do this work. Before applicants reach the questions, the About page should make clear: this community is for founders who have built something real with AI automation and are hitting the ceiling that tutorials don't address. The About page creates context; the questions qualify within that context.

### Onboarding Protocol - APPROVED 2026-03-13

**Speed matters.** The approval wait is where urgent buyers are lost. Someone who just lost a deal wrote paragraphs in their application - don't let them sit for days.

1. **Review applications daily.** Check Skool pending requests every morning as part of `/standup`.
2. **Respond within 24 hours.** Approve or reject within one day of application.
3. **Personal diagnostic note on approval.** When approving, send a personal message that references their Q1 answer specifically. One sentence that shows you read it and understand their problem. Example: "You mentioned your Make scenarios crash at 100+ orders/day - that's usually a concurrency problem, not a workflow problem. Welcome - post about it and let's dig in." This is the first demonstration of the product they're buying.
4. **Rejection is silence.** Don't approve people who don't match. No need to send a rejection message - just don't approve.
5. **Flag hot signals immediately.** If a Q1 answer describes a problem that screams retainer ($10K+ at stake, enterprise client pressure, scaling emergency), flag it for pipeline follow-up after approval.

### Approval Criteria by Phase

**Phase 1 (first 10 approved members):** Slightly generous. If answers aren't red flags, let them in. Need discussion energy. Use this phase to build pattern data on what good vs bad answers look like.
**Phase 2 (after 10+ members):** Tighten. Only approve people whose Q1 describes a real, specific problem. Signal-based trigger, not calendar-based.

### Acquisition Channels

| Channel | Status | Notes |
|---------|--------|-------|
| Partner community referrals | UNTESTED | Primary channel - needs validation with 2 organizers |
| LinkedIn content | PLANNED | Secondary - targeting founders/operators (note: Vitaly's 4-5K LinkedIn followers are tech people, not ICP) |
| Organic member referrals | PLANNED | Tertiary - grows with community |

### Partner Channel Validation Test

Vitaly personally approaches 2 organizers of 500-5,000 member AI automation communities. If one referral converts within 60 days, the channel is validated. If both fail, redesign the channel before building a program.

---

## 3. Messaging (NEEDS WORK)

### One-Sentence Positioning (APPROVED)

*For AI automation builders who have proven the concept and now need to make it production-ready - the community where Google and Microsoft-scale engineering thinking meets the no-code world.*

### Core Story

- Where they are: "I built it and it works."
- The pain: "But I'm scared to put real clients on it."
- Where this takes them: "Now it's production-ready."

### Messaging Fixes Needed (from Hormozi check)
1. Consolidate six pillars into one sharp lead message - the ICP needs one reason, not six
2. Rewrite paid tier benefits as outcomes with dollar-anchored comparisons (e.g., "one architecture review with a senior AI consultant runs $400-600 - included in your membership")
3. Add "path to retainer" signal in paid tier description (e.g., "Three of our retainer clients started as paid members")
4. Write explicit anti-pitch and put it high on the page
5. Resolve audit call throughput - async written review vs. live call, triage criteria for which Vitaly takes personally

---

## 4. Validation Scores (2026-03-13)

| Check | Result |
|-------|--------|
| Wishful Thinking | 3/10 (low - good) |
| Reality Check | 7/10 |
| 80/20 Leverage | 6/10 |
| Goal Proximity | 8/10 |
| First Principles | Sound foundation, over-engineered execution |
| Hormozi - Dream Outcome | 8/10 |
| Hormozi - Likelihood Proof | 4/10 (weakest - no case studies) |
| Hormozi - Time to First Win | 8/10 |
| Hormozi - Effort Required | 7/10 |
