# SOC Lab Validation Roadmap

**Status:** implementation scaffold; live lab execution is pending. This repository change does not establish that Windows, Sysmon, Wazuh, or Splunk telemetry has been collected.

## Scope and phases

1. **Live telemetry validation:** run a harmless, local-only exercise on an authorized Windows lab endpoint; collect only relevant event metadata; validate event IDs, timestamps, host/user joins, and expected DE-001 behavior.
2. **Detection engineering:** use collected field mappings and analyst-reviewed outcomes to tune detection rules; preserve positive and benign controls and regression tests.
3. **Response workflow:** generate an incident summary and recommended actions. Containment remains human-approved; this project does not automatically isolate hosts, disable accounts, kill processes, or delete files.
4. **Multi-source investigation:** correlate process, network, file, and authentication events. Missing or mismatched identity/time fields must remain explicit uncertainty, not be silently inferred.
5. **Operational evidence:** record test owner, date, source versions, collection window, rule version, expected/actual outcome, false positives, limitations, and evidence hashes.

## Phase 1: authorized Windows/Sysmon collection

Prerequisites:
- A Windows test endpoint you own or are authorized to administer.
- Sysmon installed and configured to record process creation (Event ID 1), network connections (3), and file creation (11), plus Windows Security process creation auditing (4688) if available.
- PowerShell available; administrative access only where needed for event-log access.
- A local output directory outside the Git working tree.

Run from an elevated PowerShell terminal in the lab. The exercise starts a child PowerShell process with a **benign encoded command**, creates a marker file in the current user's temp directory, and attempts a loopback-only TCP connection. It does not contact an external host. The network event will only be available if Sysmon's configuration and Windows policy collect it.

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
.\scripts\Invoke-IR001LabValidation.ps1 -OutputDirectory "$env:USERPROFILE\IR001-Lab-Evidence"
```

If script execution policy or event-log permissions are managed by your organization, follow the organization's approved process; do not weaken machine-wide policy.

The script writes a JSON bundle and SHA-256 manifest locally. Review them before using them. Do not commit raw Windows event logs, user identifiers, internal hostnames, command lines, or unredacted evidence to a public repository. Keep original evidence local and create a sanitized derivative for portfolio use.

## Validation procedure

1. Confirm the bundle labels its source as lab telemetry and includes capture timestamps and hashes.
2. Verify which expected event types actually appeared. Absence of an event is a collection/configuration finding, not a successful detection.
3. Check the process event's image, command line, parent process, host, user, and UTC timestamp. Do not assume Windows Security 4688 and Sysmon Event ID 1 have identical fields.
4. Check whether Sysmon Event ID 3 recorded the loopback attempt and Event ID 11 recorded the marker file.
5. Evaluate the encoded PowerShell event against DE-001. A match is expected only if the collected event can be mapped to the detection harness's normalized `Image` and `CommandLine` fields.
6. Record expected versus actual outcomes and false positives in the evidence template below.
7. Remove the temporary marker file after evidence collection if it remains. Preserve the evidence bundle according to your lab policy.

## Evidence record template

Copy this table into a local report, then publish only sanitized results:

| Field | Value |
|---|---|
| Test ID | IR-001-LAB |
| Execution date/time (UTC) | Pending lab execution |
| Endpoint / OS / Sysmon version | Pending |
| Data sources and enabled event IDs | Pending |
| Detection rule / version | DE-001 / repository commit |
| Expected process alert | One encoded PowerShell alert |
| Actual process alert | Pending |
| Network / file events observed | Pending |
| Benign control result | Pending |
| False positives / gaps | Pending |
| Evidence SHA-256 | Generated locally; do not publish raw evidence |
| Reviewer and disposition | Pending |

## Phase 2 — detection engineering

- Promote only field mappings verified from captured event examples.
- Add sanitized event fixtures only after review; include at least one positive, one benign, and one incomplete/malformed event.
- Record rule tuning rationale and expected false-positive sources.
- Keep synthetic CI checks separate from real-lab validation status.

## Phase 3 — response workflow

The response helper should produce a triage packet: alert IDs, timeline, host/user context, confidence limitations, evidence pointers, and suggested next steps. Any disruptive action must be an explicit analyst decision outside this helper. No automatic containment is implemented by this roadmap.

## Phase 4 — broader telemetry

Extend coverage to Windows authentication events (4624/4625) and other approved identity telemetry. Use exact event timestamps and normalized host/account keys. Correlation is contextual evidence, not proof of causality or compromise.

## Phase 5 — operational evidence and completion gates

A phase is complete only when its own acceptance criteria have evidence:
- **CI/synthetic:** reproducible tests pass in GitHub Actions.
- **Lab validated:** a human ran the exercise on an authorized endpoint and reviewed the local evidence.
- **SIEM validated:** event ingestion, field mapping, query/rule behavior, and alert output were checked in the actual Wazuh/Splunk environment.
- **Production:** never claim production operation from a lab test.

The last two states require access to the user's lab/SIEM and cannot be established by repository edits alone.
