# Live LSASS Process-Access Detection — Sysmon → Wazuh

**Evidence classification:** OBSERVED / LIVE
**Environment:** Controlled laboratory
**Endpoint:** `dc01-lab.lab.local`
**Wazuh agent:** `003` (`dc01-lab`)
**Detection rule:** `100312`
**MITRE ATT&CK:** `T1003.001` — LSASS Memory
**Sysmon event:** Event ID `10` — Process Access
**Observed UTC:** `2026-08-30 08:35:23.419` and `2026-08-30 08:35:30.544`

## Evidence Summary

A controlled PowerShell test opened a handle to the Windows LSASS process using `OpenProcess` with desired access `0x1010`. Sysmon recorded Event ID 10 for the access, and Wazuh received the event through the Windows Event Channel collector and generated a level-13 alert using custom rule `100312`.

The same test was independently observed on the Windows endpoint before confirming the corresponding Wazuh records.

## Endpoint Evidence

| Field | Observed value |
|---|---|
| Host | `dc01-lab.lab.local` |
| Account | `LAB\\hazvinei` |
| Source process | `C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe` |
| Source PID | `6956` |
| Target process | `C:\\Windows\\system32\\lsass.exe` |
| Target PID | `716` |
| Granted access | `0x1010` |
| Sysmon Event ID | `10` |
| Event Record IDs | `17575`, `17580` |

## Wazuh Evidence

Wazuh archived the Sysmon Event ID 10 records and generated alerts with:

- **Rule:** `100312`
- **Level:** `13`
- **Description:** `Credential Access: Process access targeting LSASS`
- **ATT&CK:** `T1003.001`
- **Tactic:** Credential Access
- **Technique:** LSASS Memory
- **Agent:** `003 / dc01-lab`

The Wazuh archive search identified **2 matching PowerShell → LSASS events** from the controlled test.

## Detection Logic

The validated custom rule correlates Sysmon Event ID 10 with:

1. a target image ending in `lsass.exe`, and
2. a source process matching administrative/process-access tooling such as PowerShell, command shell, Task Manager, ProcDump or Rundll32.

The live test matched the PowerShell condition and produced the expected Wazuh detection.

## Analyst Investigation

### Why this was investigated

Process access to LSASS is security-relevant because LSASS maintains sensitive authentication material. A process requesting memory/query access to LSASS can therefore warrant investigation, particularly when the source process is an interactive shell or other tooling commonly associated with credential-access activity.

### Evidence supporting the hypothesis

The observed chain was:

`PowerShell → OpenProcess(LSASS, 0x1010) → Sysmon Event 10 → Wazuh Rule 100312 → Level 13 alert`

The source account was `LAB\\hazvinei`, and the target was the SYSTEM-owned `lsass.exe` process on the laboratory domain controller.

### Alternative explanation

This was an intentional controlled laboratory test, not a real-world compromise. Legitimate administrative or security software can also access LSASS. In fact, the endpoint telemetry showed Microsoft Defender (`MsMpEng.exe`) performing a similar `0x1010` access. Therefore, source process, user, timing, and surrounding telemetry must be considered before escalating an alert.

### Persistence / lateral movement / command-and-control

No persistence, lateral movement, or command-and-control activity is established by this evidence. The retained evidence supports the process-access detection only.

### Credential access assessment

The telemetry demonstrates **LSASS process access**, not successful credential extraction. The evidence therefore supports mapping the behavior to `T1003.001` as a detection/investigation technique, but does not establish that credentials were dumped.

## Response

No containment or eradication action was performed because this was a controlled validation test. The appropriate analyst response in a real environment would be to validate the initiating process and user, correlate surrounding authentication/process/network telemetry, determine whether the activity is authorized, and contain the endpoint if malicious credential-access behavior is confirmed.

## Detection Validation Result

**PASS — live telemetry reached Wazuh and triggered the intended custom detection.**

This artifact is evidence of a controlled laboratory validation and must not be represented as professional employment experience or as evidence of a real-world breach.
