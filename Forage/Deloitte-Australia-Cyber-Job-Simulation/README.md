# Deloitte Australia Cyber Job Simulation — Forage

**Completed:** October 4, 2026  
**Platform:** Forage  
**Provider:** Deloitte Australia  
**Program:** Cyber

## Scenario

A simulated cybersecurity breach investigation focused on web activity logs, suspicious user behaviour, networking, authentication and web security.

## Business Context

The exercise placed the learner in a simulated client investigation where a status dashboard was suspected of being involved in a breach. The objective was to determine whether the activity could represent unauthorized access and identify suspicious requests in the supplied web activity logs.

> **Evidence boundary:** This was a controlled Forage virtual job simulation. It was not employment with Deloitte Australia and does not represent a real Deloitte client incident or production engagement.

## Investigation

### Task — Web Activity Log Investigation

The investigation involved:

- Reading and analysing web activity logs.
- Establishing the normal dashboard access sequence.
- Assessing authentication and session behaviour.
- Comparing normal human browsing with anomalous automated requests.
- Identifying suspicious user activity.
- Applying networking and web-security concepts to the simulated breach scenario.

[View Investigation Details](task-1/web-log-investigation.md)

## Evidence / Indicators

The supplied activity showed suspicious behaviour associated with:

- **Internal IP:** `192.168.0.101`
- **User ID:** `mdB7yD2dp1BFZPontHBQ1Z`
- Requests to the factory status APIs for:
  - `meiyo`
  - `seiko`
  - `shenzhen`
  - `berlin`
- Requests occurring at highly regular hourly intervals, including the observed `HH:00:48` timing pattern.
- API requests occurring without the normal dashboard page/resource-loading sequence.

These indicators were evaluated within the controlled simulation evidence.

## Findings

The normal dashboard workflow included authentication followed by loading the dashboard and its supporting resources before factory-status API requests.

The suspicious sequence differed because the observed activity:

- Repeated at precise hourly intervals.
- Queried all four factory status APIs.
- Did not show the expected dashboard resource-loading behaviour.
- Was therefore consistent with automated polling rather than ordinary interactive browsing.

## Indicators of Suspicion

The strongest indicators were:

1. **Exact periodicity** — repeated requests at the same point each hour.
2. **API-only behaviour** — status API requests without the surrounding browser resource sequence.
3. **Multi-factory enumeration** — requests covering all four factory endpoints.
4. **Session anomaly** — the activity did not follow the normal login/dashboard interaction pattern expected for a new date/session.

These are indicators for investigation, not proof of a real-world compromise.

## Analysis

The exercise demonstrated how web logs can be used to reconstruct user behaviour and distinguish expected application traffic from anomalous automation.

The analysis combined:

- HTTP request sequencing.
- Authentication/session reasoning.
- API behaviour analysis.
- Timing analysis.
- Network-access considerations.
- Web-security interpretation.

## Recommended Actions

For a real-world investigation based on similar evidence, appropriate next steps would include:

- Preserve the relevant web and authentication logs.
- Correlate the suspicious IP and user identity with VPN, endpoint and identity-provider records.
- Review authentication events around the anomalous activity.
- Determine whether the account or session was legitimately authorized.
- Investigate the source process or host generating the periodic API requests.
- Review API access controls and monitoring.
- Establish whether any sensitive data or operational functions were accessed or changed.
- Contain confirmed unauthorized access according to the organization's incident-response process.

These are investigation recommendations derived from the simulated indicators, not actions performed against a real Deloitte environment.

## Skills Demonstrated

- Log Analysis
- Computer Networking
- Web Security
- Incident Investigation
- Authentication and Session Analysis
- API Request Analysis
- Anomalous Activity Detection
- Security Event Interpretation
- Analytical Reasoning
- Technical Documentation

## Lessons Learned

- Request sequences can reveal the difference between human browsing and automation.
- Timing regularity can be a useful anomaly indicator.
- API activity should be analysed in the context of the application's expected user workflow.
- Authentication events and application logs should be correlated during investigations.
- Suspicious indicators should be treated as evidence requiring validation rather than automatically labelled as a confirmed compromise.

## Portfolio Relevance

This simulation strengthens the portfolio's SOC narrative by demonstrating log analysis, suspicious-activity detection, web-security investigation and structured incident reasoning.

It complements the portfolio's Wazuh, network-analysis, offensive-security, incident-response and detection-engineering work.

## Official Simulation

[View Deloitte Australia Cyber Job Simulation on Forage](https://www.theforage.com/simulations/deloitte-au/cyber-c1e3)

## Evidence Scope

This repository documents simulated learning activities completed through Forage. It does not claim employment, production access, or a real-world Deloitte Australia engagement.
