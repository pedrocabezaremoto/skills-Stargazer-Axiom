# QC Specification Document — Issue Creation v2

## Overview

This document defines the quality dimensions, scoring thresholds, and grading rules for evaluating Issue Creation v2 tasks. Use this as the authoritative reference for what constitutes PASS, NON-FAIL, and FAIL across all evaluation dimensions.

---

## Scoring Scale

| Score | Verdict | Meaning |
|-------|---------|---------|
| 5 | PASS | Meets all requirements — ready for use |
| 3-4 | NON-FAIL | Minor issues — needs fixes but fundamentally sound |
| 1-2 | FAIL | Major issues — requires significant rework |

**Grading Rule:** Grade to the LOWEST sub-dimension. If any sub-dimension fails, the entire component fails.

---

## Prompt Quality Dimensions

### 1. Natural Language Quality

| Score | Criteria |
|-------|----------|
| **FAIL (1-2)** | Reads like a specification document; gives away the solution; contains step-by-step commands; uses robotic/formal language inconsistent with a user request |
| **NON-FAIL (3-4)** | Mostly natural but has minor issues (slightly formal, minor pre-solving hints) |
| **PASS (5)** | Natural user request that describes the problem without pre-solving; reads like something a developer would actually say |

**Key Indicators:**
- First person or natural request style
- No numbered implementation steps
- No explicit file paths that give away the solution
- No function/method names that pre-solve

---

### 2. Issue Clarity

| Score | Criteria |
|-------|----------|
| **FAIL (1-2)** | Ambiguous or confusing; unclear what's being asked; conflicting requirements |
| **NON-FAIL (3-4)** | Some ambiguity but main intent is clear; minor unclear aspects |
| **PASS (5)** | Clear and specific; no room for misinterpretation; a competent developer could understand exactly what's being asked |

**Key Indicators:**
- Problem is clearly described
- Expected behavior is implied or stated
- Scope is clear (what needs to change)
- No conflicting requirements

---

### 3. Issue Type Alignment

| Score | Criteria |
|-------|----------|
| **FAIL (1-2)** | Prompt doesn't match the assigned issue type |
| **PASS (5)** | Prompt clearly matches the assigned issue type |

**Issue Types:**
- Bug Injection: Describes broken behavior that needs fixing
- New Feature: Requests new functionality not currently present
- Migration: Asks to adapt code to new library/pattern/version
- Performance Optimization: Requests speed/efficiency improvements
- Maintenance: Updates dependencies, tests, or tooling
- Testing Enhancement: Adds unit tests or test coverage

---

### 4. Gold Path Alignment

| Score | Criteria |
|-------|----------|
| **FAIL (1-2)** | Major mismatch between prompt and gold solution; gold patch changes things not asked for; prompt asks for things not in gold patch |
| **NON-FAIL (3-4)** | Minor gaps or extra changes; mostly aligned |
| **PASS (5)** | Full alignment; every prompt ask is addressed by gold patch; every gold patch change addresses something in prompt |

---

### 5. Rubric Alignment

| Score | Criteria |
|-------|----------|
| **FAIL (1-2)** | Multiple rubrics don't trace to prompt; rubrics evaluate things not asked |
| **NON-FAIL (3-4)** | Minor gaps in traceability |
| **PASS (5)** | All rubrics trace to prompt requirements; specificity in rubrics matches specificity in prompt |

---

### 6. Specificity Balance

| Score | Criteria |
|-------|----------|
| **FAIL (1-2)** | Pre-solves the issue (gives away implementation); OR too vague to evaluate |
| **NON-FAIL (3-4)** | Minor specificity issues |
| **PASS (5)** | Perfect balance; specific enough to evaluate success; doesn't pre-solve |

---

### 7. Model Challenge

| Score | Criteria |
|-------|----------|
| **FAIL (1-2)** | Both models (GPT-OSS and QWEN) would easily solve this |
| **NON-FAIL (3-4)** | Challenging but no documented failure evidence |
| **PASS (5)** | Documented model failure exists; at least one model fails |

