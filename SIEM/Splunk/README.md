# Splunk SOC Lab Track

## Purpose

Build evidence-backed Splunk skills for Security Operations, threat hunting, investigation, detection engineering, SOC monitoring, and incident reporting.

## Evidence policy

The portfolio separates:

- **Preparation** — lab design and synthetic datasets
- **Executed / controlled** — searches and results actually run in an authorized local Splunk instance
- **Live** — telemetry from an authorized real environment
- **Methodology** — documented approaches not yet executed

Synthetic training telemetry is never presented as customer, employer, or production telemetry.

## Lab progression

**Authentication Hunting → Endpoint Investigation → Web Investigation → Detection Engineering → SOC Monitoring → End-to-End Incident Investigation**

| Lab | Focus | Status | Evidence |
|---|---|---|---|
| 01 | SSH authentication threat hunting | **Executed** | Synthetic telemetry, SPL, investigation report and retained evidence |
| 02 | Windows / Sysmon process investigation | **Executed** | Synthetic Sysmon telemetry, SPL, investigation/report artifacts |
| 03 | Web attack / HTTP investigation | **Executed** | 15 validated synthetic events, SPL and investigation report |
| 04 | Detection engineering / SPL alert logic | **Executed** | 6 validated synthetic events, detection rules and validation report |
| 05 | Dashboarding / SOC monitoring | **Executed** | 24 validated synthetic SOC-metric events and monitoring artifacts |
| 06 | End-to-end SOC investigation | **Executed / controlled** | 6 validated synthetic case events, SPL and incident report |

## Validation summary

Labs 03–06 were independently validated against the rebuilt Splunk indexes:

| Lab | Index | Sourcetype | Validated events |
|---|---|---|---:|
| 03 | `splunk_lab_web` | `splunk:lab:web` | 15 |
| 04 | `splunk_lab_detection` | `splunk:lab:detection` | 6 |
| 05 | `splunk_lab_monitoring` | `splunk:lab:socmetrics` | 24 |
| 06 | `splunk_lab_case` | `splunk:lab:case` | 6 |
| **Total** | | | **51** |

Validation included independent `tstats` counts, raw searches, and required-field checks.

## Lab-to-lab relationship

### Lab 01 → Lab 02

Authentication telemetry establishes source/account analysis and timeline reconstruction. Lab 02 extends that methodology into Windows endpoint telemetry:

**Authentication → Endpoint → Process → Detection → Investigation**

### Lab 02 → Lab 03

The investigation moves from host/process telemetry to application-layer HTTP activity, expanding the analyst's ability to investigate different telemetry sources.

### Lab 03 → Lab 04

Web attack observations become the foundation for detection engineering: identify suspicious behavior, express detection logic in SPL, and validate the rule against controlled telemetry.

### Lab 04 → Lab 05

Validated detections feed SOC monitoring. Lab 05 introduces aggregation, time-series monitoring and dashboard-oriented operational visibility.

### Lab 05 → Lab 06

Monitoring becomes an end-to-end investigation workflow. Lab 06 combines telemetry review, event sequencing, investigation logic and incident reporting.

## Enterprise SIEM progression

The portfolio now demonstrates experience across two SIEM approaches:

**Wazuh → Splunk**

The next planned platform is:

**Microsoft Sentinel + Microsoft Defender XDR**

The Sentinel/Defender work will be developed as a separate lab track using KQL, analytics rules, incident investigation, endpoint/XDR telemetry and response automation. It is **planned, not yet claimed as completed**.

## Directory layout

```text
SIEM/
├── Wazuh/
└── Splunk/
    ├── README.md
    ├── Lab-01-SSH-Authentication-Hunting/
    ├── Lab-02-Windows-Sysmon-Process-Investigation/
    ├── Lab-03-Web-Attack-HTTP-Investigation/
    ├── Lab-04-Detection-Engineering-SPL-Alert-Logic/
    ├── Lab-05-Dashboarding-SOC-Monitoring/
    ├── Lab-06-End-to-End-SOC-Investigation/
    └── labs-03-06-manifest.json
```

## Evidence and screenshots

Screenshots are retained where they were genuinely captured and are not fabricated.

For Labs 03–06, completion was validated through the actual Splunk ingestion/search pipeline, independent count checks, required-field checks, SPL artifacts and reports. A screenshot is therefore not claimed where one was not captured.

Where a lab's documentation contains an unchecked screenshot item, it remains unchecked until a genuine visual capture is made.

## Recruiter view

This track demonstrates:

- SPL search and aggregation
- Authentication threat hunting
- Windows/Sysmon process investigation
- Web attack investigation
- Detection engineering
- Alert logic validation
- SOC monitoring and dashboard concepts
- Timeline reconstruction
- Incident investigation and reporting
- Evidence boundaries and reproducibility

## Next platform

**Microsoft Sentinel + Microsoft Defender XDR**

The next lab series will focus on KQL threat hunting, Microsoft security telemetry, analytics rules, incidents, Defender XDR integration and controlled response automation.
