# Incident Response — Phishing/BEC

Severity: High if payment or identity compromise is confirmed.

Timeline: user report -> message/header preservation -> SPF/DKIM/DMARC review -> IOC extraction -> mailbox and identity hunt -> containment -> finance notification -> recovery.

Containment: quarantine related messages, block confirmed indicators, reset credentials where required and revoke active sessions/tokens.

Recovery: verify MFA, review mailbox rules/delegation, independently validate payment requests and monitor for recurrence.

Lesson: email authentication is a control, not a complete verdict; correlate headers, identity telemetry and business context.
