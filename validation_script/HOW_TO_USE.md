# Stargazer Analyzer -- User Guide

## Prerequisites

- **Python 3.8+**
- **Docker CLI** on PATH
- **Windows only:** PowerShell 5.1+ (ships with Windows 10+) and Docker Desktop

## macOS / Linux - validation_script.sh

Set execution permissions before running the script:

```bash
chmod +x validation_script.sh
```

Then run the analizer:

```bash
./validation_script.sh --local path/to/task --task-id my-task
```

Minimal run (auto-generates task ID, auto-detects issue type):

```bash
./validation_script.sh --local path/to/task
```

## Windows (PowerShell) - validation_script.ps1

PowerShell may block unsigned scripts by default. Run this **each time you open
a new terminal**:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

Then run the analyzer: 

```powershell
.\validation_script.ps1 --local path\to\task --task-id my-task
```

Minimal run:

```powershell
.\validation_script.ps1 --local path\to\task
```

## Optional Patameters


| Flag                | Description                                                                                                                     |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `--task-id ID`      | Task identifier for logs and Docker tags                                                                                        |
| `--issue-type TYPE` | `bug_injection`, `new_feature`, `migration`, `performance`, or `maintenance_testing` (auto-detected from `issue.md` if omitted) |
| `--keep-artifacts`  | Keep Docker images after the run                                                                                                |
| `--keep-container`  | Keep the container running for manual inspection                                                                                |
| `--verbose`         | Enable debug-level logging                                                                                                      |
| `--json`            | Print JSON report to stdout                                                                                                     |


