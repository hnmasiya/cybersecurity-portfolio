# Windows / Sysmon Endpoint Detection Lab

> **Evidence classification: Real telemetry + synthetic validation**

This project validates endpoint detection logic against controlled synthetic events and real Sysmon/Windows Security telemetry captured from the deployed Azure Windows Server lab.

## Detection Scenarios

- Suspicious PowerShell
- PowerShell network connection
- Failed Windows authentication
- PowerShell child process

## Validation

Synthetic validation:

```bash
python3 Scripts/offline_endpoint_validator.py
```

Real-data analysis uses the same detection logic against stored telemetry from the Azure lab. The real dataset is analyzed without pre-labeled ground truth, so findings are reported as observations and then investigated for context.

## Real Telemetry Result

The documented capture contains **16 events and 5 findings (0 high, 5 medium)**:

- `EDR-004 ×1` — `notepad.exe` spawned by `powershell.exe`; deliberate test activity.
- `EDR-002 ×3` — PowerShell outbound HTTPS connections associated with the session's `Invoke-WebRequest` activity used to obtain Sysmon/configuration.
- `EDR-003 ×1` — a failed Windows logon already represented in the Active Directory detection dataset.

No malicious activity was identified in this capture. The value of the exercise is demonstrating that detection findings require context and investigation rather than automatic escalation.

## Evidence

- `Data/` — test/telemetry inputs
- `Evidence/` — validation and analysis outputs
- `Rules/` — detection logic
- `Reports/` — supporting analysis
- `Scripts/` — synthetic and real-data analyzers

## Wazuh Integration

The same endpoint is documented as connected to the portfolio's Wazuh Manager over a private Tailscale network. Wazuh-generated findings are documented separately in the Azure Windows Server lab rather than being conflated with this offline analyzer's results.

## Analyst Takeaway

A useful endpoint detector should identify suspicious behavior while allowing an analyst to distinguish malicious activity from legitimate administrative actions. This lab therefore preserves both the detection result and the contextual explanation.

## Limitations

The real capture is a small lab dataset, not an enterprise-scale endpoint dataset. Absence of malicious activity in the capture is not evidence that the detector would identify every malicious technique. Broader validation requires additional authorized attack simulations, benign baselines and live SIEM correlation.
