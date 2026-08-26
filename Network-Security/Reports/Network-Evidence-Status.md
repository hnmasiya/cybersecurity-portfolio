# Network Security Evidence Status

## Nmap

The active Nmap project now contains a real, preserved scan.

`sudo nmap -sV -sC -p- -oA home-lab-scan localhost` was run against the analyst's own home-lab host (full TCP port range, service/version detection, default scripts), discovering 13 real open ports. Raw output is preserved in all three Nmap formats under `Network-Security/Nmap/Evidence/`. See [`Reports/Nmap-Network-Reconnaissance.md`](../Nmap/Reports/Nmap-Network-Reconnaissance.md) for the full write-up, including an anomaly (an unrecognized service fingerprint on port 9443) that was independently verified with `curl`/`ss` rather than assumed.

## Wireshark

The active Wireshark project now contains a real, preserved packet capture.

A `tcpdump` capture on loopback (`tcp port 3000`) recorded 5 real HTTP requests against the project's own Juice Shop container, including a genuine test of Juice Shop's known SQL-injection-vulnerable search endpoint. This portfolio's existing `pcap_soc_analyzer.py` (previously validated only against a synthetic PCAP) was run against the real capture and correctly flagged the SQLi-pattern request while correctly not flagging weaker/benign signals. See [`Reports/Wireshark-Packet-Analysis.md`](../Wireshark/Reports/Wireshark-Packet-Analysis.md) for the full write-up.

## Relationship to PCAP Analysis

The dedicated PCAP Network Security Monitoring project provides broader synthetic scenario coverage:

- PCAP file
- protocol hierarchy
- HTTP request evidence
- suspicious request evidence
- TCP conversation evidence
- automated analysis output
- reproducible analysis script

The Wireshark project's real capture is a smaller, complementary evidence set - real traffic rather than synthetic, but narrower in scenario coverage - not a replacement for the PCAP project's broader synthetic scenarios.

## Publication Principle

Nmap and Wireshark projects remain published, and now both are backed by real, preserved evidence rather than methodology alone - exact scan or packet observations are only claimed where matching evidence exists, and now do exist for both.
