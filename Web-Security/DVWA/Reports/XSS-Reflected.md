# XSS Reflected — DVWA Security Assessment

## Objective

Assess the DVWA XSS Reflected vulnerability class in a controlled local laboratory environment and document the security implications, detection considerations and remediation strategy.

## Skills & Tools

DVWA, browser developer tools, Burp Suite Community Edition, HTTP request analysis, Linux, web application security testing and evidence-based vulnerability reporting.

## Architecture

The assessment targets a deliberately vulnerable DVWA application hosted inside the local security laboratory. Testing is performed against the laboratory application only.

## Topology

Client security-testing workstation → DVWA web application → application/database components.

No production systems are required or intended for this assessment.

## Execution

Test whether supplied input is reflected into an HTTP response without appropriate output encoding.

Testing should be performed only against the authorized DVWA laboratory instance.

## Walkthrough

1. Confirm the DVWA application is running.
2. Authenticate to the application.
3. Navigate to the relevant vulnerability module.
4. Record the configured DVWA security level.
5. Establish normal application behaviour.
6. Submit controlled test input.
7. Capture the HTTP request and response where applicable.
8. Record the observable result.
9. Determine whether the behaviour confirms the vulnerability.
10. Preserve screenshots or terminal evidence.

## Attack Simulation

A controlled laboratory test should be used to reproduce the vulnerability without targeting external or production systems.

**Evidence status:** Testing procedure documented. No exploitation result is claimed here unless supported by captured laboratory evidence.

## Detection

Potential detection sources include web-server logs, application logs, WAF telemetry, HTTP request patterns, authentication events and SIEM correlation.

## Triage

Determine:

- affected endpoint;
- source of the request;
- authenticated user/session;
- supplied input;
- timestamp;
- application response;
- whether the activity was authorized laboratory testing.

## Investigation

Correlate application requests with server logs and other available telemetry. Preserve the original request/response and screenshots where available.

## Evidence

Expected evidence includes:

- DVWA security level;
- HTTP request;
- HTTP response;
- application behaviour;
- screenshot or terminal output;
- timestamp;
- affected endpoint.

**Current evidence status:** This report provides the assessment methodology. Actual exploitation evidence must be added from the user's authorized DVWA laboratory before the vulnerability is represented as a confirmed finding.

## Findings

The vulnerability class and its testing methodology have been documented.

A confirmed finding should only be recorded after successful reproduction in the local DVWA environment.

## Impact

Depending on the vulnerability, successful exploitation could affect confidentiality, integrity or availability, including unauthorized actions, data exposure, session compromise or execution of unintended application behaviour.

## Root Cause

Typical root causes include insufficient input validation, inadequate output encoding, weak authentication/session controls, missing security headers or insufficient server-side enforcement.

The exact root cause must be confirmed from the observed DVWA implementation.

## MITRE ATT&CK

Potential ATT&CK mapping:

- **T1059 — Execution**

The mapping is contextual and should be refined based on the actual observed attack behaviour.

## Remediation

Apply appropriate server-side validation and security controls, enforce least privilege, use secure framework APIs, encode untrusted output, protect authentication/session mechanisms and apply defence-in-depth controls.

## Validation

After remediation, repeat the original laboratory test and verify that the vulnerable behaviour is no longer reproducible.

Capture before/after evidence where possible.

## Lessons Learned

Security testing should combine controlled exploitation, application understanding, HTTP-level evidence and defensive analysis rather than relying only on a vulnerability label.

## Recommendations

1. Maintain server-side validation.
2. Apply secure coding practices.
3. Monitor relevant application and authentication events.
4. Integrate web-security findings into the SIEM.
5. Preserve reproducible evidence.
6. Retest after remediation.
7. Document the exact DVWA security level used.

