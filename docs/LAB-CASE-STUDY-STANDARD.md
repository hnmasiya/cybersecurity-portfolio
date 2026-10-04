# Cybersecurity Lab Case-Study Standard

Every cybersecurity lab must distinguish verified evidence from preparation, methodology, simulation and future work.

## Required structure
1. Scenario
2. Business / Technical Context
3. Objective
4. Environment / Scope
5. Tools Used
6. Investigation / Methodology
7. Commands / Scripts Used
8. Evidence
9. Indicators / Observations
10. Analysis
11. Findings
12. Risk / Impact
13. Recommended Actions
14. Detection / Monitoring Opportunities
15. MITRE ATT&CK Mapping — where applicable
16. Lessons Learned
17. Skills Demonstrated
18. Portfolio / SOC Relevance
19. Evidence & Limitations
20. References / Source Material

Sections may be omitted when genuinely irrelevant, but must never be filled with invented content.

## Evidence states
- LIVE / REAL LAB — authorized real-environment evidence.
- CONTROLLED / SYNTHETIC — synthetic telemetry or controlled simulation.
- OFFLINE VALIDATION — logic validated without live-execution claims.
- ARCHITECTURE / METHODOLOGY — design exists but execution is not evidenced.
- PENDING VALIDATION — execution required before completion can be claimed.
- VIRTUAL EXPERIENCE — third-party simulation; never presented as employment or a real client engagement.

## Evidence-first rules
- Never fabricate screenshots, commands, outputs, metrics, incidents, findings, certifications or deployments.
- If not performed, say Not performed / outside scope.
- If simulated, say Controlled simulation — not a real-world incident.
- Separate observation, interpretation, recommendation and executed response.
- Preserve, hash and sanitize evidence as appropriate.
- State environmental and methodological limitations.

## Completion gate
A lab is complete when scope is defined, execution state is truthful, evidence is retained, methodology is reproducible, findings are supported, limitations are explicit, links work and repository checks pass.

## Future workflow
Build → Preserve Evidence → Validate → Document → Analyze → QA → PR → Required Checks → Squash Merge → Publish
