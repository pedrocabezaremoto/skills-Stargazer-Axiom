# Stargazer Axiom — Project Overview

> Comprehensive reference for any AI agent or developer joining this project.
> Read `agent.md` and `Progreso-Actual/progreso.md` before doing any work.

---

## What Is Stargazer Axiom?

Stargazer Axiom is a **data creation project inside the Outlier platform** ($27/hr).
The mission is to build a benchmark database of challenging coding issue requests.
This database is used to evaluate and improve how well AI coding agents implement changes in real codebases.

Each unit of work is called a **task**. A task takes a real GitHub repository, engineers a meaningful coding problem (bug, new feature, migration, performance, or maintenance), verifies that at least one AI model fails to solve it, and produces a complete reproducible evaluation pipeline using Docker, shell scripts, unit tests, patches, and a scoring rubric.

---

## Who Works On This

- **Pedro** — the attempter (task creator) and project manager. All agent instructions are treated as orders from Pedro.
- **Outlier reviewers** — grade each submitted task on a 1–5 scale using a fixed rubric.
- **AI agents** — assist Pedro to build, review, and validate tasks.

---

## Repository Structure

```
skills-Stargazer-Axiom/
│
├── agent.md                        ← Master map: read FIRST every session
├── readme-Stargazer.md             ← Skill: task builder assistant (constructor)
├── readme-reviewer.md              ← Skill: task reviewer assistant
│
├── Progreso-Actual/
│   └── progreso.md                 ← Live task status — update after every step
│
├── Historial/
│   └── historial.md                ← Chronological log of completed work
│
├── Onboarding/
│   ├── IntroCourse-Stargazer.md    ← Intro course notes (full workflow walkthrough)
│   ├── ErroresComunes-Stargazer.md ← Common mistakes catalog (13 error types)
│   └── QualityAssessment.md        ← Assessment exercises: prompts, F2P/P2P, rubrics
│
├── references/                     ← Step-by-step technical guides
│   ├── 01_setup_and_analysis.md
│   ├── 02_problem_creation.md
│   ├── 03_testing.md
│   ├── 04_docker_scripts.md
│   ├── 05_to_08_remaining_steps.md
│   ├── checklist.md                ← Pre-submission review checklist
│   ├── common-errors.md
│   ├── dockerfile-templates.md
│   ├── env-setup.md
│   ├── patch-workflow.md           ← How to generate/verify .patch files
│   ├── rating-guidelines.md
│   ├── rubric-criteria.md
│   ├── rubric-guide.md             ← Rubric design principles + examples
│   ├── reviewer-grading-rubric.md  ← ⚠️ Exact FAIL/PASS table used by reviewers
│   └── script-templates.md
│
├── Stargazer_Eval/                 ← Official Outlier evaluator
│   ├── Eval/                       ← 8 individual eval prompts (0_Master to 8_Coverage)
│   ├── Guide/                      ← HOW_TO_RUN_EVAL.md + migration dependency trick
│   ├── Templates/                  ← Official Base and Instance Dockerfile templates
│   ├── Docs/QC_Spec_Doc.md         ← Official quality specification document
│   └── resources/                  ← Issue Creation v2 Guidelines (official PDF/txt)
│
├── validation_script/              ← Local pre-submission validator
│   ├── HOW_TO_USE.md
│   ├── validation_script.sh        ← Use on Linux/VPS
│   └── validation_script.ps1       ← Use on Windows
│
└── task01/                         ← First assigned task (in progress)
    ├── nuton/                      ← Cloned repo: Nuton Learning App (Angular 19)
    ├── issue_message.txt           ← The problem statement sent to AI models
    └── figma-template/             ← UI reference assets
```

---

## The 8-Step Task Workflow

Every task follows these steps in strict order. Skipping or reordering is not allowed.

