We need to check that the run_script.sh do not create extra files or parser the test results this is somehting that does not need to be there \
\
Task that requiered optimization needs to not be hardcoded for the specifc machine that they run this means we can not put arbirtrary time execution numbers and espec the test to pass in all diferent computers

## Rubric Self-Containment: Relative-Reference Words

**Problem**: Criteria that use words like "original", "existing", "current", "default", "matches" without embedding the concrete values they refer to. Even if the issue_message.txt uses the same vague language, the rubric must resolve it to actual values — because the grader must be able to evaluate pass/fail from the criterion text alone.

**Example failure**: 
- "When Monthly is selected, the original monthly prices are shown." → Grader cannot know what "original" means without reading source code.
- "The card grid layout matches the existing design." → Grader cannot know what "existing design" looks like.

**Fix applied**: Updated `3_Rubrics_Eval.md` with:
1. Expanded Self-Contained check description to flag relative-reference words
2. New "Relative-Reference Words" section listing trigger words and the litmus test
3. Added BAD/GOOD examples for this specific pattern
4. Added new common mistakes rows for this failure type

## Prompt Eval: Natural Voice, Ground Truth, and Reference Accuracy

**Problem**: Issue messages that read like spec documents or homework assignments instead of natural developer requests. Also, prompts that reference file names, functions, or identifiers that don't actually exist in the codebase (hallucinated references), or prompts that are ambiguous enough to have multiple valid interpretations (no unique ground truth).

**Fix applied**: Expanded `1_Prompt_Eval.md` with:
1. **Developer Voice check** — prompt must read like a real developer describing a problem, not a formal spec
2. **Unique Ground Truth section** — verifies single correct interpretation, no ambiguous scope, testable success criteria
3. **Codebase Reference Accuracy section** — every file/function/component/variable mentioned must actually exist in the repo (verified against patches and Dockerfile)
4. New quick fail conditions for hallucinated references and multiple ground truths
5. Natural Language examples table (BAD robotic vs GOOD developer voice)
6. Reference verification methodology and table format

## Test Coverage: Dedicated Deep Eval

**Problem**: The coverage checks inside `2_Tests_Eval.md` were too surface-level — just "does a test exist?" without traceability matrices or gap analysis.

**Fix applied**: Created `8_Coverage_Eval.md` with:
1. Step-by-step methodology to decompose issue into atomic requirements
2. F2P Traceability Matrix mapping each requirement to test assertions
3. Regression Risk Matrix mapping modified files to P2P guards
4. Orphan test detection
5. Rubric-to-test cross-reference for correctness criteria
6. Trimmed `2_Tests_Eval.md` coverage section to basic checks, pointing to the new eval for depth
