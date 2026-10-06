# IOC Investigation — Controlled Validation Record

**Evidence state: CONTROLLED / SYNTHETIC**

## Scenario
Three intentionally synthetic indicators were normalized and validated offline.

## Evidence
- IPv4: `198.51.100.23`
- Domain: `cdn-update.example.invalid`
- SHA-256: `0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef`

The IPv4 address is from TEST-NET-2, reserved for documentation; it is not presented as a real malicious host. citeturn0search11

## Method
The parser validates indicator format, normalizes values, records source/confidence, and deliberately does not perform external enrichment.

## Results
All three indicators passed their format checks. No maliciousness verdict was assigned.

## Analysis
The case demonstrates safe IOC extraction, normalization, confidence tracking and analyst-controlled enrichment boundaries.

## Limitations
No reputation provider, DNS lookup, sandbox, threat-intelligence subscription or external system was queried. Therefore the case does not establish that any indicator is malicious.

## Result
The previously pending exercise now has reproducible controlled/synthetic evidence.
