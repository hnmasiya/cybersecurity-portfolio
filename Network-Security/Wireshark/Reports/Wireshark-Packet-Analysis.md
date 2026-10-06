# Wireshark Network Traffic Analysis Report

## Objective

Document an authorized Wireshark/TShark packet-capture and analysis exercise against real traffic generated on the analyst's own home-lab host, with the original capture preserved as evidence.

## Skills & Tools

- Wireshark
- TShark
- Packet analysis
- Protocol analysis
- TCP/IP investigation
- HTTP traffic analysis
- Network security monitoring
- Evidence preservation
- SOC investigation
- Git

## Architecture

The capture was taken on loopback (`lo`) on the analyst's home-lab machine, targeting the project's own OWASP Juice Shop container (a deliberately vulnerable application already used elsewhere in this portfolio for authorized web-application testing). Real HTTP requests were generated against it, including one exercising Juice Shop's known SQL-injection-vulnerable product search endpoint.

## Topology

`Authorized analyst workstation (same host) -> tcpdump on loopback -> Juice Shop container (port 3000) -> capture -> pcap_soc_analyzer.py`

## Execution

```
sudo tcpdump -i lo -w juice-shop-capture.pcap 'tcp port 3000' &
curl -s "http://localhost:3000/"
curl -s "http://localhost:3000/rest/products/search?q=orange"
curl -s "http://localhost:3000/rest/products/search?q=%27%20OR%20%271%27%3D%271"
curl -s "http://localhost:3000/rest/user/whoami"
curl -s -A "scanner-test-agent" "http://localhost:3000/"
sudo kill <tcpdump-pid>
```

1. Started a `tcpdump` capture scoped to `tcp port 3000` on the loopback interface.
2. Generated 5 real HTTP requests: two benign (homepage, a normal product search), one deliberate SQL-injection-pattern test against Juice Shop's own search endpoint, one benign authenticated-style check, and one with a scanner-like `User-Agent` string.
3. Stopped the capture (52 packets total) and analyzed it with this portfolio's existing [`pcap_soc_analyzer.py`](../../PCAP-Analysis/Scripts/pcap_soc_analyzer.py) - the same script already validated against the synthetic `dvwa-soc-lab.pcap` in the PCAP-Analysis project.

## Walkthrough

- **Capture:** [`Evidence/juice-shop-capture.pcap`](../Evidence/juice-shop-capture.pcap), loopback interface, `tcp port 3000` filter, 52 packets.
- **Date/time:** 2026-08-26, 20:51 CAT.
- **Analysis command:**
  ```
  python3 Network-Security/PCAP-Analysis/Scripts/pcap_soc_analyzer.py Network-Security/Wireshark/Evidence/juice-shop-capture.pcap --output Network-Security/Wireshark/Evidence/
  ```
- **Result:** 5 HTTP requests analyzed, 1 flagged as suspicious.
- **Exported evidence:** [`Evidence/juice-shop-analysis.csv`](../Evidence/juice-shop-analysis.csv).

## Attack Simulation

The SQL-injection-pattern request (`?q=%27%20OR%20%271%27%3D%271`, which decodes to `' OR '1'='1`) is a real, deliberate test against Juice Shop's own known-vulnerable search endpoint - not a synthetic/mocked payload, and not run against anything other than this portfolio's own authorized test target.

## Detection

The analyzer flagged frame 24 (the SQLi-pattern request) as HIGH severity, score 3, reason "SQL-injection-like pattern" - triggered by the decoded URI containing `or '1'='1`. The scanner-UA request (frame with `User-Agent: scanner-test-agent`) was *not* flagged: the analyzer's scoring only awards +2 for a scanner-like UA alone, below its suspicious threshold of 3, so a weak indicator on its own correctly doesn't trigger an alert. This is the detection logic behaving as designed, not a miss.

## Triage

- Source/destination: both loopback (127.0.0.1), same host - self-testing, not third-party traffic.
- Timestamp: within the 2026-08-26 20:51 CAT capture window.
- Authorization: confirmed - own machine, own deliberately-vulnerable test application.
- Repeated vs. isolated: a single deliberate test request, not a repeated/automated pattern.

