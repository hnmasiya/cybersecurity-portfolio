#!/usr/bin/env python3

"""
SOC Authentication Log Analyzer

Purpose:
    Analyze SSH authentication events, reconstruct a timeline,
    identify failed-authentication sequences followed by success,
    and produce evidence-based findings.

This is a defensive analysis tool for the accompanying lab dataset.
"""

import json
from datetime import datetime
from pathlib import Path


BASE_DIR = Path(__file__).resolve().parent
LOG_FILE = BASE_DIR / "auth_logs.json"


def parse_timestamp(value):
    return datetime.fromisoformat(value.replace("Z", "+00:00"))


def load_events():
    with LOG_FILE.open("r", encoding="utf-8") as file:
        events = json.load(file)

    return sorted(events, key=lambda event: parse_timestamp(event["timestamp"]))


def analyze(events):
    print("=" * 70)
    print("SOC SSH AUTHENTICATION LOG ANALYSIS")
    print("=" * 70)

    print("\n[1] EVENT TIMELINE")
    for event in events:
        print(
            f'{event["timestamp"]} | '
            f'{event["src_ip"]} | '
            f'{event["user"]} | '
            f'{event["action"]} | '
            f'{event["service"]}'
        )

    print("\n[2] FAILED AUTHENTICATION ACTIVITY")

    failed = [event for event in events if event["action"] == "failed"]

    by_source = {}

    for event in failed:
        by_source.setdefault(event["src_ip"], []).append(event)

    for source, source_events in by_source.items():
        users = sorted({event["user"] for event in source_events})

        print(
            f"Source: {source} | "
            f"Failed attempts: {len(source_events)} | "
            f"Accounts targeted: {', '.join(users)}"
        )

        if len(source_events) > 1:
            first_failure = min(
                source_events,
                key=lambda event: parse_timestamp(event["timestamp"])
            )
            last_failure = max(
                source_events,
                key=lambda event: parse_timestamp(event["timestamp"])
            )

            failure_window = (
                parse_timestamp(last_failure["timestamp"])
                - parse_timestamp(first_failure["timestamp"])
            )

            print(
                f"Failure sequence window: "
                f"{int(failure_window.total_seconds())} seconds"
            )

    print("\n[3] FAILED → SUCCESS PATTERN")

    findings = []

    for success in events:
        if success["action"] != "success":
            continue

        success_time = parse_timestamp(success["timestamp"])

        related_failures = [
            event
            for event in failed
            if event["src_ip"] == success["src_ip"]
            and parse_timestamp(event["timestamp"]) <= success_time
        ]

        if related_failures:
            latest_failure = max(
                related_failures,
                key=lambda event: parse_timestamp(event["timestamp"])
            )

            delta = success_time - parse_timestamp(
                latest_failure["timestamp"]
            )

            findings.append(
                {
                    "source": success["src_ip"],
                    "user": success["user"],
                    "latest_failure": latest_failure["timestamp"],
                    "success": success["timestamp"],
                    "delay_seconds": int(delta.total_seconds()),
                }
            )

    if findings:
        for finding in findings:
            print(
                f'Source {finding["source"]} produced a successful '
                f'SSH authentication for {finding["user"]} '
                f'{finding["delay_seconds"]} seconds after the '
                f'latest failed authentication.'
            )
    else:
        print("No failed → success sequence identified.")

    print("\n[4] ANALYST ASSESSMENT")

    if findings:
        print(
            "Potential credential-guessing or credential-compromise "
            "indicator identified."
        )
        print(
            "The dataset does not independently establish a confirmed "
            "account compromise."
        )
    else:
        print("No suspicious failed → success sequence identified.")

    print("\n[5] INVESTIGATION LIMITATIONS")
    print(
        "Only the supplied authentication events were analyzed. "
        "No endpoint telemetry, command history, firewall logs, "
        "identity-provider records, or additional authentication "
        "events were available."
    )

    print("\nAnalysis complete.")


def main():
    events = load_events()
    analyze(events)


if __name__ == "__main__":
    main()
