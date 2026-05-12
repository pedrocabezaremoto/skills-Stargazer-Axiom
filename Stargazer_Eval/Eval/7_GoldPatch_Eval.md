# Gold Patch Quality Checklist — Issue Creation v2

## What This Evaluates

The gold solution (`gold_patch.patch`). The patch must fully implement every requirement in the prompt, stay scoped to what was asked, and be free of hygiene issues. This eval is complementary to the Alignment eval — Alignment checks cross-component traceability, while this eval inspects the patch itself for completeness, correctness of scope, and cleanliness.

## Input Files

- `gold_patch.patch` — The gold solution to evaluate
- `issue_message.txt` — The prompt that defines what must be implemented

---

## Checklist

### Completeness

- [ ] **All Requirements Implemented**: Every distinct requirement stated in the prompt has at least one corresponding change in the patch — no requirement is silently skipped
- [ ] **No Partial Implementation**: If the prompt requests a full behavior change (e.g. a new feature, a bug fix, a migration), the patch implements it end-to-end — not just part of it

### Correctness of Scope

- [ ] **No Unrelated File Changes**: Every file modified by the patch has a traceable connection to a prompt requirement — no unrelated files are touched
- [ ] **No Test Files Modified**: The gold patch does not modify test files — test changes belong exclusively in `test_patch.patch`
- [ ] **No Unjustified Dependency Changes**: Dependency files (`package.json`, lockfiles, `requirements.txt`, `Cargo.toml`, etc.) are not modified unless the prompt explicitly requests a dependency change

### Patch Hygiene

- [ ] **No Conflict Markers**: Patch contains no merge conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
- [ ] **No Debugging Artifacts**: Patch does not introduce `console.log`, `print`, `debugger`, or equivalent debug output statements
- [ ] **No Stale TODO/FIXME Comments**: Patch does not introduce new `TODO` or `FIXME` comments that indicate incomplete work
- [ ] **No Commented-Out Code**: Patch does not leave behind commented-out code blocks that were part of the implementation

### Solution Sensibility

- [ ] **Approach Matches Intent**: The solution approach is a natural fit for the problem described — not a workaround that technically satisfies tests while missing the real intent of the prompt
- [ ] **No No-Op Hunks**: Every hunk in the patch changes meaningful logic — no whitespace-only changes, cosmetic renames, or formatting touches unrelated to the request

---

## Quick Fail Conditions

Any of these = automatic FAIL:

1. Any prompt requirement has no corresponding change anywhere in the patch (missing implementation)
2. Patch modifies test files — those must go in `test_patch.patch` only
3. Patch modifies files with no traceable connection to any prompt requirement
4. Patch contains conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`)
5. Patch is empty or has no functional diff hunks

---

## Relationship to Other Evals

| Eval | What it checks |
|------|---------------|
| Alignment (4) | Every prompt requirement is covered by a rubric, a test, AND the gold patch — traceability matrix |
| Gold Patch (7) | The patch itself is complete, scoped, and clean — independent of rubric/test coverage |

A task can fail Alignment (e.g. a rubric is missing for a requirement) while this eval passes (the patch itself is correct). Conversely, the patch can be clean but the rubric may not cover it — that is an Alignment failure, not a Gold Patch failure.

---

## Verdict Template

```
## GOLD PATCH EVAL: [PASS / FAIL]

### Patch Summary
- Files Modified: [list of files changed]
- Prompt Requirements: [R1, R2, ... extracted from issue_message.txt]

### Checklist Results
- Completeness: [X/2 passed]
- Correctness of Scope: [X/3 passed]
- Patch Hygiene: [X/4 passed]
- Solution Sensibility: [X/2 passed]

### Failed Checks
[List each failed check with brief reason, or "None"]

### Issues Found
| File / Hunk | Issue | Severity |
|-------------|-------|----------|
| [file path or hunk reference] | [Description] | Major/Minor |

### Recommendation
[One sentence: what needs to be fixed, or "Ready for use"]
```

---

## Common Mistakes

| Mistake | Example |
|---------|---------|
| Missing requirement | Prompt asks for two behaviors; patch only implements one |
| Test files in gold patch | `gold_patch.patch` includes changes to `*.test.js` or `*.spec.py` |
| Unrelated file changes | Gold patch modifies a README or config file the prompt never mentioned |
| Conflict markers left in | `<<<<<<< HEAD` appears in a patched file |
| Debug code left in | `console.log("debug", result)` introduced by the patch |
| Partial fix | Prompt asks for end-to-end feature; patch only adds backend logic, skips UI wiring |
| Workaround solution | Hardcodes specific test values to pass tests rather than implementing real logic |
| Unnecessary dependency change | `package.json` version bumped when prompt only asked for a code change |
