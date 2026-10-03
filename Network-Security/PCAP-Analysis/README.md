# Network Security Monitoring — PCAP Analysis

This project demonstrates a reproducible SOC workflow using packet capture, protocol analysis, detection engineering, IOC extraction, and incident investigation.

## Workflow
Packet Capture -> Protocol Analysis -> IOC Extraction -> Detection -> Triage -> Investigation -> Reporting

## Evidence
Primary evidence:
`Data/dvwa-soc-lab.pcap`

Derived evidence:
`Evidence/`

## Automation
`Scripts/pcap_soc_analyzer.py` analyzes HTTP traffic from the PCAP and produces `Evidence/automated-analysis.csv`.

## Safety
All traffic was generated locally against `127.0.0.1:18080`. `malicious.example.test` is a synthetic laboratory hostname. No external malicious infrastructure was contacted.

## Skills Demonstrated
- tcpdump
- Wireshark/tshark
- Python
- HTTP analysis
- Network monitoring
- IOC extraction
- Detection engineering
- SOC triage
- Incident investigation
- Evidence preservation
