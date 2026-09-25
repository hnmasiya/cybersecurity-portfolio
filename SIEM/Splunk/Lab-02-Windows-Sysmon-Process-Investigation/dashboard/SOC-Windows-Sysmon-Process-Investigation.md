# SOC Windows / Sysmon Process Investigation Dashboard

## Dashboard ID

`soc_windows_sysmon_process_investigation`

## Data source

- Index: `splunk_lab_sysmon`
- Sourcetype: `splunk:lab:sysmon`
- Telemetry: synthetic Windows Sysmon Event ID 1 process creation

## Planned panels

1. Total Process Creation Events
2. PowerShell Activity
3. Suspicious Process / Command-Line Events
4. Top Processes
5. Top Parent → Child Relationships
6. Suspicious Process Timeline
7. Investigation Events Table

## Lab relationship

This dashboard extends the investigation workflow established in:

**Splunk Lab 01 — SSH Authentication Threat Hunting**

Lab 01 focused on authentication source/account relationships and timeline analysis.

Lab 02 moves from authentication telemetry into endpoint process telemetry, allowing the analyst to investigate what execution occurred on a Windows host.

## Validation

The dashboard must be visually reviewed in Splunk before screenshot evidence is marked complete.
