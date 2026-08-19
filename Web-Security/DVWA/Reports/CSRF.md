# DVWA — Cross-Site Request Forgery (CSRF)

## Objective

Assess the DVWA CSRF module to determine whether an authenticated user's session can be abused to perform an unauthorized state-changing action.

## Skills & Tools

- DVWA
- Browser
- HTTP request analysis
- Authentication/session analysis
- Git
- Security evidence collection

## Architecture

The assessment was performed in a controlled local cybersecurity laboratory on Zorin OS.

| Component | Details |
|---|---|
| Application | DVWA |
| Vulnerability | CSRF |
| Security Level | Low |
| Operating System | Zorin OS |
| Web Server | Apache 2.4.58 (Ubuntu) |
| Database | MariaDB 10.11.14 |
| PHP | 8.3.6 |
| Testing Tool | Browser |

## Topology

Testing was performed against the local DVWA application using an authenticated browser session.

## Execution

The CSRF module was accessed and a normal password-change request was performed first. The request structure was then reviewed to determine whether an anti-CSRF token or equivalent server-side validation was present.

A controlled forged request was subsequently tested in the laboratory.

## Walkthrough

1. Accessed the DVWA CSRF module.
2. Performed a normal password change.
3. Observed the resulting request.
4. Reviewed the request parameters and security controls.
5. Constructed a controlled unauthorized request.
6. Submitted the request while authenticated.
7. Confirmed that the application accepted the state-changing request.
8. Collected evidence.

## Attack Simulation

The simulation represented a situation in which an attacker causes an authenticated user to submit a malicious state-changing request.

Testing remained confined to the local DVWA environment.

## Detection

Defensive indicators include:

- State-changing requests without valid CSRF tokens
- Invalid or missing Origin/Referer headers
- Unexpected password or account-setting changes
- Requests originating from unusual navigation contexts

## Triage

Prioritize according to the sensitivity of the affected action.

Password changes and account-management actions should receive higher priority because successful exploitation may contribute to account takeover.

## Investigation

Review:

- Authentication logs
- State-changing requests
- Origin and Referer headers
- CSRF token validation
- Account changes occurring without normal user interaction

## Evidence

The following repository evidence files match this assessment:

- `Web-Security/DVWA/Screenshots/csrf-success.png`

## Findings

The DVWA CSRF module intentionally lacks effective CSRF protection.

The assessment demonstrated that an authenticated state-changing request could be accepted without adequate protection against forged cross-site requests.

**Finding:** Missing or insufficient CSRF protection.

**Risk Rating:** Medium/High

## Impact

Successful CSRF exploitation may allow an attacker to:

- Change account settings
- Modify sensitive information
- Change credentials
- Perform unauthorized actions using the victim's authenticated session

## Root Cause

The application does not adequately bind state-changing requests to a server-generated anti-CSRF token or equivalent request-origin validation.

## MITRE ATT&CK

**T1185 — Browser Session Cookie**

CSRF primarily abuses an authenticated browser session to cause unintended actions.

## Remediation

- Implement unpredictable per-session or per-request CSRF tokens.
- Validate tokens server-side.
- Validate Origin/Referer where appropriate.
- Configure SameSite cookies.
- Require additional confirmation for high-risk actions.

## Validation

Verify that:

1. Legitimate requests with valid tokens succeed.
2. Requests without tokens fail.
3. Invalid tokens fail.
4. Cross-origin requests are rejected where appropriate.
5. Sensitive actions require appropriate confirmation.

## Lessons Learned

The exercise demonstrated how browser authentication state can be abused when applications fail to distinguish legitimate state-changing requests from forged requests.

## Recommendations

Use CSRF tokens as the primary application-level control and complement them with secure cookie configuration, origin validation, and appropriate re-authentication for sensitive operations.
