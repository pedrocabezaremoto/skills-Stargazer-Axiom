# Rubrics Quality Checklist — Issue Creation v2

## What This Evaluates

The rubric criteria used to grade AI agent solutions. Rubrics must be self-contained, atomic, unambiguous, and properly structured.

## Input Files

- `rubric.json` — The rubrics to evaluate
- `issue_message.txt` — What's being asked
- `patches/gold_patch.patch` — The solution

---

## Checklist

### Structure

- [ ] **Required Fields**: Each criterion has: `id`, `title`, `weight`, `annotations` (where `annotations` contains `criteria_requirement` and `criteria_category`)
- [ ] **Title Format**: Titles use `lowercase_with_underscores` format (`id` is a platform-assigned UUID — do not validate its format)
- [ ] **Weights Sum to 100**: Total of all weights = 100
- [ ] **Has f2p_success**: Criterion with title `f2p_success` exists
- [ ] **Has p2p_success**: Criterion with title `p2p_success` exists
- [ ] **Test Weight >= 20%**: f2p_success + p2p_success weight >= 20% (matched by `title`)
- [ ] **Correctness >= 10%**: Correctness category (`annotations.criteria_category`) has >= 10% total weight
- [ ] **Category Variety**: Criteria include Correctness and at least one additional quality category (via `annotations.criteria_category`)

### Quality (Per-Criterion)

- [ ] **Self-Contained**: Can evaluate without external info (specific values embedded). No relative-reference words ("original", "existing", "current", "default", "matches") appear without the concrete values they refer to stated inline.
- [ ] **Atomic**: Each criterion tests exactly ONE thing
- [ ] **Unambiguous**: No vague words ("properly", "correctly", "good", "appropriate")
- [ ] **Specific**: References specific files, functions, values (not "the file" or "the function")
- [ ] **Consistent Granularity**: Criteria are at similar detail level (no mix of overly broad and overly narrow criteria)

---

## Quick Fail Conditions

Any of these = automatic FAIL:

1. Missing `f2p_success` or `p2p_success` criteria (by `title`)
2. Weights don't sum to 100
3. Correctness category < 10% (via `annotations.criteria_category`)
4. Criteria need external info to evaluate (not self-contained)
5. Major ambiguity in criteria makes objective grading impossible

---

## Self-Contained Examples

These apply to the `annotations.criteria_requirement` field:

| BAD (needs external info) | GOOD (self-contained) |
|---------------------------|----------------------|
| "The correct file is modified" | "The file `src/utils/calc.js` is modified" |
| "Returns the expected value" | "Returns the sum of all item prices" |
| "The bug is fixed" | "Clicking Submit no longer throws an error" |
| "Uses the right function" | "Uses the `calculateTotal()` function" |
| "The original monthly prices are shown" | "The monthly prices are shown: $50 (Consult), $45 (Basic), $52 (Premium), $36 (Stander), $40 (best deal), $90 (Super Premium)" |
| "The layout matches the existing design" | "The card grid uses a 12-column layout with each card spanning 4 columns (3 cards per row on large screens) and a 30px gap" |
| "The default values are preserved" | "The default border-radius remains 8px and the font-size remains 14px" |

## Relative-Reference Words (Require Concrete Values)

These words signal that a criterion is deferring to external context instead of embedding the actual values. When any of these appear, the criterion MUST also state the concrete values/description they refer to — otherwise it is NOT self-contained:

- "original", "existing", "current", "default", "previous"
- "matches", "preserves", "maintains", "remains", "unchanged"
- "same as", "consistent with", "identical to"

**Test**: If you remove all access to the codebase and issue message, can a grader still determine pass/fail from the criterion text alone? If not, it fails self-containment.

**Common pattern**: The issue message uses vague language ("original prices", "existing design") — the rubric must resolve that vagueness by embedding the actual values from the codebase, NOT by copying the vague reference.

## Banned Words (Ambiguous)

These words make criteria subjective — avoid them:
- "properly", "correctly", "appropriately"
- "good", "well", "adequate", "sufficient"
- "important", "relevant", "necessary"
- "reasonable", "appropriate", "suitable"

---

## Verdict Template

```
## RUBRICS EVAL: [PASS / FAIL]

**Total Criteria:** [X]
**Weights:** f2p=[X]% + p2p=[Y]% = [Z]% | Correctness=[W]% (via annotations.criteria_category)

### Checklist Results
- Structure: [X/8 passed]
- Quality: [X/5 passed]

### Failed Checks
[List each failed check with brief reason, or "None"]

### Issues Found
| Criterion Title | Issue | Severity |
|-----------------|-------|----------|
| [title] | [Description] | Major/Minor |

### Recommendation
[One sentence: what needs to be fixed, or "Ready for use"]
```

---

## Common Mistakes

| Mistake | Example |
|---------|---------|
| Not self-contained | "Modifies the correct file" (which file?) |
| Relative-reference without values | "The original monthly prices are shown" (what are they? must list: $50, $45, etc.) |
| Deferred-to-codebase description | "The layout matches the existing design" (must describe the layout concretely) |
| Copying vague issue language | Issue says "original prices" — rubric copies "original prices" instead of resolving to actual values |
| Not atomic | "Function exists AND returns correct value" (two checks) |
| Ambiguous | "Code is properly formatted" |
| Missing mandatory | No criterion with title `f2p_success` |
| Weights wrong | Sum is 95 instead of 100 |
| Vague references | "The button" instead of "the Submit button" |
| Mixed granularity | One criterion is broad while others are very narrow |
| Wrong title format | Title uses spaces or camelCase instead of `lowercase_with_underscores` |
