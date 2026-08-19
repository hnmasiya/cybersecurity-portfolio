# DVWA — Command Injection

## Objective

Assess the DVWA Command Injection module to determine whether user-controlled input can influence operating-system command execution.

## Skills & Tools

- DVWA
- Browser
- Burp Suite Community Edition
- HTTP request analysis
- Linux
- Command execution analysis
- Git
- Security evidence collection

## Architecture

The assessment was performed in a controlled local cybersecurity laboratory on Zorin OS.

| Component | Details |
|---|---|
| Application | DVWA |
| Vulnerability | Command Injection |
| Security Level | Low |
| Operating System | Zorin OS |
| Web Server | Apache 2.4.58 (Ubuntu) |
| Database | MariaDB 10.11.14 |
| PHP | 8.3.6 |
| Testing Tools | Browser, Burp Suite Community Edition |

## Topology

Testing was performed against the locally hosted DVWA application within the isolated laboratory environment.

## Execution

The Command Injection module was accessed and first tested with normal input. A controlled modified input was then supplied to determine whether application input was incorporated into an operating-system command.

## Walkthrough

1. Accessed the Command Injection module.
2. Submitted a normal request.
3. Observed the expected application response.
4. Submitted a controlled modified input.
5. Compared the resulting response.
6. Confirmed that user-controlled input influenced command execution.
7. Collected evidence.

## Attack Simulation

The test simulated an attacker manipulating a vulnerable application parameter to influence an operating-system command.

Testing was restricted to the local DVWA laboratory.

## Detection

Defensive monitoring should identify:

- Suspicious shell metacharacters
- Unexpected command parameters
- Web-server processes spawning unusual child processes
- Unexpected outbound connections
- Abnormal process trees involving Apache/PHP

## Triage

This finding should be treated as high risk because successful command injection can result in unauthorized operating-system command execution.

## Investigation

Review:

- Web-server access logs
- Application logs
- Process creation telemetry
- Child processes spawned by Apache/PHP
- Outbound network connections
- Files created or modified following exploitation

## Evidence

The following repository evidence files match this assessment:

- `Web-Security/DVWA/Screenshots/command-injection-normal.png`
- `Web-Security/DVWA/Screenshots/command-injection-success.png`

## Findings

The DVWA Command Injection module intentionally allows user-controlled input to reach command execution functionality.

The controlled assessment demonstrated that modified input could influence server-side command execution.

**Finding:** OS command execution is insufficiently separated from user input.

**Risk Rating:** High

## Impact

Successful exploitation may allow an attacker to:

- Execute unauthorized commands
- Read system information
- Modify files
- Access application resources
- Establish further access to the system

## Root Cause

User-controlled input is incorporated into an operating-system command without sufficient validation or safe command execution mechanisms.

## MITRE ATT&CK

**T1059 — Command and Scripting Interpreter**

The vulnerability can provide a pathway to command execution depending on the privileges of the affected web-server process.

## Remediation

- Avoid shell execution where possible.
- Use safe APIs instead of shell commands.
- Apply strict allow-list validation.
- Separate user input from command arguments.
- Run the application with least privilege.
- Monitor process creation from web applications.

## Validation

After remediation:

1. Submit legitimate input.
2. Confirm expected functionality.
3. Submit invalid/metacharacter input.
4. Confirm it is rejected or safely handled.
5. Verify that no unintended child process is created.
6. Review application and system logs.

## Lessons Learned

The exercise demonstrated the importance of separating untrusted input from operating-system functionality and reinforced the value of controlled exploitation and evidence-driven reporting.

## Recommendations

Use secure command-execution APIs, strict allow-lists, least-privilege service accounts, application logging, and endpoint/process monitoring.
