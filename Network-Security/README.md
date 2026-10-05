# Network Security

> **Evidence classification: Hands-on lab analysis**

This section contains network reconnaissance and traffic-analysis work focused on identifying exposed services, interpreting network behavior and extracting useful security context.

## Focus Areas

- Nmap reconnaissance and service enumeration
- Wireshark / tshark traffic analysis
- PCAP-based investigation
- IOC extraction
- Protocol and connection analysis
- Network-security reporting

## Analyst Workflow

**Scope → enumerate → capture/inspect traffic → identify anomalies → extract indicators → correlate context → document findings**

## Evidence

Project-specific evidence, scripts and reports are retained within the corresponding subdirectories. Results should be interpreted in the context of the controlled lab environment rather than as production network-monitoring evidence.

## SOC Relevance

Network telemetry is useful for validating endpoint alerts, identifying suspicious destinations, investigating reconnaissance and building incident timelines. The portfolio emphasizes that network indicators should be correlated with host, user and authentication context before escalation.

## Responsible Use

Reconnaissance and traffic analysis are performed only against systems and networks authorized for testing.
