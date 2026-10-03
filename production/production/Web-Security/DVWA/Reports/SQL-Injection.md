# DVWA — SQL Injection

## Objective

Assess the DVWA SQL Injection module to determine whether user-controlled input can alter backend database queries.

## Skills & Tools

- DVWA
- Browser
- Burp Suite Community Edition
- HTTP request analysis
- SQL injection testing
- MariaDB
- Linux
- Git
- Security evidence collection

## Architecture

The assessment was performed in a controlled local cybersecurity laboratory on Zorin OS.

| Component | Details |
|---|---|
| Application | DVWA |
| Vulnerability | SQL Injection |
| Security Level | Low |
| Operating System | Zorin OS |
| Web Server | Apache 2.4.58 (Ubuntu) |
| Database | MariaDB 10.11.14 |
| PHP | 8.3.6 |
| Testing Tools | Browser, Burp Suite Community Edition |

## Topology

Testing was performed against the local DVWA SQL Injection module backed by MariaDB.

## Execution

A normal User ID request was first submitted to establish expected behaviour. A controlled SQL injection test was then supplied and the response was compared with the baseline.

## Walkthrough

1. Accessed the SQL Injection module.
2. Submitted a normal User ID request.
3. Recorded the expected response.
4. Submitted a controlled SQL injection test.
5. Compared the returned records.
6. Observed that the input altered query behaviour.
7. Collected evidence.

## Attack Simulation

The controlled test demonstrated the effect of manipulating application input that is incorporated directly into a database query.

The commonly documented laboratory test used was:

`1' OR '1'='1`

The resulting response returned multiple records, demonstrating that the input could influence the SQL query.

## Detection

Monitor:

- SQL metacharacters
- Unexpected SQL keywords in request parameters
- Abnormal query patterns
- Database errors
- Unusual record retrieval volumes

## Triage

Prioritize SQL injection as high risk because successful exploitation can expose sensitive database information and potentially affect data integrity.

## Investigation

Review:

- Web-server logs
- Application logs
- Database query logs where enabled
- Parameters submitted by the source
- Records accessed or modified

Determine the scope of data exposure.

## Evidence

The following repository evidence files match this assessment:

- `Web-Security/DVWA/Screenshots/sql-injection-blind-baseline.png`
- `Web-Security/DVWA/Screenshots/sql-injection-blind-false.png`
- `Web-Security/DVWA/Screenshots/sql-injection-blind-true.png`
- `Web-Security/DVWA/Screenshots/sql-injection-normal.png`
- `Web-Security/DVWA/Screenshots/sql-injection-success.png`

## Findings

The DVWA SQL Injection module intentionally concatenates user-controlled input into SQL queries.

The controlled test demonstrated that a manipulated input could alter query behaviour and return multiple records.

**Finding:** User-controlled input is incorporated into SQL queries without parameterization.

**Risk Rating:** High

## Impact

Successful SQL injection may allow:

- Unauthorized database record retrieval
- Disclosure of sensitive information
- Authentication bypass in vulnerable implementations
- Modification or deletion of data
- Compromise of application data confidentiality and integrity

## Root Cause

User input is concatenated directly into SQL statements rather than being handled using parameterized queries or prepared statements.

## MITRE ATT&CK

**T1190 — Exploit Public-Facing Application**

SQL injection can provide an application-level path to unauthorized database access and further compromise.

## Remediation

- Use prepared statements.
- Use parameterized queries.
- Avoid SQL string concatenation with user input.
- Apply strict input validation.
- Use least-privilege database accounts.
- Suppress detailed database errors from users.

## Validation

Verify that:

1. Normal queries continue to function.
2. SQL metacharacters are handled safely.
3. Injection test strings do not alter query results.
4. Database errors are not exposed unnecessarily.
5. The application database account has only required privileges.

## Lessons Learned

The exercise provided practical experience in identifying insecure database interaction, establishing a baseline, validating abnormal query behaviour, collecting evidence, and recommending secure development controls.

## Recommendations

Prepared statements should be mandatory for database access. Secure code review and automated application-security testing should also be incorporated into the development lifecycle.
