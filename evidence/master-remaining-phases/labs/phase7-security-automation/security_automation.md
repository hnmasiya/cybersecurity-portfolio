# Security Automation

Automation principles:
- Input validation
- Least privilege
- Idempotency
- Safe failure
- Structured logs
- Hashable artifacts
- No hard-coded credentials
- Human approval for consequential actions

Suggested pipeline:
collect -> normalize -> validate -> enrich -> detect -> report -> review
