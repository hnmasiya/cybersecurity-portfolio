# Identity / Entra ID Attack & Detection Lab

Extends existing Active Directory work into modern identity security using safe synthetic events.

Scenarios: password-spray indicators, MFA-related anomalies, impossible travel, suspicious OAuth consent and privilege escalation.

Workflow: establish normal sign-in context; correlate authentication, device, application and audit events; query synthetic telemetry with Sentinel/KQL-style logic; map detections to ATT&CK; recommend containment and hardening.

Evidence: evidence/entra-investigation.json, detections/entra-sentinel-detections.kql, reports/IDENTITY-INVESTIGATION.md.

Controls: MFA, Conditional Access, risk-based sign-in, least privilege, privileged identity management, OAuth governance and session/token revocation.

Safety: no password-spraying automation or real identity attack is performed.
