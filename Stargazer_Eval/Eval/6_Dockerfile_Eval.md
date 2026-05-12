# Dockerfile Quality Checklist — Issue Creation v2

## What This Evaluates

The `base.Dockerfile` and `instance.Dockerfile` for the task. Both files must conform to the standard structure defined in the project templates. Dockerfile correctness is critical — a misconfigured Dockerfile will prevent the eval environment from building or running correctly.

Reference templates:
- `Templates/Base.dockerfile.md` — expected structure for `base.Dockerfile`
- `Templates/Instance.dockerfile.md` — expected structure for `instance.Dockerfile`

## Input Files

- `base.Dockerfile` — The base image definition to evaluate
- `instance.Dockerfile` — The instance image definition to evaluate

---

## Checklist

### Base Dockerfile — Required Structure

- [ ] **Concrete FROM**: `FROM` directive uses a real image and tag (e.g. `node:16-alpine`) — not the template placeholder `<base-image>`
- [ ] **Working Directory**: `RUN mkdir /app` and `WORKDIR /app` are present and set the working directory to `/app`
- [ ] **Git Installed**: System dependencies install `git` (required for repo cloning and patch apply)
- [ ] **Real Repo URL**: `RUN git clone <url> .` uses a real repository URL — not the literal placeholder `<repo_url>`
- [ ] **Resets to Latest Commit**: After cloning, the Dockerfile resets to the latest commit of the repo using a pattern like `git rev-list -n 1 HEAD` — it must NOT hardcode a specific commit hash (which would pin to an arbitrary old state) nor checkout a branch name directly without resolving HEAD

### Base Dockerfile — Hygiene

- [ ] **Correct ENTRYPOINT**: `ENTRYPOINT ["/bin/bash"]` is present as the last directive
- [ ] **No CMD/ENTRYPOINT Abuse**: Build and test commands are not set as `ENTRYPOINT` or `CMD` — they must be `RUN` commands in the appropriate section

### Instance Dockerfile — Required Structure

- [ ] **Named FROM**: `FROM` directive references a real named base image (e.g. `FROM my-project-base`) — not the template placeholder `<base-image>`
- [ ] **Working Directory**: `WORKDIR /app` is present
- [ ] **Patch Apply Block**: Contains the standard `basetoinstance.patch` apply block using `--mount=type=bind` with the conditional `git apply --whitespace=fix` pattern

### Instance Dockerfile — Hygiene

- [ ] **No ENTRYPOINT/CMD Override**: Does not define a new `ENTRYPOINT` or `CMD` — the base image's `ENTRYPOINT ["/bin/bash"]` must remain in effect

---

## Quick Fail Conditions

Any of these = automatic FAIL:

1. `base.Dockerfile` `FROM` is missing or still contains the template placeholder `<base-image>`
2. `base.Dockerfile` repo URL is the literal placeholder `<repo_url>` — environment cannot clone the repo
3. `base.Dockerfile` does not resolve and reset to the latest commit (e.g. missing `git rev-list -n 1 HEAD` pattern, or uses a hardcoded hash, or checks out a branch name directly)
4. `base.Dockerfile` is missing `ENTRYPOINT ["/bin/bash"]`
5. `instance.Dockerfile` is missing the standard `basetoinstance.patch` apply block

---

## Standard Patch Apply Block (Reference)

The `instance.Dockerfile` must contain this exact pattern (content may vary but structure must match):

```
RUN --mount=type=bind,source=patches/basetoinstance.patch,target=/tmp/basetoinstance.patch \
    if grep -q '^diff' /tmp/basetoinstance.patch 2>/dev/null; then \
        git apply --whitespace=fix /tmp/basetoinstance.patch; \
    else \
        echo "basetoinstance.patch is empty or has no diffs, skipping..."; \
    fi
```

---

## Verdict Template

```
## DOCKERFILE EVAL: [PASS / FAIL]

### Base Dockerfile
- Image: [FROM value]
- Repo URL: [git clone URL or "placeholder"]
- Latest Commit Reset: [present (git rev-list pattern) / hardcoded hash (bad) / missing (bad)]
- ENTRYPOINT: [present / missing]

### Instance Dockerfile
- Base Image: [FROM value]
- Patch Apply Block: [present / missing]
- ENTRYPOINT Override: [none / present (bad)]

### Checklist Results
- Base Required Structure: [X/5 passed]
- Base Hygiene: [X/2 passed]
- Instance Required Structure: [X/3 passed]
- Instance Hygiene: [X/1 passed]

### Failed Checks
[List each failed check with brief reason, or "None"]

### Issues Found
| File | Issue | Severity |
|------|-------|----------|
| [base.Dockerfile / instance.Dockerfile] | [Description] | Major/Minor |

### Recommendation
[One sentence: what needs to be fixed, or "Ready for use"]
```

---

## Common Mistakes

| Mistake | Example |
|---------|---------|
| Placeholder FROM | `FROM <base-image>` left unchanged from template |
| Placeholder repo URL | `RUN git clone <repo_url> .` left unchanged from template |
| Hardcoded commit hash | `git reset --hard <hash>` pins to an arbitrary old state instead of resolving HEAD |
| Missing latest-commit reset | No `git rev-list -n 1 HEAD` or equivalent after clone |
| Missing ENTRYPOINT | Base Dockerfile ends without `ENTRYPOINT ["/bin/bash"]` |
| CMD abuse | `CMD ["npm", "test"]` in Dockerfile instead of a `RUN` command |
| Missing patch block | `instance.Dockerfile` has no `basetoinstance.patch` apply logic |
| ENTRYPOINT override in instance | `instance.Dockerfile` defines its own `ENTRYPOINT`, breaking the base |
| Wrong working directory | `WORKDIR /project` or `WORKDIR /home/app` instead of `/app` |