---

### 8. Natural Difficulty

| Score | Criteria |
|-------|----------|
| **FAIL (1-2)** | Difficulty is contrived or artificial (arbitrary constraints, unrealistic requirements) |
| **NON-FAIL (3-4)** | Some contrived elements but core scenario is natural |
| **PASS (5)** | All difficulty comes from natural complexity (multiple components, hidden dependencies, integration complexity) |

---

## Tests Quality Dimensions

### 1. Naming Convention

| Score | Criteria |
|-------|----------|
| **FAIL (1-2)** | Tests don't follow naming convention (`.f2p.test.{ext}` and `.p2p.test.{ext}`) |
| **PASS (5)** | All tests follow proper naming convention |

---

### 2. Behavioral (Not Implementation)

| Score | Criteria |
|-------|----------|
| **FAIL (1-2)** | Tests check implementation details (mocks internal methods, checks private state, requires specific data structures) |
| **NON-FAIL (3-4)** | Mostly behavioral with minor implementation coupling |
| **PASS (5)** | Fully behavioral; any valid solution would pass; tests verify WHAT, not HOW |

**Key Indicators:**
- Tests observable output/behavior
- Tests function return values
- Tests API responses
- Does NOT mock internal methods
- Does NOT check private variables
- Does NOT require specific algorithms

---

### 3. F2P Correctness

| Score | Criteria |
|-------|----------|
| **FAIL (1-2)** | F2P tests don't verify new functionality; would pass before patch; test wrong behavior |
| **NON-FAIL (3-4)** | Minor issues with F2P test coverage |
| **PASS (5)** | F2P tests correctly verify all new functionality; FAIL before patch, PASS after |

---

### 4. P2P Correctness

| Score | Criteria |
|-------|----------|
| **FAIL (1-2)** | P2P tests break existing functionality; would fail before patch |
| **NON-FAIL (3-4)** | Minor issues with P2P test coverage |
| **PASS (5)** | P2P tests correctly verify no regression; PASS before and after patch |

---

### 5. Coverage

| Score | Criteria |
|-------|----------|
| **FAIL (1-2)** | Major gaps in test coverage; prompt asks have no tests |
| **NON-FAIL (3-4)** | Minor coverage gaps |
| **PASS (5)** | Comprehensive test coverage; all prompt asks have corresponding tests |

---

## Rubrics Quality Dimensions

### 1. Structure (Fields Present)

| Score | Criteria |
|-------|----------|
| **FAIL (1-2)** | Missing required fields (id, requirement, weight, dimension) |
| **PASS (5)** | All criteria have all required fields; IDs follow `rubric_criteria` format |

---

### 2. Weights

| Score | Criteria |
|-------|----------|
| **FAIL (1-2)** | Weights don't sum to 100; OR f2p + p2p < 20%; OR Correctness < 10% |
| **PASS (5)** | All weight requirements satisfied |

**Requirements:**
- Sum of all weights = 100
- f2p_success + p2p_success >= 20% (30-40% for logic-heavy)
- Correctness dimension >= 10%

---

### 3. Self-Contained

| Score | Criteria |
|-------|----------|
| **FAIL (1-2)** | Multiple criteria need external information to evaluate (codebase, prompt, etc.) |
| **NON-FAIL (3-4)** | Minor self-containment gaps |
| **PASS (5)** | All criteria are fully self-contained; can evaluate using only criterion text and solution |

**Key Indicators:**
- All expected values embedded in criterion
- No vague references ("the correct file", "the right function")
- Specific file paths, function names, values stated

---

### 4. Atomic

| Score | Criteria |
|-------|----------|
| **FAIL (1-2)** | Multiple criteria bundle independent checks (can fail for different reasons) |
| **NON-FAIL (3-4)** | Minor atomicity issues |
| **PASS (5)** | All criteria are atomic; each tests exactly one thing |

