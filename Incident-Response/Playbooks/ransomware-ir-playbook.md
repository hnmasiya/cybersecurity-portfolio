# Incident Response Playbook: Enterprise Ransomware Containment

## Metadata
* **Document ID:** IR-PB-001
* **Author:** Hazvinei Masiya
* **Scope:** Enterprise-wide Ransomware & Extortion Outbreak
* **Classification:** Standard Operating Procedure (SOP)

---

## Phase 1: Preparation & Triage
1. **Alert Trigger:** EDR or SIEM detects mass file renaming extensions or shadow copy deletion ().
2. **Initial Action:** Isolate affected endpoint(s) immediately via network containment while preserving volatile memory.

## Phase 2: Containment & Eradication
* **Process Termination:** Kill rogue child processes spawned by initial access vectors.
* **Network Defense:** Block malicious Command and Control (C2) IPs and domain hashes at the perimeter firewall and DNS sinkhole.

## Phase 3: Recovery & Post-Incident Review
* **Restoration:** Validate and restore clean state systems from immutable, air-gapped backups.
* **Lessons Learned:** Conduct root cause analysis, feed IoCs into threat intelligence platforms, and draft updated detection rules.
