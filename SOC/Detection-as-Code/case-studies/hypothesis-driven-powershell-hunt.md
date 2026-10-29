# Hypothesis-Driven Hunt: Encoded PowerShell Process Activity

**Evidence state:** REPRODUCIBLE LAB PLAN; synthetic fixtures available. No live endpoint or production hunt is claimed.

## Hypothesis

A Windows process-creation event showing PowerShell with an encoded-command switch may indicate obfuscated script execution that warrants investigation. This signal alone is not proof of malicious activity.

## Scope and data required

- Source: normalized Windows process-creation events (for example, Sysmon Event ID 1 where configured).
- Required fields: timestamp, host, user, image, command line, parent image and process identifier.
- ATT&CK hypothesis: PowerShell execution (T1059.001); obfuscation (T1027) only when the observed evidence supports it.
- Dataset: repository synthetic fixtures under `../fixtures/synthetic-process-events.json`.

## Hunt procedure

1. Confirm the endpoint telemetry source is enabled and command-line data is collected.
2. Search for PowerShell or pwsh process events whose command line contains `-enc` or `-EncodedCommand`.
3. Enrich each match with parent process, user, host criticality, process signer, initiating process and surrounding activity where available.
4. Compare with approved administration scripts, software deployment, IT automation and known maintenance windows.
5. Check for corroborating signals: unusual parent-child chains, unexpected network connections, persistence changes or follow-on process activity.
6. Record a conclusion as supported, not supported, or inconclusive, with links to the specific evidence.
7. Tune the detection only after a documented benign example is understood; rerun positive and negative regression tests.

## Splunk SPL starter query

Adapt index, sourcetype and field names to the actual environment; this query is not asserted to have been run against a live Splunk instance.

```spl
index=<windows_index> (EventCode=1 OR EventID=1)
(Image="*\\powershell.exe" OR Image="*\\pwsh.exe")
(CommandLine="*-enc *" OR CommandLine="*-EncodedCommand *")
| table _time host User Image ParentImage CommandLine ProcessGuid
| sort - _time
```

## Wazuh / Sysmon investigation notes

Use the actual event fields produced by the deployed agent and decoder. Confirm that command-line collection is enabled before assuming the absence of matching events means the activity did not occur. Document agent coverage, ingestion delay and parsing gaps.

## Test design

- Positive: synthetic encoded PowerShell event (SYN-001).
- Negative controls: benign Notepad event (SYN-004) and standard non-encoded PowerShell script execution (SYN-005).
- Related process patterns (MSHTA and Rundll32) are tested separately by the companion Python harness.
- A passing synthetic test demonstrates rule behavior on that fixture only; it does not establish detection efficacy in production.

## Hunt report record

| Field | Record |
|---|---|
| Hypothesis | Encoded PowerShell process activity may merit investigation |
| Evidence source | Synthetic fixture / authorized endpoint telemetry when available |
| Result | Pending execution against a documented dataset |
| Limitations | Command-line string matching can be evaded and can produce benign matches |
| Next action | Correlate parent, user, host, signer, network and surrounding process activity |

## Evidence integrity

Do not populate findings, alert counts, precision, dwell time or incident conclusions until the hunt has actually been run and its evidence retained. Do not label a synthetic event as a real incident.
