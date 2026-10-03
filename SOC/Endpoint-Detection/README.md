# Endpoint Detection & Response

## Purpose

This area consolidates the portfolio's Windows endpoint security evidence around an EDR/SOC investigation model.

The primary evidence source is the deployed Azure Windows Server 2022 lab, which has retained:
- Windows Security telemetry
- Sysmon telemetry
- Wazuh agent connectivity
- Wazuh-generated alerts
- PowerShell automation
- Active Directory telemetry
- endpoint detection analysis

## Endpoint detection workflow

```
Windows endpoint
      |
      ├──→ Security Events
      ├──→ Sysmon
      ├──→ Windows Defender
      |
      v
Wazuh collection
      |
      v
Detection
      |
      v
Triage
      |
      v
Process + user + host + network investigation
      |
      v
MITRE ATT&CK
      |
      v
Response
```

## Existing real evidence

See: `Cloud-Security/Azure-Windows-Server-Lab/Evidence/`

Important retained artifacts include:
- `raw-security-events.json`
- `raw-sysmon-events.json`
- `real-ad-analysis.json`
- `real-sysmon-analysis.json`
- `wazuh-agent-connection.txt`
- `wazuh-dashboard-agent-active.jpg`

## What the evidence demonstrates

The Azure lab provides real endpoint telemetry and demonstrates the ability to interpret detections in context rather than treating every alert as malicious.

The retained Sysmon analysis identified explainable activity including:
- PowerShell process/network activity
- controlled `notepad.exe` child process
- failed authentication event

These findings were tied back to the administrator's actual lab activity.

## EDR positioning

This portfolio demonstrates endpoint detection concepts and real Windows/Sysmon telemetry.

It does **not** claim production experience operating a commercial EDR platform such as CrowdStrike, SentinelOne or Microsoft Defender for Endpoint unless that platform has actually been used and evidenced.

## Analyst workflow

**Alert → host identification → user → process → parent process → command line → network → timeline → ATT&CK → scope → response → tuning**
