# Authentication Context — Investigation Extension

**Evidence state:** SYNTHETIC / OFFLINE VALIDATION

This exercise adds Windows Security Event IDs 4625 (failed logon) and 4624 (successful logon) as contextual evidence for broader investigations. The fixture includes a same-account/same-host sequence and a benign local-logon control.

## What it demonstrates

- Recognizing authentication success and failure as distinct event types.
- Preserving timestamp, host, account, logon type, and source-IP fields where present.
- Avoiding automatic conclusions from one failure followed by a success.
- Keeping synthetic documentation IPs clearly labelled as non-IOC values.

## Analyst workflow

1. Validate event collection and account field semantics on an authorized endpoint.
2. Group by the correct account identity and source context; do not equate display names with immutable identities.
3. Review the surrounding time window, logon type, workstation/source, and expected administrative activity.
4. Correlate only when source fields and time semantics are reliable.
5. Record benign controls and explain missing or unmapped fields.

## Limitations

The fixture is not live Windows telemetry. It does not implement a brute-force threshold, account-risk score, or production identity detection. Production thresholds must be tuned to the environment and reviewed for service accounts, NAT, VPN, and legitimate authentication retries.
