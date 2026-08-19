# Wazuh Alert Investigation Report

## Incident Title

Multiple Authentication Failures Detected

## Investigation Type

SOC Alert Investigation

## Security Tool

Wazuh SIEM

## Severity

Medium

## Date

2026

---

# 1. Alert Summary

Wazuh generated an alert after detecting multiple failed authentication attempts on a monitored endpoint.

The event was investigated to determine whether the activity represented:

- Brute force activity
- User error
- Credential compromise attempt

---

# 2. Detection Details

Detection Source:

Wazuh Manager

Log Source:

Linux Authentication Logs

Relevant Log:

/var/log/auth.log


Detection Indicators:

- Multiple failed login attempts
- Repeated authentication failures
- Suspicious login pattern

---

# 3. Investigation Process

Steps performed:

1. Reviewed Wazuh alert details
2. Analysed authentication logs
3. Identified source IP information
4. Checked affected username
5. Determined attack pattern

---

# 4. Findings

Observed Activity:

The endpoint recorded repeated failed authentication attempts.

Potential causes:

- Incorrect credentials
- Automated password guessing
- Unauthorized access attempt

---

# 5. MITRE ATT&CK Mapping

Technique:

T1110 - Brute Force

Tactic:

Credential Access

---

# 6. Response Actions

Recommended actions:

- Block suspicious IP address
- Review affected accounts
- Enforce MFA
- Review password policy
- Monitor future authentication attempts

---

# 7. Analyst Conclusion

The alert demonstrated the importance of SIEM monitoring and authentication event analysis.

The investigation followed a standard SOC workflow:

Detection → Investigation → Analysis → Response
---

# Evidence

## Screenshots


## Investigation Notes

Evidence collected:

- Alert timestamp
- Source IP address
- Username involved
- Authentication failure count
- Wazuh rule triggered

---

# Analyst Decision

Classification:

Security Event

Risk Level:

Medium

Recommended Action:

Continue monitoring and investigate repeated authentication failures.
