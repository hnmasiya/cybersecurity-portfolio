# Controlled Phishing / Email Investigation — Validation Record

**Evidence state: CONTROLLED / SYNTHETIC**

## Scenario
A synthetic payroll-themed email was analyzed offline. No message was sent, no recipient was contacted, and no external URL or attachment was opened.

## Evidence
Input: `evidence/synthetic-phishing.eml`.

Observed authentication values:
- SPF: fail
- DKIM: none
- DMARC: fail
- Reply-To: `verify@payroll-example.invalid`

The `.invalid` domain is intentionally non-routable training data.

## Analysis
The authentication failures and separate Reply-To address are phishing risk indicators in this synthetic case. They are not proof of a real compromise.

MITRE ATT&CK mapping: Phishing (T1566) is applicable to the simulated scenario; no real adversary activity is claimed. citeturn0search0turn0search2

Google's Gmail guidance identifies SPF/DKIM authentication results in the `Authentication-Results` header as relevant to message authentication review. citeturn0search5

## Validation
The local parser extracted all three authentication states and the Reply-To value from the retained synthetic artifact.

## Limitations
No live mailbox, mail gateway, URL detonation, attachment sandbox, or production telemetry was used.

## Result
The previously pending exercise now has reproducible controlled/synthetic evidence. It remains explicitly non-production.
