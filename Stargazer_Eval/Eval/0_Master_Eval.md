# Master Evaluation Prompt — Issue Creation v2

## Goal

Run a complete, single-pass review of one task by executing all eval prompts in this folder and consolidating the results into one report.

This prompt is **dynamic**:
- Do not hardcode checklist items.
- Read the eval files and extract their sections/checks directly.
- Use those extracted checks as the source of truth.

---

## Scope

Evaluate one task folder containing:
- `issue_message.txt`
- `rubric.json`
- `patches/gold_patch.patch` (or `gold_patch.patch` directly in the task folder)
- `patches/test_patch.patch`
- `base.Dockerfile`
- `instance.Dockerfile`
- `1_Issue_Type.txt` (if available)
- `model_failure_trace.txt` or equivalent (if available)

Primary target eval files in `Evals/`:
- `1_Prompt_Eval.md`
- `2_Tests_Eval.md`
- `3_Rubrics_Eval.md`
- `4_Alignment_Eval.md`
- `5_Granularity_Eval.md`
- `6_Dockerfile_Eval.md`
- `7_GoldPatch_Eval.md`
- `8_Coverage_Eval.md`

If additional eval files exist, include them only when they follow the same checklist/verdict pattern and are not this master file.

---

## Execution Instructions

### Step 1: Discover Eval Files

1. Read all files in `Evals/` matching `*_Eval.md`.
2. Exclude:
   - `0_Master_Eval.md` (this file)
   - non-eval notes like `improvemts.md`
3. Build the ordered execution list:
   1) Prompt eval
   2) Tests eval
   3) Rubrics eval
   4) Alignment eval
   5) Granularity eval
   6) Dockerfile eval
   7) Gold Patch eval
   8) Coverage eval

### Step 2: Parse Each Eval Dynamically

For each eval file:
1. Extract:
   - `What This Evaluates`
   - `Input Files`
   - `Checklist` sections and all checkbox criteria
   - `Quick Fail Conditions`
   - `Verdict Template` expectations
2. Convert each checklist checkbox into an explicit pass/fail check item.
3. Keep section totals (for example `X/3`, `X/5`) based on the extracted checklist count, not assumptions.

### Step 3: Run Each Eval

For each eval:
1. Read required task files listed in that eval's `Input Files`.
2. Evaluate every checklist criterion with:
   - Status: `PASS` or `FAIL`
   - Evidence: concrete snippet, file path, or patch hunk reference
3. Evaluate quick-fail conditions:
   - If any quick-fail condition triggers, set that component verdict to `FAIL`.
4. Produce a component-level verdict block in the same structure style as the eval template.

### Step 4: Build Consolidated Output

Build a **failures-only** report. The goal is a concise document a reviewer can scan in under a minute.

1. Compute the overall verdict (see rule below).
2. List every component with its verdict in a summary table.
3. For **failed** components only, list each failed check with a one-line reason and evidence.
4. Omit passing components from the detailed section entirely — the summary table is enough.
5. End with a numbered "How to Fix" table: one row per concrete action, with the file(s) to change.

---

## Overall Verdict Rule

Use strict gating:
- If **any** component verdict is `FAIL` -> overall verdict = `FAIL`
- If all components are `PASS` -> overall verdict = `PASS`

---

## Output Format (Single Unified Report)

Use exactly this structure:

```
## MASTER EVAL: [PASS / FAIL]

### Task
- Path: [task folder name]

### Summary
| Component | Verdict |
|-----------|---------|
| Prompt | PASS/FAIL |
| Tests | PASS/FAIL |
| Rubrics | PASS/FAIL |
| Alignment | PASS/FAIL |
| Granularity | PASS/FAIL |
| Dockerfile | PASS/FAIL |
| Gold Patch | PASS/FAIL |
| Coverage | PASS/FAIL |

---

### What's Wrong

(Include one sub-section per FAILED component only. Omit components that passed.)

#### [Component Name] — [short failure headline]
1. [Failed check]: [one-line reason + evidence reference]
2. ...

---

### How to Fix

| # | Action | Files to Change |
|---|--------|-----------------|
| 1 | [concrete fix instruction] | [file path(s)] |
| 2 | ... | ... |
```

When the overall verdict is **PASS**, replace "What's Wrong" and "How to Fix" with a single line:

```
All components passed. Task is review-ready.
```

---

## Important Constraints

- **Conciseness**: Do not repeat passing checks. The summary table already shows them.
- **Failures only**: Detailed sections exist only for failed components.
- **Actionable fixes**: Every failure must map to at least one row in "How to Fix".
- Evaluate behavior and traceability, not personal style preferences.
- Do not invent requirements not present in prompt/tests/rubrics/patches.
- Do not skip checks because of missing files; record missing file as explicit failure with evidence.
- Keep evidence concrete and auditable.
- If an eval file changes in the future, adapt automatically by re-parsing that file's checklist.
