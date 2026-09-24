# Splunk SOC Lab Track

## Purpose

Build evidence-backed Splunk skills for Security Operations, threat hunting, investigation, detection engineering, and analyst reporting.

## Evidence policy

The portfolio separates:

- **Preparation** — lab design and synthetic datasets
- **Executed / controlled** — searches and results actually run in Splunk
- **Live** — telemetry from an authorized real environment
- **Methodology** — documented approaches not yet executed

Splunk labs must not be marked complete based only on documentation. Execution evidence is required.

## Lab roadmap

| Lab | Focus | Status |
|---|---|---|
| 01 | SSH authentication threat hunting | In progress — synthetic dataset prepared |
| 02 | Windows / Sysmon process investigation | Planned |
| 03 | Web attack / HTTP investigation | Planned |
| 04 | Detection engineering and SPL-based alert logic | Planned |
| 05 | Dashboarding and SOC monitoring | Planned |
| 06 | End-to-end SOC investigation and incident report | Planned |

## Directory layout

```text
SIEM/Splunk/
├── README.md
└── Lab-01-SSH-Authentication-Hunting/
    ├── README.md
    ├── data/
    │   └── auth_events.csv
    ├── spl/
    │   └── authentication-hunting.spl
    └── evidence/
        └── README.md
```
