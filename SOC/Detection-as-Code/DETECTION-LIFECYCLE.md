# Detection lifecycle and rule governance

## Lifecycle

1. **Propose:** document the threat hypothesis, affected assets, expected telemetry and business rationale.
2. **Implement:** keep rule logic, ATT&CK mapping, data requirements, severity and owner in version control.
3. **Test:** run positive cases, benign controls, edge cases and regression tests against synthetic or approved telemetry.
4. **Review:** inspect false-positive paths, required fields, time windows, exclusions and possible blind spots.
5. **Deploy:** use a controlled change process, peer review and a rollback path. Lab rules are not production-approved by default.
6. **Monitor:** track alert volume, precision samples, data-source health and changes in attacker behaviour.
7. **Tune:** record why a change was made and rerun the regression suite.
8. **Retire:** document the reason, replacement coverage and retirement date before removing a rule.

## Minimum rule record

- Stable rule ID and title
- Threat hypothesis and rationale
- Data source and required fields
- Logic/query and severity
- MITRE ATT&CK technique with justification
- Positive and negative test cases
- False-positive examples and tuning decisions
- Owner, review date, change history and rollback approach
- Validation environment and evidence classification

## Current lab validation boundary

The companion Python harness uses normalized, synthetic process events. The Sigma rule is a portable rule artifact and must be validated with a compatible Sigma validator and the target SIEM's field mapping before use. Unit-test success does not prove live Windows telemetry ingestion, Splunk Enterprise Security content deployment, Wazuh alert generation, enterprise-scale reliability or production incident ownership.

## Tuning checklist

- Is the data source enabled and complete?
- Are process image and command-line fields populated consistently?
- Are benign administrative scripts represented in negative tests?
- Is the logic too broad or dependent on fragile string matching?
- Can parent process, user, host criticality and signing context improve triage?
- Is suppression scoped narrowly enough to avoid hiding real activity?
- Are rule changes reviewed and regression-tested?
- Is there a clear rollback path and named owner?

## Evidence integrity

Only results that have actually been run and retained should be labelled as executed. Synthetic fixtures are explicitly synthetic. Production metrics, peer review, purple-team exercises and incident-response ownership are not claimed by this lab.
