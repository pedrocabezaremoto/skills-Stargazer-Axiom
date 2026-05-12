# Tests Quality Checklist — Issue Creation v2

## What This Evaluates

The F2P (Fail-to-Pass) and P2P (Pass-to-Pass) tests. Tests must be **behavioral** — they verify the code produces correct behaviors, NOT that it follows a specific implementation.

## Task Category — Bug Injection Detection

Before evaluating F2P/P2P correctness, check `patches/basetoinstance.patch`:

- **If `basetoinstance.patch` is empty (no diffs)**: this is **not a bug injection task**. The pre-patch baseline is the raw base repo (what `base.Dockerfile` clones).
- **If `basetoinstance.patch` contains diffs**: this is a **bug injection task**. The `basetoinstance.patch` intentionally introduces the broken/incomplete state that the model must fix. The pre-patch baseline is **base repo + basetoinstance.patch applied**. All F2P/P2P "before patch" reasoning must be evaluated against this combined state, not against the raw repo. The `gold_patch.patch` is the fix on top of that broken state.

## Input Files

- `patches/test_patch.patch` — The tests to evaluate
- `patches/basetoinstance.patch` — Determines task category (see above)
- `issue_message.txt` — What's being asked
- `patches/gold_patch.patch` — The solution

---

## Checklist

### Structure

- [ ] **F2P Naming**: F2P tests use `*.f2p.test.{ext}` naming
- [ ] **P2P Naming**: P2P tests use `*.p2p.test.{ext}` naming
- [ ] **Has Both Types**: At least one F2P and one P2P test exist

### Behavioral (Most Important)

- [ ] **Tests Behavior, Not Implementation**: Tests verify WHAT the code does, not HOW
- [ ] **No Internal Checks**: Tests don't check private variables, internal methods, or specific data structures
- [ ] **Alternative Solutions Pass**: A different valid implementation would pass these tests
- [ ] **No Algorithm Enforcement**: Tests don't require a specific algorithm or approach

### F2P Correctness

- [ ] **Tests New Functionality**: F2P tests verify the specific changes/features added
- [ ] **Fails Before Patch**: F2P tests fail in the pre-patch baseline (see Task Category above — for bug injection tasks this means base + basetoinstance.patch, before gold patch)
- [ ] **Targets Prompt Asks**: F2P tests map directly to prompt requirements

### P2P Correctness

- [ ] **Tests Existing Functionality**: P2P tests verify no regression in existing features
- [ ] **Covers Related Areas**: P2P tests cover functionality adjacent to the changes
- [ ] **Passes Before Patch**: P2P tests pass in the pre-patch baseline (see Task Category above — for bug injection tasks this means base + basetoinstance.patch, before gold patch)
- [ ] **No New Dependencies**: P2P tests do not depend on new behavior introduced by gold patch

### Prompt Coverage (Basic — see `8_Coverage_Eval.md` for deep traceability)

- [ ] **No Completely Uncovered Requirements**: No major prompt requirement has zero F2P tests (a quick scan — full matrix in Coverage Eval)
- [ ] **No Orphan Tests**: Every F2P and P2P test maps back to a specific prompt requirement or a clearly related existing behavior

### Behavioral Depth

- [ ] **Tests Exercise Real Code Paths**: Tests import and invoke the actual modules/components/functions that changed — they do not mock or stub the unit under test itself
- [ ] **Bug Fix Is Verified End-to-End**: For bug-fix tasks, at least one F2P test reproduces the original broken behavior (input that triggered the bug) and asserts the corrected output after the patch
- [ ] **Component Renders / Runs Correctly**: For UI or component tasks, tests render the component (or call the entry point) and assert on observable output (DOM nodes, API responses, return values, stdout) — not on internal state or snapshots alone
- [ ] **State Transitions Are Validated**: If the prompt describes behavior that involves state changes (e.g., toggle, lifecycle, workflow), tests assert both the before and after states through the public interface
- [ ] **No Shallow Smoke Tests**: Tests go beyond "it doesn't crash" — every test asserts a specific, prompt-derived expected outcome rather than merely checking that a function exists or a component mounts without error

### Patch Hygiene

- [ ] **Test Files Only**: `test_patch.patch` only changes test files
- [ ] **No App/Config/Dependency Changes**: Patch does not modify source code, `package.json`, lockfiles, or config files
- [ ] **Clean Apply**: `test_patch.patch` applies cleanly with `git apply --ignore-whitespace`

