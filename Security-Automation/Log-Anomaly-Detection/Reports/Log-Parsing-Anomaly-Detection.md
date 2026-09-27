# Log Parsing and Anomaly Detection

## Objective
Parse authentication log data and flag anomalous patterns such as brute-force login attempts, off-hours access, and privileged command use.

## Skills & Tools
Python 3, regular expressions, log parsing, JSON, Linux authentication logs, MITRE ATT&CK.

## Architecture
A Python script reads a plaintext authentication log, parses each line into timestamp/host/process/message fields, classifies events (failed login, accepted login, privileged command), and applies threshold- and time-based rules to flag anomalies.

## Topology
Security-Automation/Log-Anomaly-Detection contains Scripts, Data (sample auth log), Evidence (anomaly results), and Reports.

## Execution
python3 Security-Automation/Log-Anomaly-Detection/Scripts/log_anomaly_detector.py --input Security-Automation/Log-Anomaly-Detection/Data/sample-auth.log --output Security-Automation/Log-Anomaly-Detection/Evidence/anomaly-results.json

## Walkthrough
Load a sample authentication log, run the detector, and review flagged brute-force attempts, off-hours logins, and privileged command executions in the resulting JSON.

## Attack Simulation
A simulated authentication log includes a repeated failed-login burst against admin/root accounts, a successful login outside normal hours, and privileged sudo command usage.

## Detection
Detection combines a failed-login threshold per source IP, a configurable off-hours time window, and pattern matching on sudo command lines.

## Triage
Each anomaly is assigned a severity (HIGH for brute force, MEDIUM for off-hours access, LOW for privileged commands) to guide analyst response order.

## Investigation
Flagged source IPs, usernames, and commands give an analyst a starting point for correlating with other logs or IOC data.

## Evidence
Evidence includes the Python script, the sample authentication log, and the generated anomaly-results.json output.

## Findings
The detector correctly identified a brute-force attempt from a single source IP, an off-hours successful login, and two privileged command executions.

## Impact
Undetected brute-force attempts can lead to account compromise, and unreviewed off-hours or privileged activity can mask unauthorized access.

## Root Cause
Manual review of raw authentication logs does not scale and is prone to missing threshold-based patterns like repeated failed logins.

## MITRE ATT&CK
Mapped techniques include T1110 Brute Force, T1078 Valid Accounts, and T1548 Abuse Elevation Control Mechanism.

## Remediation
Lock or alert on accounts after repeated failed logins, require additional verification for off-hours access, and review privileged command logs regularly.

## Validation
The detector was run against a 12-line sample log and correctly flagged one brute-force attempt, one off-hours login, and two privileged command events.

## Lessons Learned
Threshold-based detection catches obvious brute-force patterns quickly, but context such as asset criticality and user baseline behavior is still needed to judge true risk.

## Recommendations
Tune the failed-login threshold and off-hours window per environment, expand parsing to cover additional log sources, and forward results to a SIEM.
