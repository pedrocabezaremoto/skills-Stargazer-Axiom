# Granularity Quality Checklist — Issue Creation v2

## What This Evaluates

The specificity of the issue prompt and the rubric criteria, and whether they are **consistent with each other**. The key invariant is that the rubric must not introduce codebase-specific details (file names, method names, component names) that the prompt never surfaced — doing so leaks implementation knowledge to the grader. If the prompt is specific, the rubric should leverage that specificity. If the prompt is intentionally abstract (no file/method names), the rubric must stay at the same abstraction level. A rubric that references a file or method not mentioned in the prompt is a Granularity failure regardless of whether the prompt itself is specific or abstract.

## Input Files

- `issue_message.txt` — The prompt to evaluate
- `rubric.json` — The rubric criteria to evaluate

---

## Checklist

### Prompt Specificity

- [ ] **File or Directory Reference**: Prompt references at least one specific file, directory, or module path from the codebase (if none, check that rubrics also introduce none — see Quick Fail conditions)
- [ ] **Code Identifier Reference**: Prompt references at least one specific method, function, class, or named identifier from the codebase (if none, check that rubrics also introduce none — see Quick Fail conditions)
- [ ] **References Are Relevant**: Codebase references in the prompt (if any) are directly relevant to the problem being described (not generic padding)

### Rubric Specificity

- [ ] **Rubric Cites Specific References**: Rubric criteria reference specific files, functions, or values — not vague placeholders like "the file" or "the function"
- [ ] **No New References Introduced**: Every codebase reference in a rubric criterion (file name, method name, class, path) also appears in the prompt — rubrics must not introduce references the prompt never mentioned
- [ ] **Rubric Does Not Assume Hidden Knowledge**: Rubric criteria do not require knowing something about the codebase that the prompt never stated

### Prompt-Rubric Consistency

- [ ] **Consistent Detail Level**: The level of specificity in the rubrics does not exceed what the prompt provides (rubrics may be more precise in phrasing, but must not introduce new technical details)
- [ ] **Bidirectional Grounding**: Prompt references and rubric references describe the same scope — rubrics do not narrow or expand the target to files/methods/values not implied by the prompt

---

## Quick Fail Conditions

Any of these = automatic FAIL:

1. Rubric criteria reference specific files, methods, or components that do not appear anywhere in the prompt — information leak (the rubric introduces codebase knowledge the prompt never surfaced)
2. Prompt contains zero codebase references **and** rubric criteria introduce specific codebase references — the mismatch leaks implementation details to the grader
3. Rubric criteria are entirely vague with no specific codebase references at all, **even though** the prompt provides specific references — the rubric fails to leverage the specificity the prompt already established

Note: If the prompt contains zero codebase references **and** the rubric criteria also contain zero codebase references (both stay at the same abstraction level), this is **not** a quick fail — the two are consistent. The failure is the **mismatch** where one side is specific and the other is not, or where the rubric introduces specificity the prompt never provided.

---

## Reference Scope Rules

When checking whether a rubric reference was "mentioned in the prompt," apply these rules:

| Case | Verdict |
|------|---------|
| Rubric file path exactly matches a path in the prompt | PASS |
| Rubric method name exactly matches a method name in the prompt | PASS |
| Rubric references a file clearly implied by the prompt's module/package reference | PASS (minor) |
| Rubric references a method not named anywhere in the prompt | FAIL |
| Rubric references a file not named or implied anywhere in the prompt | FAIL |
| Prompt gives zero codebase anchors AND rubric also gives zero | PASS (consistent) |
| Prompt gives zero codebase anchors BUT rubric introduces specific ones | FAIL (information leak) |

---

## Verdict Template

```
## GRANULARITY EVAL: [PASS / FAIL]

### Prompt Codebase References
- Files/Directories: [list extracted or "None"]
- Methods/Functions/Classes: [list extracted or "None"]

### Rubric References
- References found in rubric: [list]
- References NOT in prompt: [list or "None"]

### Checklist Results
- Prompt Specificity: [X/3 passed]
- Rubric Specificity: [X/3 passed]
- Prompt-Rubric Consistency: [X/2 passed]

### Failed Checks
[List each failed check with brief reason, or "None"]

### Issues Found
| Element | Issue | Severity |
|---------|-------|----------|
| [criterion title or "Prompt"] | [Description] | Major/Minor |

### Recommendation
[One sentence: what needs to be fixed, or "Ready for use"]
```

---

## Common Mistakes

| Mistake | Example |
|---------|---------|
| Prompt has no codebase anchors | "Fix the bug in the calculation logic" (no file, no method named) |
| Rubric introduces new file | Prompt never mentions `src/utils/format.ts` but rubric criterion checks it |
| Rubric introduces new method | Prompt never mentions `parseDate()` but rubric checks its return value |
| Rubric vaguer than prompt | Prompt names `UserService.login()` but rubric just says "the login function" |
| Prompt references irrelevant paths | Prompt mentions `README.md` as a codebase reference but the issue has nothing to do with it |
| Over-specific rubric beyond prompt | Prompt says "the user list screen" but rubric checks a specific CSS class never mentioned |
