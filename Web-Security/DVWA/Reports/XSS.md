# DVWA — Cross-Site Scripting (XSS)

## Objective
Assess the DVWA Cross-Site Scripting functionality at the Low security level and document the risks associated with insufficient input handling and output encoding.

## Skills & Tools
- DVWA
- Zorin OS
- Apache 2.4.58
- PHP 8.3.6
- MariaDB 10.11.14
- Web browser
- Burp Suite Community Edition
- HTTP request analysis
- Git

## Architecture
DVWA is deployed in the controlled local cybersecurity laboratory on Zorin OS. The browser communicates with DVWA through Apache/PHP, with MariaDB providing database services where required.

## Topology
Security Testing Workstation -> Web Browser -> DVWA -> Apache/PHP -> MariaDB

Testing was restricted to the local DVWA laboratory.

## Execution
The DVWA XSS functionality was accessed at Low security. Controlled input was submitted and the resulting browser behaviour was observed and documented.

## Walkthrough
1. Opened the DVWA XSS functionality.
2. Reviewed normal behaviour.
3. Submitted controlled test input.
4. Observed the response and browser behaviour.
5. Captured evidence screenshots.
6. Documented impact and remediation.

## Attack Simulation
A controlled XSS assessment was performed against the intentionally vulnerable DVWA application. No production or third-party systems were targeted.

## Detection
Monitor suspicious script-like input, encoded payloads, abnormal request parameters, unexpected rendered content, WAF alerts, and application/web-server logs.

## Triage
Determine the affected endpoint, parameter, XSS type, execution context, affected users, and whether sensitive authenticated functionality is exposed.

## Investigation
Review HTTP requests/responses, input validation, output encoding, Content Security Policy, session controls, and application/web-server logs.

## Evidence
Relevant evidence currently present includes:
- Screenshots/xss-payload.png
- Screenshots/xss-success.png
- Screenshots/xss-reflected-page.png
- Screenshots/xss-reflected-success.png
- Screenshots/xss-stored-persisted.png
- Screenshots/xss-dom-success.png

## Findings
The assessment identified insufficient protection against user-controlled content being interpreted by the browser within the intentionally vulnerable DVWA environment.

## Impact
Successful XSS exploitation may allow client-side script execution, content manipulation, actions in the application context, targeting authenticated users, and browser-based social engineering.

## Root Cause
The root cause is insufficient handling of untrusted user input before it is rendered or processed by the browser.

## MITRE ATT&CK
T1189 — Drive-by Compromise. The exact mapping depends on the broader attack chain.

## Remediation
Apply context-aware output encoding, appropriate input validation, secure templating, a strong Content Security Policy, safe DOM APIs, secure cookies, and regular application security testing.

## Validation
Repeat the controlled XSS tests after remediation and confirm that previously successful payloads no longer execute while legitimate functionality remains intact.

## Lessons Learned
The assessment reinforced secure input handling, context-aware output encoding, browser security controls, evidence collection, and professional security reporting.

## Recommendations
Maintain XSS testing in the secure development lifecycle through secure coding, code review, automated testing, and penetration testing.
