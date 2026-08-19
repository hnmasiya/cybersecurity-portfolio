# DVWA — Brute Force

## Objective

Assess the DVWA Brute Force module to determine whether repeated authentication attempts can be performed without effective protective controls, and document the security impact using a professional vulnerability-assessment format.

## Skills & Tools

- Damn Vulnerable Web Application (DVWA)
- Browser
- Burp Suite Community Edition
- HTTP request analysis
- Authentication security testing
- Linux
- Git
- Evidence collection and technical reporting

## Architecture

The DVWA application was assessed in a controlled local cybersecurity laboratory running on Zorin OS.

| Component | Details |
|---|---|
| Application | Damn Vulnerable Web Application (DVWA) |
| Vulnerability | Brute Force |
| Security Level | Low |
| Operating System | Zorin OS |
| Web Server | Apache 2.4.58 (Ubuntu) |
| Database | MariaDB 10.11.14 |
| PHP | 8.3.6 |
| Target | Local DVWA instance |
| Testing Tools | Browser, Burp Suite Community Edition |

## Topology

The assessment was performed against the locally hosted DVWA application. Testing was isolated to the user's cybersecurity laboratory environment.

## Execution

The Brute Force module was accessed and its authentication behaviour was reviewed. Incorrect credentials were submitted repeatedly to determine whether the application enforced meaningful controls such as rate limiting, account lockout, CAPTCHA, or other protections against repeated authentication attempts.

## Walkthrough

1. Accessed the DVWA Brute Force module.
2. Reviewed the login functionality.
3. Submitted incorrect credentials.
4. Repeated authentication attempts within the controlled laboratory.
5. Observed the application's responses.
6. Confirmed that effective brute-force protections were absent or insufficient.
7. Documented the result and collected supporting evidence.

## Attack Simulation

The controlled test simulated an attacker repeatedly submitting username/password combinations against the authentication endpoint.

The purpose of the simulation was to determine whether the application would slow, block, challenge, or otherwise detect repeated failed authentication attempts.

A successful authentication during testing demonstrated that valid credentials could be accepted by the application without an effective brute-force prevention control.

## Detection

Useful defensive indicators include:

- High volumes of failed authentication attempts
- Repeated attempts against one account
- Authentication attempts from a single source in a short period
- Distributed login attempts across multiple accounts
- Sudden successful authentication following multiple failures

## Triage

Prioritize the finding based on:

- Privilege level of the targeted account
- Exposure of the authentication endpoint
- Number of failed attempts
- Whether valid credentials were obtained
- Whether MFA is enabled

## Investigation

Review authentication logs for:

- Source IP addresses
- Usernames targeted
- Timestamp patterns
- Failed versus successful authentication attempts
- User-agent information
- Geographic or network anomalies where applicable

Correlate successful authentication with preceding failed attempts.

## Evidence

The following repository evidence files match this assessment:

- `Web-Security/DVWA/Screenshots/brute-force-failed.png`
- `Web-Security/DVWA/Screenshots/brute-force-page.png`
- `Web-Security/DVWA/Screenshots/brute-force-success.png`
- `Web-Security/DVWA/Screenshots/brute-force-success1.png`

## Findings

The DVWA Brute Force module intentionally lacks effective controls to prevent repeated authentication attempts.

The assessment demonstrated that repeated credential attempts can be performed against the authentication mechanism without adequate throttling or account protection.

**Finding:** Brute-force protection is insufficient.

**Risk Rating:** High

## Impact

Successful brute-force attacks may allow an attacker to:

- Gain unauthorized account access
- Compromise user accounts
- Access sensitive application information
- Use valid credentials for further attacks

## Root Cause

The authentication mechanism does not enforce adequate controls against repeated failed login attempts.

Contributing weaknesses include insufficient rate limiting, lack of account lockout controls, and absence of additional authentication challenges.

## MITRE ATT&CK

**T1110 — Brute Force**

T1110 falls under the Credential Access tactic and covers techniques involving repeated attempts to obtain valid authentication credentials.

## Remediation

Implement:

- Authentication rate limiting
- Progressive delays or exponential backoff
- Account lockout or temporary account suspension
- CAPTCHA after repeated failures
- Multi-factor authentication
- Strong password policies
- Authentication monitoring and alerting

## Validation

After remediation, verify that:

1. Repeated failed attempts trigger the configured control.
2. Authentication requests are rate limited.
3. CAPTCHA or equivalent challenge appears where configured.
4. Account lockout behaves as designed.
5. Legitimate users can recover access safely.
6. Security monitoring generates appropriate alerts.

## Lessons Learned

This assessment provided practical experience in:

- Authentication security testing
- Identifying missing brute-force controls
- Analysing authentication behaviour
- Collecting security evidence
- Assessing business impact
- Writing professional vulnerability reports

## Recommendations

Implement layered authentication protection rather than relying on a single control.

Recommended controls include rate limiting, MFA, strong passwords, CAPTCHA, centralized authentication logging, and alerting on abnormal login activity.
