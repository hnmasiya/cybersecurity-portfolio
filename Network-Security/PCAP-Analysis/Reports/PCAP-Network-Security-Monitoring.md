# PCAP Network Security Monitoring & Incident Investigation

## Objective
Analyze a controlled packet capture generated in the local cybersecurity laboratory and demonstrate a repeatable SOC workflow covering packet capture, protocol analysis, suspicious-activity detection, IOC extraction, triage, investigation, and reporting.

## Skills & Tools
- tcpdump
- Wireshark / tshark
- Python
- HTTP analysis
- Network traffic analysis
- IOC extraction
- Detection engineering
- SOC triage
- Incident investigation
- Evidence preservation
- Git

## Architecture
A controlled HTTP service was hosted on `127.0.0.1:18080`. Traffic was generated locally, captured on the loopback interface, and analyzed with tshark and a Python detection script.

## Topology
`SOC workstation -> local HTTP client -> 127.0.0.1:18080 -> loopback capture -> PCAP -> tshark/Python analysis`

## Execution
A normal baseline request and three synthetic suspicious HTTP requests were generated against the local test service. tcpdump captured the traffic into `Data/dvwa-soc-lab.pcap`.

The capture contained 51 packets and tcpdump reported zero packets dropped by the kernel.

## Walkthrough
1. Verified tcpdump, tshark, Python, and curl.
2. Created the controlled HTTP service.
3. Started tcpdump on `lo`.
4. Generated one normal request.
5. Generated three suspicious-looking requests.
6. Stopped the capture.
7. Extracted HTTP requests with tshark.
8. Extracted host, URI, and User-Agent indicators.
9. Ran the Python SOC analyzer.
10. Preserved the PCAP and derived evidence.

## Attack Simulation
The suspicious requests were synthetic laboratory scenarios representing:
- Command-execution input
- SQL-injection-like input
- Sensitive-file access

The hostname `malicious.example.test` is a fabricated laboratory IOC. No external malicious infrastructure was contacted.

## Detection
The automated detector scores requests using:
- Suspicious host correlation
- Command-execution patterns
- SQL-injection-like patterns
- Sensitive-file paths
- Scanner-like User-Agent values

Detected events:

| Frame | Severity | Score | Detection |
|---|---|---:|---|
| 16 | HIGH | 8 | Command-execution pattern + scanner UA |
| 29 | HIGH | 6 | SQL-injection-like pattern |
| 42 | HIGH | 8 | Sensitive-file pattern + scanner UA |

## Triage
The three suspicious requests were escalated as high-priority simulated alerts because they contained independent application-layer attack indicators and shared the same synthetic host.

## Investigation
The investigation correlated:
- Frame number
- Source and destination IP
- TCP ports
- Host header
- Request URI
- User-Agent
- Referer

The normal request provided a baseline for comparison.

## Evidence
Primary evidence:
- `Data/dvwa-soc-lab.pcap`
- `Evidence/capture-info.txt`
- `Evidence/http-requests.txt`
- `Evidence/protocol-hierarchy.txt`
- `Evidence/tcp-conversations.txt`
- `Evidence/hosts.txt`
- `Evidence/request-uris.txt`
- `Evidence/user-agents.txt`
- `Evidence/suspicious-requests.txt`
- `Evidence/automated-analysis.csv`

## Findings
The capture contained:
- 51 packets
- 4 HTTP requests
- 1 normal baseline request
- 3 suspicious requests
- 0 kernel packet drops

The Python analyzer independently reproduced detection of all three suspicious requests.

## Impact
In a production environment, comparable traffic could indicate reconnaissance or exploitation attempts against a web application.

This laboratory exercise did not compromise a production system because all traffic was generated locally.

## Root Cause
The suspicious activity was intentionally generated for security-monitoring training. There is therefore no real-world compromise root cause.

## MITRE ATT&CK
Potential contextual mappings:
- T1595 — Active Scanning
- T1190 — Exploit Public-Facing Application

These mappings provide analytical context only and do not represent attribution.

## Remediation
Recommended production controls include:
- Web application firewall protections
- IDS/IPS monitoring
- Centralized web-server logging
- HTTP anomaly detection
- IOC correlation
- Network/application telemetry correlation
- Alerting on repeated suspicious requests

## Validation
The workflow was validated by capturing the traffic, extracting HTTP requests, establishing a baseline, identifying three suspicious requests, extracting indicators, and reproducing the findings through Python automation.

## Lessons Learned
This project demonstrates the SOC workflow:
`Packet Capture -> Protocol Analysis -> IOC Extraction -> Detection -> Triage -> Investigation -> Reporting`

It also demonstrates the value of keeping both original packet evidence and reproducible detection logic.

## Recommendations
Extend the project with additional controlled scenarios involving DNS anomalies, simulated scanning, authentication failures, unusual HTTP status codes, and multi-stage alert correlation.
