# Test Coverage Checklist — Issue Creation v2

## What This Evaluates

The completeness and traceability of test coverage. Verifies that every requirement in the issue message maps to at least one F2P test, every area at risk of regression has a P2P test, and no tests exist without a clear purpose.

This is a **deep** evaluation: it requires decomposing the prompt into atomic requirements, mapping each one to specific test assertions, and identifying gaps.

## Input Files

- `issue_message.txt` — The prompt to decompose into requirements
- `patches/test_patch.patch` — The tests to trace against requirements
- `patches/gold_patch.patch` — The solution (to identify regression risk areas)
- `patches/basetoinstance.patch` — To understand the pre-patch state
- `rubric.json` — To cross-reference rubric criteria with test coverage

---

## Execution Steps

### Step 1: Decompose Issue into Atomic Requirements

Read `issue_message.txt` and extract every distinct requirement. A requirement is any:
- Feature or behavior that must be added
- Bug or broken state that must be fixed
- Constraint on HOW something should work (e.g., "via props", "default state")
- Visual/UI requirement (e.g., "orange highlight", "grid layout")
- Edge case mentioned explicitly or implied

Number each requirement. Example:
```
R1: When Yearly is selected, Consult card shows $500
R2: When Yearly is selected, Basic card shows $450
R3: Monthly is the default on initial page load
...
```

### Step 2: Decompose Tests into Assertions

Read `test_patch.patch` and extract every test case and its assertions. For each test:
- Name / description
- What it asserts (observable behavior)
- Whether it is F2P or P2P

### Step 3: Build Traceability Matrix

Map each requirement (from Step 1) to the test(s) that verify it:

| Requirement | F2P Test(s) | Assertion(s) | Covered? |
|-------------|-------------|--------------|----------|
| R1 | test_name | expect(...) | YES/NO |

### Step 4: Identify Regression Risk Areas

Read `gold_patch.patch` to identify files and functions modified. For each:
- What existing behavior could break?
- Is there a P2P test guarding it?

| Risk Area | Existing Behavior | P2P Test | Covered? |
|-----------|-------------------|----------|----------|
| file/function | description | test_name or NONE | YES/NO |

### Step 5: Check for Orphan Tests

Verify every test maps back to either:
- A specific prompt requirement (F2P), OR
- A clearly related existing behavior at risk from the changes (P2P)

Tests that verify unrelated functionality or things never mentioned in the prompt are orphans.

### Step 6: Cross-Reference with Rubric

For each rubric criterion (excluding `f2p_success` and `p2p_success`), check whether there is a corresponding test that would validate it. Note: not every rubric criterion needs a dedicated test (some are about code quality, readability, etc.), but correctness criteria should have test backing.

---

## Checklist

### Requirement Extraction

- [ ] **All Explicit Requirements Identified**: Every distinct behavior, feature, or fix stated in the prompt is captured as a numbered requirement
- [ ] **Implicit Requirements Identified**: Default states, preservation of existing behavior, and constraints implied but not explicitly stated are captured
- [ ] **Edge Cases Identified**: Boundary conditions, error states, or interaction between features mentioned or implied in the prompt are captured

### F2P Coverage

- [ ] **Every Requirement Has F2P Test(s)**: Each numbered requirement maps to at least one F2P test assertion — no gaps
- [ ] **Assertions Match Requirements**: The test assertions actually verify the specific behavior described in the requirement (not a proxy or partial check)
- [ ] **Multi-Aspect Requirements Split**: Requirements with multiple aspects (e.g., "shows price AND label") have separate assertions or tests for each aspect
- [ ] **Negative Cases Covered**: Where the prompt implies something should NOT happen (e.g., "doesn't change when..."), there is a test verifying the absence of that behavior

### P2P Coverage

- [ ] **All Modified Files Have Regression Guards**: Every file touched by `gold_patch.patch` has at least one P2P test verifying its pre-existing behavior
- [ ] **Adjacent Functionality Covered**: Features that share state, components, or data flow with the changed code have P2P coverage
- [ ] **No Over-Coverage**: P2P tests stay within the reasonable scope of what could regress — not testing completely unrelated functionality

### Traceability

- [ ] **No Orphan F2P Tests**: Every F2P test traces back to a specific prompt requirement
- [ ] **No Orphan P2P Tests**: Every P2P test traces back to a specific existing behavior at risk
- [ ] **No Duplicate Coverage Without Purpose**: If multiple tests cover the same requirement, each tests a distinct aspect or path

### Rubric Alignment

- [ ] **Correctness Criteria Have Test Backing**: Every rubric criterion with `criteria_category: "correctness"` (excluding f2p/p2p meta-criteria) has at least one test that would detect its violation
- [ ] **No Untestable Correctness Criteria**: If a correctness criterion exists in the rubric but has no test, flag it as a coverage gap

---

## Quick Fail Conditions

Any of these = automatic FAIL:

1. A prompt requirement has ZERO F2P tests covering it (complete gap)
2. A file modified by `gold_patch.patch` has ZERO P2P tests guarding existing behavior
3. More than 25% of F2P tests are orphans (not traceable to any prompt requirement)
4. A correctness rubric criterion has no test that would detect its failure

---

## Verdict Template

```
## COVERAGE EVAL: [PASS / FAIL]

### Requirements Extracted
[Numbered list of all requirements from issue_message.txt]

### Traceability Matrix (F2P)

| # | Requirement | F2P Test(s) | Covered? |
|---|-------------|-------------|----------|
| R1 | [description] | [test name + assertion] | YES/NO |
| R2 | ... | ... | ... |

### Regression Risk Matrix (P2P)

| File/Function Modified | Existing Behavior at Risk | P2P Test | Covered? |
|------------------------|---------------------------|----------|----------|
| [path] | [behavior] | [test name] or NONE | YES/NO |

### Orphan Tests
[List any tests not traceable to requirements or regression risk, or "None"]

### Rubric Cross-Reference
| Rubric Criterion | Has Test Backing? | Test Name |
|------------------|-------------------|-----------|
| [title] | YES/NO | [test or N/A] |

### Checklist Results
- Requirement Extraction: [X/3 passed]
- F2P Coverage: [X/4 passed]
- P2P Coverage: [X/3 passed]
- Traceability: [X/3 passed]
- Rubric Alignment: [X/2 passed]

### Coverage Gaps
| Gap | Severity | What's Missing |
|-----|----------|----------------|
| [R# or area] | Critical/Major/Minor | [description of missing test] |

### Recommendation
[Concrete actions to close coverage gaps, or "Full coverage achieved"]
```

---

## Common Mistakes

| Mistake | Example |
|---------|---------|
| Missing requirement decomposition | Prompt has 8 requirements but only 5 are tested |
| Proxy assertion | Requirement says "shows $500" but test only checks element exists, not its text content |
| No default-state test | Prompt says "Monthly is default" but no test loads page and verifies initial state |
| Missing regression guard | Gold patch modifies 3 files but P2P tests only cover 1 |
| Orphan coverage | P2P test checks login functionality but changes are in pricing page |
| Partial assertion | Requirement has two parts ("price AND label") but test only checks price |
| Rubric-test mismatch | Rubric has 6 correctness criteria but only 3 have corresponding tests |
