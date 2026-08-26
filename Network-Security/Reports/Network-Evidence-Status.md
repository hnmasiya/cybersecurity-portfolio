# Network Security Evidence Status

## Nmap

The active Nmap project now contains a real, preserved scan.

`sudo nmap -sV -sC -p- -oA home-lab-scan localhost` was run against the analyst's own home-lab host (full TCP port range, service/version detection, default scripts), discovering 13 real open ports. Raw output is preserved in all three Nmap formats under `Network-Security/Nmap/Evidence/`. See [`Reports/Nmap-Network-Reconnaissance.md`](../Nmap/Reports/Nmap-Network-Reconnaissance.md) for the full write-up, including an anomaly (an unrecognized service fingerprint on port 9443) that was independently verified with `curl`/`ss` rather than assumed.

## Wireshark

The active Wireshark project is also evidence-bounded.

The stronger packet-analysis evidence currently resides in the dedicated PCAP Network Security Monitoring project, which contains an actual PCAP, derived evidence files and reproducible analysis.

## Relationship to PCAP Analysis

The PCAP project provides the strongest currently preserved network-traffic evidence:

- PCAP file
- protocol hierarchy
- HTTP request evidence
- suspicious request evidence
- TCP conversation evidence
- automated analysis output
- reproducible analysis script

## Publication Principle

Nmap and Wireshark methodology projects remain published because they demonstrate security-analysis knowledge, but exact scan or packet observations are only claimed where matching evidence exists.
