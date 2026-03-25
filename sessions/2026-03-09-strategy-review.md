# Session: Strategy Review & Repo Reorganization
**Date:** March 9, 2026

---

## What happened

1. **Reviewed new strategy files** - Vitaly brought two new brainstorming files:
   - `school-strategy-brief.md` - full strategy brief for school.com (new direction)
   - `school-full-income-model.xlsx` - month-by-month income model (community + CTO)

2. **Reality check completed** - Compared original spec (v1, January 2026) vs new strategy (March 2026):
   - Original was wishful thinking: $500/month paid tier with no audience, agency backend with no pipeline, vague revenue targets
   - New strategy is grounded: $250/month x 20 members as a trust engine for Fractional CTO retainers ($4K-$10K/month)
   - New strategy has full financial model, detailed mod program, and documented rejected alternatives
   - Main risk: CTO client conversion timeline may be optimistic (3-4 months assumed, 6-8 months realistic)

3. **Reorganized repository:**
   - Created `strategy/` directory for all strategy documents
   - Moved `spec.md` to `strategy/spec-v1-original.md` (archived original)
   - Moved brainstorming files to `strategy/`
   - Created `strategy/reality-check.md` with full analysis
   - Created `sessions/` directory for conversation tracking
   - Created `agreements/` directory (awaiting mod agreements from Vitaly)

4. **Vitaly mentioned** he will attach moderator agreements next

## Current directory structure
```
/skool
  CLAUDE.md
  interview_transcript.md
  strategy/
    spec-v1-original.md        (archived original spec)
    school-strategy-brief.md   (new strategy - source of truth)
    school-full-income-model.xlsx
    reality-check.md           (strategy comparison)
  agreements/                  (awaiting mod agreements)
  sessions/
    2026-03-09-strategy-review.md  (this file)
  Vitaly/
    Resume_FAANG_Vitaly_Kezlya.txt
    Resume_Startup_Vitaly_Kezlya.txt
```

5. **Converted moderator agreement to Markdown** - Received `school-moderator-agreement.docx`, converted to `agreements/moderator-agreement.md`, deleted the docx. Key changes from original:
   - Added Section 5: Competitor Intelligence & Community Scouting (mods must join 3+ free communities, weekly 20-min competitor review)
   - Added Section 6: Member Acquisition - The Graduation Model (primary acquisition is graduating members from shallow AI communities, NOT paid ads)
   - Added Section 9: Fractional CTO Revenue Exclusion (explicit, standalone section instead of buried reference)
   - Added Section 13: Validation Checklist (mod must verify agreement matches strategy brief before signing)
   - Added explicit MRR numbers to Phase 2 ($5,000 MRR at cap, $500/month per mod)
   - Community organizer referral program included

6. **Updated strategy brief** - Added "Graduation Model" acquisition strategy and community organizer referral program to Section 6

7. **Cross-reference issues found and fixed:**
   - Original docx referenced "Section 6" for CTO exclusion but Section 6 was Marketplace Services - now CTO exclusion is its own Section 9
   - Original docx didn't specify $250/month or 20-member cap explicitly - now included in Section 1
   - Original docx didn't mention $800/month ad budget - now included in Section 1

## Current directory structure
```
/skool
  CLAUDE.md
  interview_transcript.md
  strategy/
    spec-v1-original.md           (archived original spec)
    school-strategy-brief.md      (current source of truth, updated with graduation model)
    school-full-income-model.xlsx
    reality-check.md              (strategy comparison)
  agreements/
    moderator-agreement.md        (converted from docx, expanded)
  sessions/
    2026-03-09-strategy-review.md (this file)
  Vitaly/
    Resume_FAANG_Vitaly_Kezlya.txt
    Resume_Startup_Vitaly_Kezlya.txt
```

## Open items
- [ ] Decide: should we create a new `spec.md` (v2) from the new strategy, or is the strategy brief sufficient?
- [ ] Platform decision: school.com vs Skool vs Circle vs custom
- [ ] Set specific referral bonus amounts for community organizer partnerships
- [ ] Identify first 3-5 target communities for the graduation model
- [ ] Ed needs to review and sign the agreement
