# IR-001 — Document-Driven Encoded PowerShell

**Evidence status:** SIMULATED TABLETOP + REPRODUCIBLE SYNTHETIC FIXTURES  
**Environment:** Offline repository test harness  
**Affected asset in scenario:** `WS-FIN-023`  
**Scenario user:** `finance.user`  
**Production status:** No live incident, endpoint, SIEM, or organizational environment was accessed.

## Executive summary

The tabletop begins with a Windows process-creation alert showing Microsoft Word launching PowerShell with an encoded command. Additional *simulated* records show an outbound HTTPS connection attempt and creation of a script-like file in the user's temporary directory. In the scenario, subsequent controlled review classifies the script's intent as malicious, but the available records do not prove that a second-stage payload successfully executed, credentials were stolen, persistence was established, or other endpoints were compromised.

This is a training scenario. The fixture values are synthetic and must not be represented as collected incident evidence.

## Objectives

- Practise evidence-first triage and timeline construction.
- Correlate process, network, and file telemetry without overclaiming what each record proves.
- Exercise containment, forensic scoping, eradication, recovery authorization, and lessons learned.
- Reproduce the process-detection result against positive and benign synthetic events.

## Synthetic timeline

| Time (UTC) | Source / event | Simulated observation | Interpretation and limitation |
|---|---|---|---|
| 09:14:22 | Windows Security, Event ID 4688 | `WINWORD.EXE` is the parent of encoded `powershell.exe` | Suspicious process relationship; requires investigation, not proof by itself |
| 09:14:24 | Sysmon, Event ID 3 | Outbound TCP connection attempt to `203.0.113.44:443` | Uses TEST-NET-3 documentation IP space; not a real IOC and not proof of successful transfer |
| 09:14:26 | Sysmon, Event ID 11 | A script-like file appears at `%TEMP%\\invoice_update.ps1` | File creation alone does not prove execution; content is intentionally not supplied |
| 10:05:00 | Windows Security, Event ID 4688 | Benign control: ordinary PowerShell inventory script | Should not match the encoded-command rule |

All timestamps and records above are hand-authored training fixtures. They are not extracted from Windows, Sysmon, Wazuh, Splunk, or an actual host.

## Response decisions exercised

1. **Triage:** preserve the alert and event context; avoid premature closure or destructive action.
2. **Investigation:** correlate process ancestry with network, file, and identity telemetry.
3. **Containment:** isolate the host through an approved procedure when combined indicators justify it; document the action and preserve authorized forensic access.
4. **Evidence and scope:** preserve logs and artifacts, maintain chain of custody, and hunt for related activity across available telemetry.
5. **Eradication:** investigate payload execution and persistence; remediate confirmed artifacts or rebuild from a trusted image where appropriate.
6. **Recovery:** verify endpoint controls and logging; assess identity exposure and remaining scope uncertainty; obtain documented authorization before reconnection.
7. **Lessons learned:** tune detection, add positive and benign regression tests, and update response procedures.

## Detection validation

The repository's `detections/detection_engine.py` evaluates normalized process-creation fields. The synthetic fixture runner expects:

- `IR001-E001`: rule `DE-001` for encoded PowerShell.
- `IR001-E002`: no process-rule alert from a network-only record.
- `IR001-E003`: no process-rule alert from a file-only record.
- `IR001-E004`: no alert for ordinary PowerShell without an encoded-command switch.

The no-alert outcomes for network and file records mean only that this *process detection harness* does not treat those record types as process-creation alerts. They do not mean the network or file activity is benign. Separate correlation and detection logic would be needed to assess those events.

### Reproduce

From the repository root:

```bash
cd SOC/Detection-as-Code
python3 -m unittest discover -s Tests -v
python3 scripts/run_ir001_case.py --check
```

The runner validates expected rule IDs against the checked-in synthetic records and verifies this report exists. It does not connect to a live endpoint or SIEM.

## Outcome and limitations

The synthetic process-detection expectation is one alert for the suspicious encoded-PowerShell fixture and no alert for the benign PowerShell control. Network and file records are retained as contextual timeline evidence but are not evaluated by the process-only detector.

This case does not measure production detection precision, recall, false-positive rate, telemetry coverage, or resistance to evasion. The Sigma rule's field mapping and behavior must still be validated in the target SIEM. The tabletop's containment and recovery outcomes are scenario decisions, not actions performed on real systems.

## Follow-up actions

- Validate event-field mapping against authorized, sanitized Windows/Sysmon lab telemetry.
- Add correlation logic for process-to-network and process-to-file activity, with tests for time windows and host/user keys.
- Expand benign controls for approved admin scripts and document tuning decisions.
- Review identity telemetry and credential-response criteria in a separate controlled exercise.
- Record test outputs and workflow results without inventing operational metrics.

## Evidence integrity statement

All scenario details and fixture events are synthetic. No real IP reputation is implied; `203.0.113.44` is used as a documentation address. No payload is included or executed. No production incident, successful compromise, live containment, or SIEM validation is claimed.