---

### 5. Unambiguous

| Score | Criteria |
|-------|----------|
| **FAIL (1-2)** | Multiple criteria use vague/subjective language ("properly", "correctly", "good") |
| **NON-FAIL (3-4)** | Minor ambiguity issues |
| **PASS (5)** | All criteria are unambiguous; tied to measurable factors |

**Banned Words:**
- "properly", "correctly", "appropriately"
- "good", "well", "adequate", "sufficient"
- "important", "relevant", "necessary"
- "reasonable", "appropriate", "suitable"

---

### 6. Specific

| Score | Criteria |
|-------|----------|
| **FAIL (1-2)** | Multiple criteria lack specific references (files, functions, values) |
| **NON-FAIL (3-4)** | Minor specificity gaps |
| **PASS (5)** | All criteria have specific, verifiable references |

---

### 7. Mandatory Criteria

| Score | Criteria |
|-------|----------|
| **FAIL (1-2)** | Missing `f2p_success` or `p2p_success` criteria; OR combined weight < 20% |
| **PASS (5)** | Both mandatory criteria present with proper weight |

---

### 8. Dimension Coverage

| Score | Criteria |
|-------|----------|
| **FAIL (1-2)** | Correctness dimension < 10% weight; OR no Correctness criteria |
| **PASS (5)** | Correctness >= 10% with at least one criterion |

---

### 9. Prompt Alignment

| Score | Criteria |
|-------|----------|
| **FAIL (1-2)** | Multiple criteria don't trace to prompt; criteria evaluate things not asked |
| **NON-FAIL (3-4)** | Minor alignment gaps |
| **PASS (5)** | All criteria trace to prompt requirements |

---

### 10. Completeness

| Score | Criteria |
|-------|----------|
| **FAIL (1-2)** | Major prompt asks have no criteria |
| **NON-FAIL (3-4)** | Minor coverage gaps |
| **PASS (5)** | All prompt asks covered by criteria |

---

## Issue Severity Classification

### Major Issues (Cause FAIL)

| Component | Issue |
|-----------|-------|
| Prompt | Pre-solving; command list; over-specification |
| Prompt | Major mismatch with gold patch |
| Prompt | Rubrics evaluate things not in prompt |
| Tests | Tests implementation, not behavior |
| Tests | F2P passes before patch |
| Tests | P2P fails before patch |
| Tests | Wrong naming convention |
| Rubrics | Not self-contained |
| Rubrics | Not atomic |
| Rubrics | Missing f2p_success or p2p_success |
| Rubrics | Weights don't sum to 100 |
| Rubrics | Correctness < 10% |

### Moderate Issues (Cause NON-FAIL)

| Component | Issue |
|-----------|-------|
| Prompt | Minor specificity issues |
| Prompt | Some contrived difficulty |
| Tests | Minor implementation coupling |
| Tests | Minor coverage gaps |
| Rubrics | Minor self-containment gaps |
| Rubrics | Minor ambiguity |
| Rubrics | Minor coverage gaps |

### Minor Issues (Note but don't downgrade)

| Component | Issue |
|-----------|-------|
| Prompt | Slightly formal language |
| Tests | Tests in wrong category (F2P vs P2P) |
| Rubrics | Wrong ID format |
| Rubrics | Minor wording issues |

---

## Final Verdict Calculation

1. Score each sub-dimension (1-5)
2. Find the LOWEST score across all sub-dimensions
3. That becomes the final verdict:
   - Lowest = 5 → **PASS**
   - Lowest = 3-4 → **NON-FAIL**
   - Lowest = 1-2 → **FAIL**

**Example:**
```
Prompt Natural Language: 5
Prompt Issue Clarity: 5
Prompt Gold Path Alignment: 3  ← Lowest
Prompt Rubric Alignment: 5

Final Verdict: NON-FAIL (3)
```
