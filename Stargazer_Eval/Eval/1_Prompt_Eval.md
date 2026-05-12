# Prompt Quality Checklist — Issue Creation v2

## What This Evaluates

The issue statement (`issue_message.txt`) given to the AI agent. It must read like a natural developer request, be clear and specific enough to act on, lead to a unique ground truth solution, and reference only real codebase identifiers.

## Input Files

- `issue_message.txt` — The prompt to evaluate
- `patches/gold_patch.patch` — The solution (for spot-checking pre-solving risk and verifying references)
- `patches/basetoinstance.patch` — The instance state (for verifying codebase references exist)
- `base.Dockerfile` — To understand what repo/files are available

---

## Checklist

### Natural Language Quality

- [ ] **Developer Voice**: Reads like a real developer describing a problem or requesting a change to a colleague — conversational tone, not a formal spec, ticket template, or academic exercise
- [ ] **No Commands**: No step-by-step instructions ("First... Then... Finally...") — describes the problem/goal, not the procedure
- [ ] **No Pre-Solving**: Doesn't state the root cause or give away the solution approach
- [ ] **No Robotic Language**: Avoids stilted phrasing like "The system shall...", "Implement the following:", or numbered requirement lists that feel machine-generated

### Issue Clarity and Specificity

- [ ] **Clear Problem**: The issue/bug/request is clearly described — a developer reading this knows what's wrong or what's needed
- [ ] **Expected Behavior**: What should happen is implied or stated explicitly enough to verify
- [ ] **Defined Scope**: Clear what needs to change (not too vague, not too specific)
- [ ] **No Conflicts**: No contradictory requirements within the prompt
- [ ] **Reproducible Ask**: Prompt contains enough context to evaluate success without guessing
- [ ] **Concrete Values Where Needed**: When the prompt references specific outcomes (prices, labels, counts, messages), it states the actual expected values — not just "the correct value" or "the right output"

### Unique Ground Truth

- [ ] **Single Correct Interpretation**: The prompt leads to one unambiguous understanding of what success looks like — two reasonable developers would agree on what "done" means
- [ ] **No Ambiguous Scope**: It's clear which parts of the system are in-scope for changes — the prompt doesn't leave room for a model to reasonably do something completely different and still be "correct"
- [ ] **Testable Success Criteria**: Every requirement in the prompt can be objectively verified (pass/fail) — no requirements that depend on subjective judgment

### Codebase Reference Accuracy

- [ ] **References Are Real**: Every file name, function name, class name, component name, variable name, or path mentioned in the prompt actually exists in the codebase (verify against `basetoinstance.patch`, `gold_patch.patch`, or the Dockerfile's cloned repo)
- [ ] **No Hallucinated Identifiers**: No made-up names that look plausible but don't exist in the repo — e.g., referencing `calculateTotal()` when the real function is `calcTotal()`
- [ ] **Correct Spelling of Identifiers**: Names match the exact casing and spelling in the codebase (e.g., if the code has `ITSPricingCard`, the prompt doesn't say `ItsPricingCard` or `PricingCard`)
- [ ] **References Match Current State**: If `basetoinstance.patch` modifies or renames something, the prompt references the post-patch name (the state the model will see), not the pre-patch name

### Difficulty

- [ ] **Natural Difficulty**: Difficulty comes from real complexity, not artificial constraints
- [ ] **Not Trivial**: Prompt is challenging enough to be a meaningful eval

---

## Quick Fail Conditions

Any of these = automatic FAIL:

1. Prompt gives away the solution (pre-solving)
2. Prompt has step-by-step commands
3. Prompt is too vague to determine success
4. Prompt conflicts with itself (contradictory requirements)
5. Prompt references a file, function, or identifier that does not exist in the codebase (hallucinated reference)
6. Prompt has multiple valid interpretations that would lead to fundamentally different implementations (no unique ground truth)

---

## Natural Language Examples

| BAD (robotic / spec-like) | GOOD (developer voice) |
|---------------------------|------------------------|
| "Implement a toggle component that switches between monthly and yearly billing periods." | "The Monthly/Yearly toggle on the pricing page doesn't update prices when I switch to Yearly." |
| "Requirements: 1) Add state management 2) Update props 3) Modify CSS" | "The button highlights correctly, but every card keeps its monthly price and the 'month' text never changes." |
| "The system shall display $500 for the Consult plan when the Yearly option is active." | "When Yearly is selected, the six pricing cards should display the yearly prices: $500 (Consult), $450 (Basic)..." |
| "Create a function named handleToggle in the Pricing component." | "The toggle's visual style (orange highlight on the active button) should match the existing design." |

**Key test**: Could this text plausibly appear in a GitHub issue, Slack message, or PR description from one developer to another? If yes, it passes. If it reads like a test spec or homework assignment, it fails.

---

## Codebase Reference Verification

When the prompt mentions ANY identifier from the codebase, verify it:

1. Extract all file paths, function names, class names, component names, and variables from the prompt
2. For each reference, check that it exists in:
   - The base repo (as described by `base.Dockerfile`)
   - OR the instance state (base + `basetoinstance.patch`)
3. Flag any reference that cannot be verified

| Check | How to Verify |
|-------|---------------|
| File path mentioned | Path exists in the repo structure |
| Function/method name | Defined somewhere in the codebase |
| Component name | Exported/used in the codebase |
| Variable/prop name | Declared in the relevant file |
| Error message text | Actually produced by the code |

**Note**: If the prompt intentionally avoids codebase references (stays at a behavioral/user-facing level), that's fine — this check only applies to references that ARE made.

---

## Verdict Template

```
## PROMPT EVAL: [PASS / FAIL]

**Issue Type:** [Type]

### Codebase References Found in Prompt
- [List all file names, function names, identifiers referenced, or "None"]

### Reference Verification
| Reference | Exists in Codebase? | Evidence |
|-----------|---------------------|----------|
| [name] | YES/NO | [where found or "not found"] |

### Checklist Results
- Natural Language: [X/4 passed]
- Issue Clarity & Specificity: [X/6 passed]
- Unique Ground Truth: [X/3 passed]
- Codebase Reference Accuracy: [X/4 passed]
- Difficulty: [X/2 passed]

### Failed Checks
[List each failed check with brief reason, or "None"]

### Issues Found
| Issue | Severity |
|-------|----------|
| [Description] | Major/Minor |

### Recommendation
[One sentence: what needs to be fixed, or "Ready for use"]
```

---

## Common Mistakes

| Mistake | Example |
|---------|---------|
| Pre-solving | "The bug is in the `calculateTotal` function" |
| Command list | "First add X, then modify Y, finally test Z" |
| Over-specification | "Create `handleClick` in `src/utils.js`" |
| Too vague | "Fix the bug" (which bug?) |
| Contradictory asks | "Keep behavior unchanged" and "replace behavior completely" |
| Hallucinated reference | Prompt says `UserCard.jsx` but the real file is `UserProfileCard.jsx` |
| Wrong casing | Prompt says `pricingCard` but component is actually `ITSPricingCard` |
| Stale reference | `basetoinstance.patch` renames `oldFunc` to `newFunc` but prompt still says `oldFunc` |
| Robotic tone | "The system shall implement..." instead of natural developer language |
| Multiple ground truths | "Improve the styling" — could mean anything, no single correct answer |
| Subjective success | "Make it look better" — cannot be objectively verified |
