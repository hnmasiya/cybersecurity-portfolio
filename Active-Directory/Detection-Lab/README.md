# Active Directory Security Event Detection Lab

> **Evidence classification: Real telemetry + synthetic validation**

This lab analyzes Windows Security events for common identity and privilege-related security signals. It uses both controlled synthetic records and real telemetry exported from the deployed Azure Domain Controller.

## Detection Coverage

- Repeated failed authentication — Event ID `4625`
- Kerberos pre-authentication failure burst — `4771`
- Possible Kerberoasting indicators — `4769`
- Privileged group membership changes — `4728`, `4732`, `4756`
- New user account creation — `4720`
- Special privileges assigned to a new logon — `4672`
- Security audit log cleared — `1102`

Each analytic is mapped to relevant MITRE ATT&CK context in the supporting analysis.

## Validation

Synthetic data:

```bash
python3 Scripts/ad_security_event_analyzer.py --input Data/synthetic-ad-events.json --output Evidence/ad-analysis.json
```

Real telemetry:

```bash
python3 Scripts/ad_security_event_analyzer.py --input ../../Cloud-Security/Azure-Windows-Server-Lab/Evidence/raw-security-events.json --output ../../Cloud-Security/Azure-Windows-Server-Lab/Evidence/real-ad-analysis.json
```

The real capture contains **409 Windows Security events and 392 findings**. Those findings are deliberately retained and investigated rather than presented as proof of compromise.

## Real-Data Triage

The documented results include:

- 375 medium findings dominated by `SYSTEM`, machine-account and normal service/interactive activity.
- 16 high findings associated largely with the AD DS forest-promotion process and resulting group changes.
- 1 critical audit-log-cleared finding associated with lab configuration/promotion activity rather than a confirmed attacker action.

This demonstrates an important SOC skill: **detection output is an investigation starting point, not a verdict**.

## Evidence

- `Data/synthetic-ad-events.json` — controlled test input
- `Evidence/ad-analysis.json` — synthetic analysis
- Azure lab `Evidence/raw-security-events.json` — real Windows Security telemetry
- Azure lab `Evidence/real-ad-analysis.json` — real-data analysis
- `Scripts/ad_security_event_analyzer.py` — detection/analysis logic

## Analyst Workflow

**Event → analytic match → account/host context → related activity → benign explanation or escalation → documented finding**

## Limitations

The real dataset is from a controlled personal lab and is not representative of enterprise volume or attacker diversity. Findings are therefore suitable as portfolio evidence of detection analysis and triage methodology, not as proof of production incident-response experience.
