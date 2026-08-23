# Evidence Integrity Audit

## Required Classification

Every major security artifact should be classified as one of:

### Observed

Actually captured from an authorized system.

### Reproducible

Can be recreated from repository code/configuration.

### Synthetic

Intentionally generated data.

### Methodology

Explains an analytical process without claiming a specific observed event.

### Architecture

Security design/configuration rather than runtime evidence.

---

## High-Priority Claims to Verify

### Wazuh

Verify whether claims represent:

- live Wazuh telemetry
- offline rule validation
- synthetic alert data
- architecture/configuration

### PCAP

Verify:

- actual PCAP preserved
- actual packet count
- actual benchmark
- test hardware
- measurement methodology

### False Positive Reduction

If claiming a percentage reduction, preserve:

- before count
- after count
- dataset
- rule version
- measurement method

### DFIR

Preserve:

- source logs
- hashes
- timeline
- commands/tooling
- analysis notes

### Nmap

Preserve:

- authorization
- target
- raw output
- timestamp
- interpretation

### Named tools in README / profile bios

Any tool named in a README or bio (e.g. Metasploit, BloodHound, Volatility,
Prowler) should have at least one corresponding report or artifact inside
the relevant folder. If a named tool has zero matching evidence anywhere
in the repo, remove it from the README rather than leaving it as an
unsupported claim.

