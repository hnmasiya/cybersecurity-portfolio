# AI Security / AI-Assisted SOC Lab

A defensive lab covering prompt-injection detection, AI application threat modelling, sensitive-data leakage, AI-assisted phishing analysis, LLM security controls, MITRE ATLAS and human-in-the-loop SOC triage.

Workflow: define trust boundaries; identify prompt-injection and data-leakage risks; classify sensitive information; analyse a synthetic phishing message with AI assistance; require analyst verification; map threats to ATLAS; define controls and logging.

Evidence: evidence/ai-soc-scenarios.json, detections/ai-soc-controls.yaml, reports/AI-SECURITY-REVIEW.md.

Controls: input validation, sensitive-data filtering, least-privilege tool access, output validation, logging, rate limits and human approval for high-impact actions.

Safety: no real credentials, confidential data or autonomous security actions are used.
