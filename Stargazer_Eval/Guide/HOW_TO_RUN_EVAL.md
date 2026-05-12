# How to Run the Eval

## Copy-Paste Prompt

Open a new Agent terminal, paste this, and run:

```
Run a full evaluation of the task in this workspace.

1. Read `0_Master_Eval.md` in the Evals folder — it defines the workflow.
2. Read all `*_Eval.md` files in Evals (excluding the master). Extract checklists, quick-fail conditions, and verdict templates dynamically from each file.
3. Find the task folder inside Tasks/Task_to_evaluate/. If multiple exist, ask which one. If one, use it.
4. For each eval, read the required task files and evaluate every checklist criterion with PASS/FAIL + concrete evidence (snippets, file paths, patch hunks).
5. Check quick-fail conditions per component.
6. Output a single consolidated report using the master eval output format: summary table, failed-component details only, and a "How to Fix" table. If all pass: "All components passed. Task is review-ready."

Do NOT hardcode checklist items — parse them from the eval files. Do NOT skip checks for missing files — record them as failures. Be concise.
```

## Setup

Place the task folder you want to evaluate inside `Tasks/Task_to_evaluate/`. It must contain at minimum:
- `issue_message.txt`
- `rubric.json`
- `patches/gold_patch.patch`
- `patches/test_patch.patch`
