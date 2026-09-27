# Security Information and Event Management (SIEM) Lab Operations

## Overview

This directory contains architectural documentation, ingestion configurations, investigation reports, and controlled SIEM exercises. The portfolio separates synthetic training telemetry from live authorized environments.

## Active modules

- **[Wazuh SIEM](./Wazuh/)** — host intrusion monitoring, alert triage, detection rules and security-event analysis.
- **[Splunk SOC Lab Track](./Splunk/)** — six connected SOC labs covering authentication hunting, endpoint investigation, web investigation, detection engineering, SOC monitoring and end-to-end incident investigation.

## SIEM progression

```text
Wazuh
  ↓
Splunk
  ↓
Microsoft Sentinel + Microsoft Defender XDR  ← next planned track
```

This is a skills progression across different enterprise security stacks, not a claim that the platforms share the same telemetry or configuration.

## Evidence classification

- **Executed / controlled:** searches and investigations actually run in an authorized local lab using synthetic telemetry.
- **Preparation:** datasets, methodology or lab design not yet executed.
- **Live:** telemetry from an authorized real environment.
- **Screenshots:** included only where genuinely captured; they are supplementary evidence rather than fabricated completion evidence.

## Splunk validation

Labs 03–06 currently have validated event counts of **15 + 6 + 24 + 6 = 51** across their dedicated lab indexes. See [SIEM/Splunk/README.md](./Splunk/README.md) for the complete track and evidence boundaries.
