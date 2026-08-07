# Nmap Network Reconnaissance Report

## Assessment Type

Network Discovery and Service Enumeration

## Tool

Nmap

---

# Objective

Identify available hosts, open ports, and exposed services within the authorised laboratory environment.

---

# Commands Used

Example:

nmap -sV -sC <target>

---

# Findings

## Host Discovery

Identified active hosts within the testing network.

---

## Service Enumeration

Collected information about:

- Open ports
- Running services
- Service versions

---

# Security Analysis

Exposed services increase attack surface.

Recommendations:

- Disable unnecessary services
- Patch outdated software
- Restrict network access

---

# Skills Demonstrated

- Network reconnaissance
- Port scanning
- Service identification
- Risk assessment
---

# Evidence

Scan Output:

Example:
nmap -sV -sC target


Captured information:

- Open ports
- Service versions
- Potential risks


Screenshot:

![Nmap Scan](../Screenshots/nmap-scan.png)

---

# Analyst Recommendation

Reduce attack surface by:

- Closing unused ports
- Updating exposed services
- Restricting access