| Step | Action | Key Reference |
|------|--------|---------------|
| **1** | Clone the assigned repo, identify stack, testing framework, and problem type | `references/01_setup_and_analysis.md` |
| **2** | Write `issue_message.txt` — the problem the AI must solve. Verify at least one model fails. | `references/02_problem_creation.md` |
| **3** | Prove model failure; export trace. If both models pass, increase complexity. | `references/02_problem_creation.md` |
| **4** | Write the Golden Solution → generate `gold_patch.patch` | `references/patch-workflow.md` |
| **5** | Write F2P and P2P tests → generate `test_patch.patch` | `references/03_testing.md` |
| **6** | Create `base.Dockerfile` and `instance.Dockerfile` | `references/04_docker_scripts.md` |
| **7** | Create `run_script.sh` and `parse_results.sh` | `references/04_docker_scripts.md` |
| **8** | Run `validation_script.sh`, pass all checks, verify rubric, submit | `references/05_to_08_remaining_steps.md` |
| **PRE-SUBMIT** | Read and verify every dimension in `references/reviewer-grading-rubric.md` | — |

---

## Required Output Files (All 8 Must Be Present)

A task is only valid if all of the following files are present and correct:

| File | Description |
|------|-------------|
| `base.Dockerfile` | Builds the clean base environment: clones repo, installs all deps, sets `/app` as workdir |
| `instance.Dockerfile` | Extends base; applies `basetoinstance.patch` to create the broken state (bug injection only) |
| `gold_patch.patch` | The complete, correct solution. Contains **only** app code — never test files |
| `test_patch.patch` | Adds F2P and P2P test files. Contains **only** test files — never app code or configs |
| `basetoinstance.patch` | Transforms clean state → broken state. Empty if not bug injection |
| `run_script.sh` | Applies patches in order and runs tests in two phases |
| `parse_results.sh` | Reads raw output file, generates `/app/test_results.json` |
| `test_results.json` | JSON output with phase-by-phase test results and overall result |

---

## Docker Pipeline Architecture

```
base.Dockerfile
  └── Clones repo to /app
  └── git reset --hard $LATEST_COMMIT
  └── Installs all project + test dependencies
  └── ENTRYPOINT ["/bin/bash"]

instance.Dockerfile  (extends base)
  └── git checkout $LATEST_COMMIT
  └── If basetoinstance.patch non-empty → applies it (--mount=type=bind, not COPY)
  └── Verifies with grep -q '^diff' (NOT -s)
  └── ENTRYPOINT ["/bin/bash"]
```

```
run_script.sh execution flow:
  1. set -e
  2. Define RAW_OUTPUT_FILE, TEST_PATCH, GOLD_PATCH
  3. Clear RAW_OUTPUT_FILE
  4. Apply test_patch
  5. Echo "=== PHASE 1 START ===" → tee -a RAW_OUTPUT_FILE
  6. Run tests → tee -a RAW_OUTPUT_FILE || true
  7. Apply gold_patch
  8. Echo "=== PHASE 2 START ===" → tee -a RAW_OUTPUT_FILE
  9. Run tests → tee -a RAW_OUTPUT_FILE || true
  10. exit 0

parse_results.sh:
  → Reads RAW_OUTPUT_FILE
  → Splits by phase markers
  → Classifies tests as f2p (*.f2p.test.*) or p2p (*.p2p.test.*)
  → SUCCESS = f2p FAIL in Phase 1 + p2p PASS in Phase 1 + all PASS in Phase 2
  → Writes /app/test_results.json
  → Prints JSON to stdout
```

---

## Test Classification

| Type | File naming | Phase 1 (broken) | Phase 2 (fixed) |
|------|-------------|------------------|-----------------|
| **F2P** (Fail-to-Pass) | `*.f2p.test.js` / `*.f2p.test.ts` | FAIL | PASS |
| **P2P** (Pass-to-Pass) | `*.p2p.test.js` / `*.p2p.test.ts` | PASS | PASS |

- **F2P tests** detect whether the specific bug/feature is resolved.
- **P2P tests** guard against regressions in adjacent functionality.
- The two suites must be completely independent of each other.

---

## Issue Types

| Type | What it asks the AI to do |
|------|--------------------------|
| **Bug Injection** | Find and fix an intentionally introduced bug |
| **New Feature** | Implement functionality that does not exist yet |
| **Migration** | Adapt code to a new library, version, or pattern |
| **Performance Optimization** | Improve speed/efficiency without changing behavior |
| **Maintenance / Test Enhancement** | Update dependencies, tooling, or add tests |

**Important:** The issue type determines whether `basetoinstance.patch` is empty (all types except bug injection) or non-empty (bug injection only).

---

## Rubric Design Rules

A rubric is a JSON set of grading criteria that reviewers use to score AI responses.

