# Alignment Quality Checklist — Issue Creation v2

## What This Evaluates

Cross-component alignment between the issue prompt, tests, gold patch, and rubrics. Every prompt requirement must be implemented, tested, and gradable.

## Input Files

- `issue_message.txt` — The prompt to evaluate
- `patches/test_patch.patch` — F2P and P2P tests
- `patches/gold_patch.patch` — The solution
- `rubric.json` — Grading criteria

---

## Evaluation Workflow

### Step 1: Extract Prompt Requirements

Read `issue_message.txt` and list each distinct requirement as `R1`, `R2`, `R3`, etc.

### Step 2: Build Alignment Matrix

For each requirement `Ri`, verify all of the following:
- [ ] **Rubric Coverage**: At least one rubric criterion evaluates `Ri`
- [ ] **F2P Test Coverage**: At least one F2P test verifies `Ri`
- [ ] **Gold Patch Coverage**: `gold_patch.patch` implements `Ri`

### Step 3: Check for Orphans

Find elements that do not trace back to any prompt requirement:
- [ ] **No Orphan Rubrics**: Every rubric criterion maps to at least one `Ri`
- [ ] **No Orphan F2P Tests**: Every F2P test maps to at least one `Ri`
- [ ] **No Orphan Gold Changes**: Functional gold patch changes map to at least one `Ri`

### Step 4: Rubric-to-Test Consistency

- [ ] **Rubrics Are Testable**: For each criterion whose `title` is not `f2p_success` or `p2p_success`, at least one test would detect pass/fail for that criterion

### Step 5: Gold Patch-to-Rubric Coverage

- [ ] **Gold Changes Are Gradable**: Every functional gold patch change is evaluated by at least one rubric criterion

---

## Quick Fail Conditions

Any of these = automatic FAIL:

1. Any prompt requirement has no rubric coverage
2. Any prompt requirement has no F2P test coverage
3. Any prompt requirement has no gold patch coverage
4. Rubric contains criteria that do not map to the prompt
5. Gold patch implements functional changes not requested in the prompt

---

## Alignment Matrix Template

Use this table in your evaluation:

| Requirement ID | Requirement Summary | Rubric Coverage | F2P Coverage | Gold Patch Coverage | Notes |
|----------------|---------------------|-----------------|--------------|---------------------|-------|
| R1 | [summary] | Yes/No | Yes/No | Yes/No | [details] |
| R2 | [summary] | Yes/No | Yes/No | Yes/No | [details] |

---

## Verdict Template

```
## ALIGNMENT EVAL: [PASS / FAIL]

### Requirement Extraction
- Total Prompt Requirements: [N]

### Checklist Results
- Requirement Coverage: [X/3N passed]  # 3 checks per requirement
- Orphan Checks: [X/3 passed]
- Rubric-to-Test Consistency: [X/1 passed]
- Gold Patch-to-Rubric Coverage: [X/1 passed]

### Alignment Matrix
| Requirement ID | Requirement Summary | Rubric Coverage | F2P Coverage | Gold Patch Coverage | Notes |
|----------------|---------------------|-----------------|--------------|---------------------|-------|
| R1 | [summary] | Yes/No | Yes/No | Yes/No | [details] |

### Orphan Elements
- Orphan Rubrics: [None or list criterion IDs]
- Orphan F2P Tests: [None or list test names]
- Orphan Gold Changes: [None or list files/hunks]

### Gaps Found
[List requirements with missing coverage, or "None"]

### Recommendation
[One sentence: what must be fixed, or "Alignment is complete"]
```

---

## Common Mistakes

| Mistake | Example |
|---------|---------|
| Prompt ask not tested | Prompt requires case-insensitive matching, tests never check case |
| Prompt ask not implemented | Prompt asks for local state, gold patch only updates tests |
| Rubric beyond prompt | Rubric checks file path or API never mentioned in prompt |
| Untestable rubric criterion | Criterion cannot be validated by any test |
| Extra gold behavior | Gold patch introduces additional feature not requested |
