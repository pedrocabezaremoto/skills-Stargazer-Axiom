# Migration Tasks: Handling New Dependencies with the `pretest` Hook

## The Problem

Migration tasks often require the model to adopt a **new library** (e.g., replacing Enzyme with React Testing Library). The gold patch rewrites test files *and* adds the new dependency to `package.json`, but after `git apply` the dependency is only declared — it's never installed. Without an `npm install` step the Phase 2 tests fail with `Cannot find module '@testing-library/react'`.

The constraint: **`run_script.sh` must not install or modify dependencies.** Its only job is to apply patches and run tests.

## The Solution: `pretest` npm Script Hook

npm automatically runs a `pretest` script (if defined) before every `npm test` invocation. By injecting a `pretest` entry via the **test patch**, we get dependency installation for free — no changes to `run_script.sh` required.

### How It Works (step by step)

```
┌─────────────────────────────────────────────────────────┐
│ test_patch applied                                      │
│  • Adds test files (.f2p. / .p2p.)                      │
│  • Adds "pretest": "npm install --legacy-peer-deps"     │
│    to package.json scripts                              │
└──────────────────────┬──────────────────────────────────┘
                       │
          ┌────────────▼────────────┐
          │  PHASE 1  (broken)      │
          │  npm test               │
          │   └─ pretest runs       │
          │      npm install ← no   │
          │      new deps yet,      │
          │      nothing changes    │
          │   └─ tests run          │
          │      F2P: FAIL ✓        │
          │      P2P: PASS ✓        │
          └────────────┬────────────┘
                       │
┌──────────────────────▼──────────────────────────────────┐
│ gold_patch applied                                      │
│  • Rewrites test files to use new library               │
│  • Adds new dependency to package.json devDependencies  │
└──────────────────────┬──────────────────────────────────┘
                       │
          ┌────────────▼────────────┐
          │  PHASE 2  (fixed)       │
          │  npm test               │
          │   └─ pretest runs       │
          │      npm install ← sees │
          │      new dep in         │
          │      package.json,      │
          │      installs it        │
          │   └─ tests run          │
          │      F2P: PASS ✓        │
          │      P2P: PASS ✓        │
          └─────────────────────────┘
```

### What Each File Does

| File | Role |
|------|------|
| `test_patch.patch` | Adds test files **and** a `"pretest": "npm install --legacy-peer-deps"` entry to `package.json` scripts |
| `gold_patch.patch` | Rewrites test files to the new library **and** adds the new dependency to `package.json` devDependencies |
| `run_script.sh` | Applies patches and runs `CI=true npm test -- --verbose`. No dependency logic at all |

## Implementation Guide

### 1. Add the `pretest` hunk to `test_patch.patch`

Append a hunk that adds the `pretest` script to `package.json`. Use the project's existing scripts section as context lines:

```diff
diff --git a/package.json b/package.json
--- a/package.json
+++ b/package.json
@@ -11,6 +11,7 @@
   },
   "scripts": {
+    "pretest": "npm install --legacy-peer-deps",
     "start": "react-scripts start",
     "build": "react-scripts build",
     "test": "react-scripts test --env=jsdom",
     "eject": "react-scripts eject"
```

> **Tip:** Adjust the `@@ ... @@` line numbers and context lines to match the actual `package.json` of the project you're working with.

### 2. Add the new dependency hunk to `gold_patch.patch`

Append a hunk that adds the new library to `devDependencies`:

```diff
diff --git a/package.json b/package.json
--- a/package.json
+++ b/package.json
@@ -18,6 +18,7 @@
   },
   "devDependencies": {
+    "@testing-library/react": "^12.1.5",
     "enzyme": "^3.3.0",
     "enzyme-adapter-react-16": "^1.1.1",
     "enzyme-to-json": "^3.3.1"
   }
```

### 3. Use `npm test` in `run_script.sh`

Make sure `run_script.sh` runs tests with `npm test` (not `npx react-scripts test` directly), so the `pretest` hook fires:

```bash
CI=true npm test -- --verbose 2>&1 | tee -a "$RAW_OUTPUT_FILE" || true
```

## Patch Authoring Checklist

- [ ] `test_patch.patch` includes the `pretest` hunk targeting `package.json`
- [ ] `gold_patch.patch` includes the new dependency hunk targeting `package.json`
- [ ] Both patches have correct `@@ ... @@` line counts and enough context lines (at least 3 before and after)
- [ ] Both patches apply cleanly in sequence: `git apply test_patch.patch && git apply gold_patch.patch`
- [ ] `run_script.sh` uses `npm test` (not `npx <runner>` directly)
- [ ] Use `--legacy-peer-deps` in the `pretest` command if the project has older peer dependency trees

## Common Pitfalls

| Issue | Cause | Fix |
|-------|-------|-----|
| `corrupt patch at line N` | Missing trailing context lines in a hunk | Add the required context lines after the last `+`/`-` line |
| Phase 2 tests fail with `Cannot find module` | `gold_patch` doesn't add the dependency to `package.json` | Add a `devDependencies` hunk to `gold_patch.patch` |
| `pretest` never runs | `run_script.sh` calls the test runner directly instead of `npm test` | Switch to `CI=true npm test -- --verbose` |
| Patch won't apply after the other | Line numbers shifted by the first patch | Use enough context lines so `git apply` can fuzzy-match, or adjust offsets |

## Validation

Run the Stargazer validation script in local mode:

```bash
./validation_script.sh --local path/to/task --task-id my-task --verbose
```

Expected output:

```
Phase 1 (broken):  F2P  0/1 pass   P2P  1/1 pass
Phase 2 (fixed):   F2P  1/1 pass   P2P  1/1 pass
```

## When to Use This Trick

Use the `pretest` approach whenever a migration task requires **new npm dependencies** that don't exist in the base image. This applies to any task where:

- The `issue_message.txt` asks the model to switch to a different library
- The gold patch adds entries to `dependencies` or `devDependencies`
- The new library must be installed before tests can import it

The same pattern works for other package managers by using the equivalent lifecycle hook (e.g., `pretest` in npm/yarn).