### Structure Requirements
- All weights must sum to exactly **100**.
- `Correctness` dimension must have at least one criterion with ≥ 10% weight (excluding F2P/P2P).
- F2P + P2P combined weight: **≥ 20%** for visual/UI tasks, **≥ 30%** for logic/non-visual.
- Required criterion IDs: `f2p_success` and `p2p_success` (exactly these names).

### Quality Principles (all criteria must satisfy all 6)
1. **Atomic** — tests exactly one thing. If the criterion contains "and" joining two behaviors, split it.
2. **Objective** — measurable, no subjective language ("good format", "appropriate", "optimal").
3. **Self-contained** — evaluable without reading the prompt or other criteria.
4. **Relevant** — maps to an explicit requirement in the prompt.
5. **Specific** — references exact file names, function names, or values only if the prompt does.
6. **Consistent granularity** — all criteria at the same level of detail as the prompt.

### Quick Check Before Submitting
```
[ ] Weights sum to 100
[ ] f2p_success + p2p_success >= 20% (UI) or >= 30% (logic)
[ ] No criterion uses "and" to join two unrelated checks
[ ] Every criterion is evaluable standalone
[ ] Rubric granularity matches prompt granularity
[ ] All explicit prompt requirements have a criterion
```

---

## Invariant Rules (Never Break)

1. The repo always lives at **`/app`** inside Docker — never change this path.
2. **`ENTRYPOINT ["/bin/bash"]`** in both Dockerfiles — never use `CMD`.
3. Phase markers are **exact English literals**: `=== PHASE 1 START ===` and `=== PHASE 2 START ===`.
4. All test commands include **`|| true`** — prevents script abort on expected failures.
5. `run_script.sh` **only** applies patches and runs tests — never installs dependencies (exception: if gold_patch modifies package.json for a migration task).
6. `run_script.sh` **never** calls `parse_results.sh` internally.
7. `parse_results.sh` reads from **`RAW_OUTPUT_FILE`** — never from stdout directly.
8. `instance.Dockerfile` uses **`--mount=type=bind`** for the patch — never `COPY`.
9. `instance.Dockerfile` uses **`grep -q '^diff'`** to check patch content — never `-s`.
10. `test_patch.patch` contains **only test files** — never app code, configs, or package.json.
11. `gold_patch.patch` contains **only solution code** — never test files.

---

## Validation Script

Run before submitting to detect structural and runtime issues locally.

```bash
# Linux/VPS
chmod +x validation_script.sh
./validation_script.sh --local path/to/task --task-id my-task

# Windows (PowerShell)
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\validation_script.ps1 --local path\to\task --task-id my-task
```

The script validates: directory structure, Docker image builds, container execution of `run_script.sh` + `parse_results.sh`, and test result correctness.

---

## Official Evaluator (Stargazer_Eval)

The `Stargazer_Eval/` folder contains the official Outlier evaluation system.
It runs 8 independent evaluations and produces a consolidated PASS/FAIL report.

| Eval File | What It Checks |
|-----------|---------------|
| `1_Prompt_Eval.md` | Clarity, domain relevance, valid model failure, prompt-rubric alignment |
| `2_Tests_Eval.md` | F2P/P2P behavior, coverage, independence, patch quality |
| `3_Rubrics_Eval.md` | Objectivity, coverage, precision, atomicity, self-containment, weights, format |
| `4_Alignment_Eval.md` | Prompt ↔ rubric ↔ tests alignment |
| `5_Granularity_Eval.md` | Consistent specificity across prompt and rubric |
| `6_Dockerfile_Eval.md` | Base and instance build correctness |
| `7_GoldPatch_Eval.md` | Solution correctness, no test files, applies cleanly |
| `8_Coverage_Eval.md` | All required files present and valid |

The master eval (`0_Master_Eval.md`) runs all 8 and produces a single failures-only report with a "How to Fix" table. If any component is FAIL, overall verdict is FAIL.

---

## Reviewer Grading Scale

| Score | Meaning |
|-------|---------|
| **1** | Spam, LLM-generated, or zero effort. Must be redone entirely. |
| **2** | Shows effort but fails fundamentally. Major rewrites needed. |
| **3** | Mostly valid but with moderate issues that needed correction. |
| **4** | Minor issues only. Close to perfect. |
| **5** | Perfect. Followed all guidelines with no corrections needed. |

