# DVWA — File Inclusion (LFI/RFI)

## Objective

Assess the DVWA File Inclusion module to determine whether untrusted file parameters can be manipulated to access unintended local or remote files.

## Skills & Tools

- DVWA
- Browser
- Burp Suite Community Edition
- HTTP parameter analysis
- Linux
- Git
- Security evidence collection

## Architecture

The assessment was performed in a controlled local cybersecurity laboratory on Zorin OS.

| Component | Details |
|---|---|
| Application | DVWA |
| Vulnerability | File Inclusion |
| Security Level | Low |
| Operating System | Zorin OS |
| Web Server | Apache 2.4.58 (Ubuntu) |
| Database | MariaDB 10.11.14 |
| PHP | 8.3.6 |
| Testing Tools | Browser, Burp Suite Community Edition |

## Topology

Testing was performed against the local DVWA File Inclusion module.

## Execution

The file parameter was reviewed and tested using controlled path manipulation. Application responses were compared to determine whether files outside the intended application resources could be processed.

## Walkthrough

1. Accessed the File Inclusion module.
2. Reviewed the file parameter.
3. Submitted the normal application request.
4. Tested controlled file-path manipulation.
5. Observed application responses.
6. Determined whether unintended files could be processed.
7. Collected evidence.

## Attack Simulation

The simulation represented an attacker manipulating a file parameter to access files outside the intended application content.

Testing was restricted to the local laboratory.

## Detection

Monitor for:

- Path traversal sequences
- Unexpected file parameters
- PHP stream wrappers
- Remote URLs in file parameters
- Requests for sensitive system/application files

## Triage

Severity depends on the demonstrated capability.

LFI may expose sensitive files, while RFI can potentially lead to code execution where the application and PHP configuration permit it.

## Investigation

Review web-server logs for:

- Suspicious file parameters
- Path traversal attempts
- Remote file references
- Repeated inclusion attempts

Also determine whether sensitive files were successfully accessed.

## Evidence

The following repository evidence files match this assessment:

- `Web-Security/DVWA/Screenshots/file-inclusion-page.png`
- `Web-Security/DVWA/Screenshots/file-inclusion-success-page.png`

## Findings

The DVWA File Inclusion module intentionally lacks sufficient validation of the file parameter.

The controlled assessment demonstrated that manipulated file paths could be processed by the application.

**Finding:** Untrusted file input is insufficiently validated.

**Risk Rating:** High

## Impact

Potential impacts include:

- Disclosure of sensitive local files
- Exposure of configuration data
- Disclosure of credentials or secrets
- Application source-code exposure
- Remote code execution in vulnerable configurations

## Root Cause

User-controlled file input is passed into file-processing functionality without a strict allow-list restricting the permitted resources.

## MITRE ATT&CK

**T1190 — Exploit Public-Facing Application**

The vulnerability can provide an application-level path to unauthorized file access or further compromise.

## Remediation

- Avoid direct use of user-controlled filenames.
- Use strict allow-lists.
- Map user selections to predefined server-side resources.
- Disable unnecessary remote file inclusion.
- Apply least-privilege permissions.
- Keep sensitive files outside web-accessible locations.

## Validation

Test:

1. Legitimate file selections.
2. Invalid filenames.
3. Path traversal attempts.
4. Remote file references where applicable.
5. Unexpected PHP wrappers.

All unauthorized file references should be rejected.

## Lessons Learned

The assessment demonstrated the importance of strict file-resource validation and showed how apparently simple filename parameters can create significant application-security exposure.

## Recommendations

Disable dangerous PHP configuration options where unnecessary, including remote file inclusion functionality, and perform regular application security testing.