## Investigation

Correlating this with the earlier real Nmap scan of the same host: Juice Shop (port 3000) was independently confirmed reachable in that scan too, and its HTTP fingerprint in the Nmap output matches the same application. The two pieces of evidence corroborate each other rather than standing alone.

## Evidence

- [`Evidence/juice-shop-capture.pcap`](../Evidence/juice-shop-capture.pcap) - the real packet capture (52 packets).
- [`Evidence/juice-shop-analysis.csv`](../Evidence/juice-shop-analysis.csv) - the analyzer's exported findings.

## Findings

- 5 real HTTP requests captured and analyzed.
- 1 flagged as HIGH severity: the SQL-injection-pattern test against Juice Shop's product search endpoint.
- 4 correctly *not* flagged: two ordinary requests, one authenticated-style check, and the scanner-UA request (which carries a weak indicator by design, insufficient alone to cross the alert threshold).

## Impact

This confirms `pcap_soc_analyzer.py`'s detection logic - previously validated only against a synthetic PCAP - correctly discriminates real suspicious traffic from real benign traffic when given a genuine capture, including correctly declining to over-alert on a single weak indicator.

## Root Cause

Not applicable in the traditional sense - this is a validation exercise (does the analyzer work against real traffic?) rather than an incident investigation. The one "finding" (the SQLi-pattern request) was deliberately generated as a test, not discovered as an unexpected event.

## MITRE ATT&CK

- **T1040 - Network Sniffing** - the capture technique itself.
- **T1190 - Exploit Public-Facing Application** (contextual) - the SQL-injection-pattern test request maps to this technique category, though here it's an authorized test against a deliberately vulnerable app, not a real exploitation attempt.

## Remediation

Not applicable to this host - the "vulnerable" endpoint is Juice Shop's own intentional design (an OWASP training application), not a misconfiguration to fix.

## Validation

The analyzer's detection logic was validated against real traffic in this exercise, complementing its earlier synthetic-only validation in the PCAP-Analysis project. A future validation cycle could extend this to a longer capture window with more varied traffic (multiple protocols, more request types) to exercise more of the analyzer's scoring paths.

## Lessons Learned

- Real captured traffic against a real (if intentionally vulnerable) application is achievable without any new infrastructure - the project's own existing Juice Shop container was enough.
- Confirming a payload survived URL-encoding intact (`tshark -Y "http.request" -T fields -e http.request.uri`) before running the full analyzer caught nothing wrong here, but is a cheap, worthwhile sanity check before trusting a capture's contents.
- The analyzer correctly not-flagging the scanner-UA-only request is itself worth documenting - a detection system that never NOT-alerts isn't distinguishing real signal, and this is direct evidence that it does.

## Evidence Verification

- Capture file: [`Evidence/juice-shop-capture.pcap`](../Evidence/juice-shop-capture.pcap), 52 packets, confirmed via `tshark -r`.
- Capture scope: loopback, `tcp port 3000`, confirmed via the `tcpdump` command used.
- Source/destination: 127.0.0.1 both directions (loopback).
- Extracted application-layer information: verified via `tshark -Y "http.request" -T fields -e http.request.uri` before running the analyzer, confirming the SQLi payload was captured intact.
- Analyzer output: [`Evidence/juice-shop-analysis.csv`](../Evidence/juice-shop-analysis.csv), matching the console output shown above.

## Recommendations

Extend this exercise with a longer, more varied capture (e.g. alongside a fuller DVWA or Juice Shop test pass) to exercise more of `pcap_soc_analyzer.py`'s scoring paths (command-injection patterns, sensitive-file access patterns) against real rather than synthetic traffic.

The separate `Network-Security/PCAP-Analysis` project's synthetic `dvwa-soc-lab.pcap` remains a complementary, distinct evidence set (broader synthetic scenario coverage) rather than being superseded by this smaller, real capture.
