# Identity Investigation Report

The synthetic event chain indicates possible identity compromise: distributed authentication failures, anomalous geography, suspicious OAuth consent and a privileged-group change.

Response: risk-block or disable the affected identity pending validation; revoke sessions/tokens; remove unapproved OAuth grants; review privileged changes; require phishing-resistant MFA for privileged identities; review Conditional Access; hunt related indicators.

ATT&CK focus: T1110.003, T1078 and T1098.

Limitation: synthetic events only; the lab demonstrates defensive analytics rather than attack execution.
