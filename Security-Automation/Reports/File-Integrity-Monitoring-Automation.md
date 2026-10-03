# File Integrity Monitoring Automation

## Objective
Implement repeatable file integrity monitoring using SHA-256 hashes.

## Skills & Tools
Python 3, SHA-256, JSON, Linux, Git, security automation.

## Architecture
The Python monitor calculates file hashes and compares them with a stored JSON baseline.

## Topology
Security-Automation contains the monitoring script, evidence baseline, report and laboratory data.

## Execution
python3 Security-Automation/Scripts/file_integrity_monitor.py --target Security-Automation/lab-data --state Security-Automation/Evidence/integrity-state.json

## Walkthrough
Create a baseline, modify a monitored file, execute the monitor, restore the file and regenerate the baseline.

## Attack Simulation
A controlled local file modification simulated unauthorized modification of a monitored artifact.

## Detection
Detection occurs when the current SHA-256 hash differs from the recorded baseline.

## Triage
Identify the affected file and determine whether the modification was authorized or suspicious.

## Investigation
Correlate the file modification with authentication, process and system telemetry.

## Evidence
Evidence includes the Python script, JSON baseline, laboratory test file and execution results.

## Findings
The monitoring control successfully created a baseline and detected a deliberate file modification.

## Impact
Unexpected file modification can affect system integrity, configuration and application behaviour.

## Root Cause
The detected modification was intentionally introduced as a controlled laboratory test.

## MITRE ATT&CK
The exercise is relevant to T1565 Data Manipulation.

## Remediation
Protect baselines, restrict write access, centralize results and integrate alerts with a SIEM.

## Validation
Baseline creation, modification detection and final no-change validation were successfully performed.

## Lessons Learned
Hash comparison detects changes but contextual telemetry is required to determine why a change occurred.

## Recommendations
Expand monitored paths, schedule checks, protect baseline storage and integrate with Wazuh.