### Test Integrity

- [ ] **No Hardcoded Answers**: Tests do not embed hardcoded expected values copied verbatim from the gold patch result without exercising logic (e.g., `expect(result).toBe("exact string from solution")`)
- [ ] **Tests Are Executable**: Tests are syntactically valid, import the correct modules, and would actually run in the project's test framework without setup errors
- [ ] **No Skipped Tests**: No test uses a skip mechanism (`it.skip`, `xit`, `xdescribe`, `test.skip`, `describe.skip`, `@pytest.mark.skip`, `unittest.skip`, `pending`, unconditional `XFAIL`, or equivalent) — skipping tests to avoid running real verification is not allowed
- [ ] **Assertions Are Meaningful**: Every test contains at least one assertion that validates observable behavior — no empty test bodies and no tests that only log output without asserting anything

---

## Quick Fail Conditions

Any of these = automatic FAIL:

1. Tests check implementation instead of behavior
2. F2P tests pass in the pre-patch baseline (should fail — see Task Category above)
3. P2P tests fail in the pre-patch baseline (should pass — see Task Category above)
4. Tests use wrong naming convention
5. A valid alternative solution would fail the tests
6. Any test is skipped or disabled (`it.skip`, `xit`, `xdescribe`, `test.skip`, `@pytest.mark.skip`, `pending`, etc.) — tests must run
7. Any test has no real assertions (empty body or log-only — no `expect`/`assert` calls)
8. F2P tests only assert that a function exists or a component mounts without verifying prompt-specified behavior (shallow smoke tests)

---

## Behavioral vs Implementation Tests

| Behavioral (GOOD) | Implementation (BAD) |
|-------------------|---------------------|
| Tests return values | Tests internal method calls |
| Tests observable output | Tests private variables |
| Tests API responses | Tests specific data structures |
| Tests user-visible behavior | Tests function call order |
| Tests error messages | Tests algorithm choice |

**Key Question**: Would a different valid solution pass these tests?
- Yes → Behavioral (GOOD)
- No → Implementation-coupled (BAD)

---

## Verdict Template

```
## TESTS EVAL: [PASS / FAIL]

**Test Counts:** [X] F2P, [Y] P2P

### Checklist Results
- Structure: [X/3 passed]
- Behavioral: [X/4 passed]
- F2P Correctness: [X/3 passed]
- P2P Correctness: [X/4 passed]
- Prompt Coverage (Basic): [X/2 passed]
- Behavioral Depth: [X/5 passed]
- Patch Hygiene: [X/3 passed]
- Test Integrity: [X/4 passed]

### Failed Checks
[List each failed check with brief reason, or "None"]

### Issues Found
| Test | Issue | Severity |
|------|-------|----------|
| [test name] | [Description] | Major/Minor |

### Recommendation
[One sentence: what needs to be fixed, or "Ready for use"]
```

---

## Common Mistakes

| Mistake | Example |
|---------|---------|
| Tests implementation | `expect(mockHelper).toHaveBeenCalled()` |
| Wrong naming | `test.js` instead of `feature.f2p.test.js` |
| F2P passes before patch | Test doesn't actually verify new functionality |
| P2P fails before patch | Test breaks existing functionality |
| Patch has non-test changes | `package.json` or app files modified in `test_patch.patch` |
| Overly specific | Would fail a valid alternative implementation |
| Hardcoded answers | `expect(output).toBe("42")` value copied verbatim from gold patch with no real logic exercised |
| Skipped tests | `it.skip("should handle X", ...)` or `@pytest.mark.skip` used to avoid running real verification |
| Empty assertions | Test body contains only `console.log()` or `print()` with no `expect`/`assert` calls |
| Missing prompt coverage | Prompt asks for 3 behaviors but F2P tests only cover 2 — one requirement has no test |
| Shallow smoke test | `expect(component).toBeDefined()` or `expect(() => fn()).not.toThrow()` without asserting any prompt-specified outcome |
| Mocked unit under test | Test stubs the very function it should be verifying, so real code never runs |
| No bug reproduction | Bug-fix task but no F2P test supplies the input that originally triggered the bug |
| Snapshot-only assertion | Test relies on `toMatchSnapshot()` instead of asserting specific observable behavior from the prompt |
