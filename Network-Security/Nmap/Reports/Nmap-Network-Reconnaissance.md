# Nmap Network Reconnaissance Report

## Objective

Document an authorized Nmap network-reconnaissance exercise against a real, self-owned laboratory host, with the raw scan output preserved as evidence.

## Skills & Tools

- Nmap
- Network reconnaissance
- Host discovery
- Port scanning
- Service enumeration
- Network security assessment
- Evidence preservation
- Risk assessment
- Git

## Architecture

The target is the analyst's own home-lab machine (Zorin OS, the same host running the project's Docker-based SIEM/Wazuh stack, DVWA/Juice Shop labs, Portainer, and RustDesk). The scan was run locally against `localhost` (127.0.0.1) - a fully authorized, self-owned target, not a third party or production system.

## Topology

`Authorized assessment host (same machine) -> Nmap -> localhost (127.0.0.1)`

## Execution

```
sudo nmap -sV -sC -p- -oA home-lab-scan localhost
```

- **Scope:** full TCP port range (1-65535), all interfaces reachable via loopback.
- **Techniques:** `-sV` (service/version detection), `-sC` (default NSE scripts).
- **Date/time:** 2026-08-26, 20:37 CAT.
- **Duration:** 120.10 seconds.
- Raw output preserved in all three Nmap formats: [`Evidence/home-lab-scan.nmap`](../Evidence/home-lab-scan.nmap) (human-readable), [`Evidence/home-lab-scan.xml`](../Evidence/home-lab-scan.xml) (structured), [`Evidence/home-lab-scan.gnmap`](../Evidence/home-lab-scan.gnmap) (grepable).

## Walkthrough

13 open TCP ports were discovered out of 65535 scanned (65522 closed/reset):

| Port | Service | Detail |
|---|---|---|
| 80 | http | Apache httpd 2.4.58 (Ubuntu default page) |
| 443 | https | Wazuh Dashboard (real TLS cert, CN=wazuh.dashboard) |
| 631 | ipp | CUPS 2.4 (printing) |
| 1514 | - | Wazuh Manager agent event port |
| 1515 | ssl | Wazuh Manager agent enrollment port (real TLS cert, CN=wazuh.manager) |
| 1716 | - | KDE Connect / GSConnect (desktop-to-phone integration) |
| 3000 | http | OWASP Juice Shop |
| 3001 | http | Wireshark web UI (nginx) |
| 3306 | mysql | MariaDB 10.11.14 |
| 9200 | https | Wazuh Indexer / OpenSearch (real TLS cert, CN=wazuh.indexer, HTTP Basic auth required) |
| 9443 | https | Portainer (confirmed via direct `curl` - Nmap's generic HTTP probe didn't recognize the fingerprint) |
| 44433 | http | unrecognized service, returns bare 404/400 JSON-less responses |
| 55000 | - | Wazuh API |

Nmap's own service-fingerprint database didn't recognize 6 of these (1514, 1515, 3000, 9200, 9443, 44433) despite getting real response data back - each was cross-checked against `docker ps` and, for port 9443, directly verified with `curl` (see Investigation below) rather than left as an unverified guess.

## Attack Simulation

No attack was simulated. This was passive reconnaissance (port/service enumeration) against a self-owned host, not an exploitation attempt.

## Detection

Nmap activity from `-sV -sC -p-` against a host would be visible in that host's own connection logs and, for services with logging enabled, application-level access logs. This scan was not deliberately evaded or obfuscated - it used default timing and full-range TCP connect/SYN behavior.

## Triage

If this scan pattern were observed from an *external* or unauthorized source, it would warrant investigation: full-port-range scans with version detection are a hallmark of active reconnaissance (MITRE T1046) preceding a targeted attack. Here, source and destination are the same authorized host, and the scan was intentional and scoped - the finding is in what it revealed about the host's actual exposure, not in the scan activity itself.

## Investigation

One anomaly was investigated rather than assumed: Nmap's fingerprint for port 9443 returned content referencing `hsforms.net` and recaptcha, which didn't obviously match "Portainer" at a glance. Rather than guessing, this was verified directly:

```
curl -sk https://localhost:9443/ | head -30
sudo ss -tlnp | grep 9443
```