---

## Task 01 — Current Task Summary

- **Repo:** Nuton Learning App (GitHub ID 635272517) — Angular 19 / TypeScript
- **Stack:** Angular 19, TypeScript, Karma + Jasmine (`npm test`)
- **Type:** Performance Optimization
- **Target file:** `nuton/src/app/services/cart.service.ts`
- **Problem:** `CartService.subtotal` accumulates floating-point drift when courses are added/removed repeatedly (e.g., adding $0.07 × 6 = $0.42, then removing × 3 should yield $0.21 but drifts). `setDiscount` is also affected because it depends on `subtotal`.
- **Constraint:** Do not change the public interface, `CartState`, or `CourseModel`. Keep `total`, `discountAmount`, and delivery logic unchanged.
- **Current status:** Issue v3 drafted (misdirection strategy — leads model toward state mutation, not arithmetic fix). Pending: model test in Cursor, gold_patch, tests, Docker, and submission.
- **Progress file:** `Progreso-Actual/progreso.md`

---

## Common Errors to Avoid

| Error | What Happens | Fix |
|-------|-------------|-----|
| False model failure | Connection/API error labeled as model failure | Regenerate until a real logical failure occurs |
| Issue type mismatch | Prompt describes wrong problem type | Align prompt with the assigned issue type before writing |
| Non-compilable Dockerfile | Docker build fails | Test `docker build` locally before submitting |
| Wrong ENTRYPOINT | Uses `CMD` instead of `ENTRYPOINT ["/bin/bash"]` | Always use `ENTRYPOINT ["/bin/bash"]` |
| Wrong file names | e.g., `run_tests.sh` instead of `run_script.sh` | Follow exact naming from the guidelines |
| Missing rubric coverage | A prompt requirement has no rubric criterion | Map every explicit requirement to a criterion |
| Vague rubric criteria | Subjective language, unmeasurable conditions | Write observable, specific, pass/fail statements |
| F2P/P2P weight too low | Tests < 20% of rubric weight | Assign f2p + p2p >= 20% (UI) or >= 30% (logic) first |
| Gold patch includes test files | Reviewer rejects it | Separate solution code from test files strictly |
| Test patch includes app code | Reviewer rejects it | Only test files in test_patch |
| Behavioral tests missing | Tests only check file existence, not behavior | Write tests that execute the functionality and assert results |
| Missing test_results.json | parse_results.sh never writes the file | Use `tee` to write to both stdout and `/app/test_results.json` |
| Outdated patch paths | Patch references `/base` or `/instance` directories | Regenerate patch; all paths must use `/app` |
| Phase markers not reaching RAW_OUTPUT_FILE | Parser sees no phases → always FAILURE | Use `tee -a "$RAW_OUTPUT_FILE"` for phase echo commands |

---

## Environment (Pedro's VPS)

| Component | Status |
|-----------|--------|
| Docker | Installed and running |
| Cursor | Installed with Outlier API key |
| AI Models in Cursor | `gpt-oss-120b-bedrock`, `qwen3-235b-a22b-instruct-2507-scale` |
| Override Base URL | `https://cursor-intelligence-api.outlier.ai/api/v1` |
| Git push | Must use SSH (`git@github.com:...`) — HTTPS fails on this VPS |

---

## Key Reference Map

| I need to... | Go to |
|---|---|
| Know the current task status | `Progreso-Actual/progreso.md` |
| See the overall project map | `agent.md` |
| Set up and analyze a new repo | `references/01_setup_and_analysis.md` |
| Write the issue and test model | `references/02_problem_creation.md` |
| Write F2P/P2P tests | `references/03_testing.md` |
| Build Dockerfiles and scripts | `references/04_docker_scripts.md` |
| Run validation and submit | `references/05_to_08_remaining_steps.md` |
| Generate a patch correctly | `references/patch-workflow.md` |
| Design the rubric | `references/rubric-guide.md` |
| Know what reviewers check | `references/reviewer-grading-rubric.md` |
| Run the pre-submit checklist | `references/checklist.md` |
| Avoid common mistakes | `references/common-errors.md` |
| Get exact Dockerfile templates | `references/dockerfile-templates.md` |
| Get exact script templates | `references/script-templates.md` |
