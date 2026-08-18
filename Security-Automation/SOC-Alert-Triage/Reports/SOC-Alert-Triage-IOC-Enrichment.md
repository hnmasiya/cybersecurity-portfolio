# SOC Alert Triage and IOC Enrichment

## Objective
Build a repeatable process for triaging SOC alerts, extracting indicators of compromise, and mapping activity to MITRE ATT&CK.

## Skills & Tools
Python 3, regular expressions, JSON, SOC triage workflow, MITRE ATT&CK, Linux, Git.

## Architecture
A Python script ingests a JSON list of alerts, extracts IOCs (IPv4 addresses, domains, SHA-256 hashes) from each alert's description, assigns severity-based priority and disposition, and maps keywords to MITRE ATT&CK techniques.

## Topology
Security-Automation/SOC-Alert-Triage contains Scripts, Data (sample alerts), Evidence (triage results), and Reports.

## Execution
python3 Security-Automation/SOC-Alert-Triage/Scripts/soc_alert_triage.py --input Security-Automation/SOC-Alert-Triage/Data/sample-alerts.json --output Security-Automation/SOC-Alert-Triage/Evidence/triage-results.json

## Walkthrough
Load sample alerts, run the triage script, review extracted IOCs and MITRE mappings, and inspect the resulting JSON evidence file.

## Attack Simulation
Five representative alerts were used, covering brute force, PowerShell/C2, port scanning, data exfiltration, and SQL injection activity.

## Detection
Detection relies on keyword matching in alert descriptions combined with regex-based IOC extraction.

## Triage
Alerts are assigned a severity-derived priority (P1-P4) and a disposition of ESCALATE, INVESTIGATE, or MONITOR.

## Investigation
Extracted IOCs and MITRE ATT&CK mappings give an analyst a starting point for correlating an alert with other telemetry.

## Evidence
Evidence includes the Python script, the sample alert data, and the generated triage-results.json output.

## Findings
The script correctly triaged all five sample alerts, extracted their embedded IOCs, and mapped each to at least one MITRE ATT&CK technique.

## Impact
Untriaged or manually triaged alerts slow SOC response time and increase the risk of missed indicators.

## Root Cause
Manual, ad hoc alert review does not scale and is prone to inconsistent prioritization and missed IOCs.

## MITRE ATT&CK
Mapped techniques include T1110 Brute Force, T1059.001 PowerShell, T1595 Active Scanning, T1041 Exfiltration Over C2 Channel, and T1190 Exploit Public-Facing Application.

## Remediation
Escalate P1/P2 alerts immediately, feed extracted IOCs into a threat intelligence platform, and block confirmed malicious indicators at the perimeter.

## Validation
Triage was run against five sample alerts and produced correct priority, disposition, IOC extraction, and MITRE mapping for each.

## Lessons Learned
Keyword-based triage is a fast first pass, but confirmed disposition still requires analyst review of the underlying telemetry.

## Recommendations
Expand the MITRE keyword set, integrate a real threat intelligence feed for IOC reputation lookups, and feed results into a SIEM or SOAR playbook.
