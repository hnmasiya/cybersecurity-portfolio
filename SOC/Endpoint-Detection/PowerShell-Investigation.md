# PowerShell Investigation

## Investigation objective

Investigate PowerShell execution using:
- process creation telemetry
- command-line arguments
- parent process
- user context
- network activity
- timeline correlation

## High-value indicators

Examples include:
- encoded commands
- download activity
- execution from unusual parent processes
- suspicious child processes
- remote administration behavior
- script interpreters chained with unexpected applications

## ATT&CK

PowerShell activity may map to:
**T1059.001 — PowerShell**

The technique should only be marked OBSERVED when the retained telemetry demonstrates the behavior.

## Analyst decision

PowerShell is a legitimate administrative tool.

Therefore:
**PowerShell execution alone is not sufficient evidence of compromise**

The investigation must establish whether the command, parent process, account, destination and surrounding timeline indicate malicious behavior.

## Evidence

See the Azure Windows/Sysmon evidence and the existing endpoint detection lab.

Live production compromise is not claimed.
