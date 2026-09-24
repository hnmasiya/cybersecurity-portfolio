# Phase 2 — Network Reconnaissance & Packet Investigation

Scope: local loopback only (`127.0.0.1`).

Objectives:
- Identify a controlled local HTTP service with Nmap.
- Generate controlled HTTP traffic.
- Capture packets with TShark, with tcpdump as fallback.
- Extract protocol and HTTP evidence.
- Correlate service, request and packet capture.
- Hash the resulting evidence.

Safety:
- Only `127.0.0.1` is used.
- No third-party target is scanned.
- The service is created by this run and is stopped by cleanup.
