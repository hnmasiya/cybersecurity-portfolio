# Phase 2 Findings

Run ID: 20260924T132530Z

## Scope

Target:
127.0.0.1

TCP port:
8765

Capture method:
tshark

## Evidence

- nmap-localhost.txt
- http-response.html
- http-response-headers.txt
- localhost-http.pcap
- localhost-http.pcap.sha256
- protocol-hierarchy.txt
- http-fields.tsv
- frame-protocols.tsv
- capture-metadata.txt
- http-server.log

## Security Context

The activity is intentionally restricted to localhost.

Relevant ATT&CK context:
- T1046 — Network Service Scanning
- Network traffic analysis supports detection and investigation workflows.

## Evidence Integrity

The PCAP is hashed with SHA-256.
