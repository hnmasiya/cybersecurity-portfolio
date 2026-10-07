# Ransomware Detection & Response Lab

A safe simulated ransomware-response case study connecting endpoint telemetry, Wazuh/Sysmon-style detection, IOC extraction, containment, evidence preservation and recovery.

Safety: no ransomware is executed or distributed. The scenario uses synthetic file-activity and process telemetry.

Scenario: a workstation produces a burst of suspicious file-renaming activity and a synthetic process chain. Detect, scope, contain, preserve evidence and recover.

Evidence: evidence/ransomware-simulation.json, detections/ransomware-wazuh-sysmon.yml, reports/IR-REPORT.md.

Detection themes: mass file modification, suspicious process ancestry, encryption-like activity and abnormal endpoint behavior.

Response: isolate endpoint, preserve evidence, identify scope, validate backups, eradicate persistence, restore systems and monitor for recurrence.
