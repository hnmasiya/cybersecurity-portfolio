# Task 1 — Web Log Investigation

## Objective

Analyse supplied web activity logs to identify whether a suspicious user pattern was consistent with normal dashboard usage or automated activity.

## Normal Application Sequence

The simulated normal workflow established that a user would:

1. Request the dashboard root.
2. Receive the expected authentication response.
3. Open the login page.
4. Load the supporting CSS/JavaScript resources.
5. Submit the login request.
6. Return to the dashboard.
7. Load dashboard resources.
8. Request factory-status APIs.

The simulation also established that a new date/session required authentication and that the application did not use continuous push/polling behaviour as part of normal interactive use.

## Suspicious Activity

The suspicious activity was associated with:

- IP: `192.168.0.101`
- User ID: `mdB7yD2dp1BFZPontHBQ1Z`

The activity repeatedly requested the status APIs for all four factories:

- `meiyo`
- `seiko`
- `shenzhen`
- `berlin`

The requests appeared at precise hourly intervals, including the observed `HH:00:48` pattern, without the normal dashboard resource-loading sequence.

## Interpretation

The combination of precise periodic timing, repeated API access, coverage of all factory endpoints, and absence of normal browser resource requests is consistent with automated activity.

The correct security conclusion is to treat the pattern as suspicious and investigate the associated account, host, session and authorization context.

## Investigation Follow-up

A real SOC investigation should correlate the application evidence with:

- Authentication logs.
- VPN access records.
- Endpoint telemetry.
- Identity-provider activity.
- API gateway or reverse-proxy logs.
- Other activity from the same account and source host.

## Scope

This analysis is based on the controlled Forage simulation and its supplied evidence. No real Deloitte systems were accessed.
