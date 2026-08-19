# Suspicious Login Hunt

## Hunt objective

Identify repeated failed authentication activity that may indicate password guessing or account-targeting behaviour.

## Primary fields

- Event code: `4625`
- Source IP
- Username
- Host
- Timestamp
- Failure count

## Analytic logic

Group failed-authentication events by source IP and targeted account.

Escalate when repeated failures occur within a short investigation window.

## Context

This query is intended for authorized laboratory telemetry and should be tuned with organizational baselines and allow-lists before production deployment.