This confirmed the response is genuinely Portainer (`ng-app="portainer"`, Portainer's own branding/loading screen in the HTML) - Nmap's generic HTTP probe simply isn't in its fingerprint database for Portainer's specific response shape. The `ss` check additionally revealed Portainer is bound via `docker-proxy` to `0.0.0.0:9443` and `[::]:9443` - reachable on every network interface, not restricted to loopback or a VPN-only interface.

## Evidence

- [`Evidence/home-lab-scan.nmap`](../Evidence/home-lab-scan.nmap) - human-readable Nmap output, including full NSE script results and service fingerprints for all 13 open ports.
- [`Evidence/home-lab-scan.xml`](../Evidence/home-lab-scan.xml) - structured XML output for programmatic analysis.
- [`Evidence/home-lab-scan.gnmap`](../Evidence/home-lab-scan.gnmap) - grepable summary output.

## Findings

- **13 open TCP ports**, most tied to intentionally-run services in this project's own lab stack (Wazuh, Juice Shop, Wireshark, Portainer).
- **Real TLS certificates** were captured for the three Wazuh components (Dashboard, Manager, Indexer), confirming their identity independently of the earlier Docker-side inspection.
- **Portainer (9443) is bound to all interfaces (`0.0.0.0`/`[::]`)**, not scoped to loopback or the Tailscale interface the way the RustDesk relay server is - a genuine difference in exposure discipline between services on the same host, worth tightening.
- **Apache (80) and CUPS (631)** are running and reachable but aren't part of any project's stated lab stack - default-installed Ubuntu desktop services adding attack surface that isn't being used for anything in this portfolio.
- **MariaDB (3306)** is directly reachable, not just accessible to `localhost`-bound application code - worth confirming it isn't intended to be network-reachable at all.
- **Port 44433** serves bare HTTP responses not tied to any known service in this host's Docker inventory - unidentified and worth a follow-up investigation in its own right.

## Impact

Most of what's exposed is either intentional (the project's own lab services, expected to be reachable for hands-on testing) or low-risk desktop defaults (CUPS, Apache's stock page). The two findings worth acting on are Portainer's all-interfaces binding (a container-management UI with real consequences if its login were ever compromised) and the unidentified port 44433 service, which shouldn't remain unidentified.

## Root Cause

Most findings trace to default behavior rather than misconfiguration: Docker's `docker-proxy` publishes container ports to `0.0.0.0` unless a bind address is explicitly specified in `docker-compose.yml` (the RustDesk services in this same stack *do* specify the Tailscale IP explicitly, proving the narrower binding is available and simply wasn't applied to Portainer). Apache and CUPS are standard Ubuntu desktop packages that ship enabled by default.

## MITRE ATT&CK

- **T1046 - Network Service Scanning** - the technique this exercise itself demonstrates.
- **T1590.001 - Gather Victim Network Information: Domain Properties** (contextual only, via the exposed Wazuh components' certificate subject names, which reveal internal hostnames `wazuh.dashboard`/`wazuh.manager`/`wazuh.indexer`).

These are technique-context mappings for what this scan demonstrates and reveals, not a claim of malicious activity.

## Remediation

- Bind Portainer's published port to the Tailscale interface (or `127.0.0.1` if only local access is needed), matching the pattern already used for the RustDesk services in the same `docker-compose.yml`.
- Identify what's listening on port 44433 and either document it or shut it down if unused.
- Disable Apache and CUPS if they aren't actually needed on this machine, reducing attack surface that isn't in service of anything.
- Confirm MariaDB doesn't need to be reachable beyond `localhost`, and bind it there explicitly if not.

## Validation

Not yet performed - the remediation items above are not yet applied. A future scan re-run after applying them would be the validation step, confirming Portainer and MariaDB no longer appear reachable from outside their intended scope and that port 44433 is either identified or closed.

## Lessons Learned

- A full-port-range scan surfaces real exposure that a narrower, assumption-driven scan (e.g. "just check the ports I expect") would miss entirely - both Apache and CUPS were genuine surprises, not part of any conscious lab setup.
- An unrecognized Nmap fingerprint is a prompt to verify directly (`curl`, `ss`), not to guess or to leave the service unidentified in the write-up.
- Comparing a scan's findings against the host's own `docker-compose.yml` binding choices (RustDesk explicitly scoped, Portainer not) turns a flat port list into an actual finding about inconsistent security practice on the same host.

## Evidence Verification

- Authorized target scope: confirmed (own machine, own consent).
- Scan command: `sudo nmap -sV -sC -p- -oA home-lab-scan localhost` - recorded above and in the raw output's own header line.
- Date/time: 2026-08-26 20:37 CAT - recorded in the raw output.
- Open ports, service names, service versions, script findings: all in the preserved raw output files.
- Anomalous finding (port 9443's fingerprint mismatch): independently verified via `curl` and `ss` rather than assumed.
- Remediation and retest results: not yet performed, and not claimed as such above.

## Recommendations

Apply the remediation items above, then re-run the same scan command to validate. Extend this exercise in the future to UDP scanning (`-sU`) if a fuller picture of this host's exposure is wanted, since this scan covered TCP only.
