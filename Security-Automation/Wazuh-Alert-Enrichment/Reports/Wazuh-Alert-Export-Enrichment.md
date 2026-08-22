# Wazuh Alert Export Enrichment

## Objective
Enrich exported Wazuh alerts with severity prioritization, IOC extraction, and MITRE ATT&CK context to speed up SOC triage.

## Skills & Tools
Python 3, Wazuh alert schema, regular expressions, JSON, MITRE ATT&CK, SIEM workflows.

## Architecture
A Python script ingests a JSON export of Wazuh alerts, maps each alert's rule level to a severity/priority/disposition, extracts IOCs from the alert's data and full log fields, and maps rule groups to MITRE ATT&CK techniques.

## Topology
Security-Automation/Wazuh-Alert-Enrichment contains Scripts, Data (sample Wazuh alert export), Evidence (enrichment results), and Reports.

## Execution
python3 Security-Automation/Wazuh-Alert-Enrichment/Scripts/wazuh_alert_enrichment.py --input Security-Automation/Wazuh-Alert-Enrichment/Data/sample-wazuh-alerts.json --output Security-Automation/Wazuh-Alert-Enrichment/Evidence/enrichment-results.json

## Walkthrough
Load a sample Wazuh alert export, run the enrichment script, and review the resulting severity, IOCs, and MITRE mappings for each alert.

## Attack Simulation
Five representative Wazuh alerts were used, covering authentication failure, malware in a web request, privilege escalation via sudo, a routine system notification, and a port scan.

## Detection
Wazuh's own rule engine performs initial detection; this script adds a consistent enrichment layer on top of the exported alert data.

## Triage
Alerts are prioritized using Wazuh's 0-15 rule level scale, mapped here to CRITICAL/HIGH/MEDIUM/LOW severity and P1-P4 priority.

## Investigation
Extracted IOCs (IP addresses, domains, hashes) and MITRE ATT&CK mappings are attached directly to each alert to support faster correlation.

## Evidence
Evidence includes the Python script, the sample Wazuh alert export, and the generated enrichment-results.json output.

## Findings
The script correctly enriched all five sample alerts with severity, priority, disposition, extracted IOCs, and MITRE ATT&CK context.

## Impact
Raw Wazuh alerts without enrichment require manual lookup of IOCs and technique context, slowing SOC response.

## Root Cause
Wazuh's default export does not include IOC extraction or MITRE mapping in a triage-ready format, requiring manual analyst effort per alert.

## MITRE ATT&CK
Mapped techniques include T1110 Brute Force, T1190 Exploit Public-Facing Application, T1204 User Execution, T1548 Abuse Elevation Control Mechanism, and T1595 Active Scanning.

## Remediation
Escalate CRITICAL/HIGH disposition alerts immediately, feed extracted IOCs into a threat intelligence platform, and tune Wazuh rule levels to match organizational risk tolerance.

## Validation
The enrichment script was run against five sample alerts and produced correct severity, priority, IOC extraction, and MITRE mapping for each.

## Lessons Learned
Rule-group-to-MITRE mapping is a fast way to add ATT&CK context, but the mapping table needs to be maintained as new Wazuh rule groups are used.

## Recommendations
Expand the rule-group MITRE mapping table, integrate a threat intelligence feed for IOC reputation, and forward enriched output to a SOAR playbook.
