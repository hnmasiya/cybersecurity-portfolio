"""Correlation helpers for synthetic Windows process, network, and file events.

This is a reference exercise, not a SIEM correlation engine. It uses only
explicit host/user keys and UTC timestamps; matches are investigative context,
not proof of malicious execution or successful data transfer.
"""
from __future__ import annotations

from datetime import datetime, timezone
from typing import Any

DEFAULT_WINDOW_SECONDS = 300


def _parse_timestamp(value: Any) -> datetime | None:
    if not isinstance(value, str) or not value.strip():
        return None
    normalized = value.strip()
    if normalized.endswith("Z"):
        normalized = normalized[:-1] + "+00:00"
    try:
        parsed = datetime.fromisoformat(normalized)
    except ValueError:
        return None
    if parsed.tzinfo is None:
        return None
    return parsed.astimezone(timezone.utc)


def correlate_process_alerts(
    events: list[dict[str, Any]],
    window_seconds: int = DEFAULT_WINDOW_SECONDS,
) -> list[dict[str, Any]]:
    """Return process-alert anchors with same-host/user nearby event context.

    Process creation must trigger a detection rule. Network and file events
    are attached only as context when their timestamps are parseable, their
    host matches, their user matches when both records provide a user, and
    they fall within the configured absolute time window.
    """
    if window_seconds < 0:
        raise ValueError("window_seconds must be non-negative")

    valid_events = [event for event in events if isinstance(event, dict)]
    # Keep timestamps aligned to event positions, not event IDs: IDs may be
    # duplicated or missing in imperfect source data.
    parsed = [
        _parse_timestamp(event.get("timestamp_utc"))
        for event in valid_events
    ]
    correlations: list[dict[str, Any]] = []

    from detections.detection_engine import detect_event

    for index, anchor in enumerate(valid_events):
        alerts = detect_event(anchor)
        if not alerts:
            continue
        anchor_id = str(anchor.get("event_id", f"index-{index}"))
        anchor_time = parsed[index]
        host = str(anchor.get("host", "")).strip().casefold()
        user = str(anchor.get("user", anchor.get("User", ""))).strip().casefold()
        if not anchor_time or not host:
            continue

        context = []
        for other_index, other in enumerate(valid_events):
            if other_index == index:
                continue
            other_id = str(other.get("event_id", f"index-{other_index}"))
            other_time = parsed[other_index]
            if not other_time or str(other.get("host", "")).strip().casefold() != host:
                continue
            other_user_value = str(other.get("user", other.get("User", ""))).strip().casefold()
            if user and other_user_value and user != other_user_value:
                continue
            if abs((other_time - anchor_time).total_seconds()) > window_seconds:
                continue

            event_code = str(other.get("event_code", ""))
            if event_code == "3" and other.get("destination_ip"):
                context_type = "network"
            elif event_code == "11" and other.get("target_filename"):
                context_type = "file"
            else:
                continue
            context.append({
                "event_id": other_id,
                "timestamp_utc": other.get("timestamp_utc"),
                "context_type": context_type,
                "event_code": event_code,
                "evidence_type": other.get("evidence_type", "unspecified"),
            })

        context.sort(key=lambda item: (item["timestamp_utc"] or "", item["event_id"]))
        correlations.append({
            "anchor_event_id": anchor_id,
            "host": anchor.get("host"),
            "user": anchor.get("user", anchor.get("User", "")),
            "timestamp_utc": anchor.get("timestamp_utc"),
            "alert_rule_ids": [alert["rule_id"] for alert in alerts],
            "context_events": context,
            "context_event_count": len(context),
            "assessment": "suspicious process alert with correlated telemetry; analyst review required",
            "limitations": [
                "correlation is based on host, optional user, and timestamp proximity only",
                "context does not prove network transfer, payload execution, or file maliciousness",
                "fixture results are synthetic and are not production telemetry",
            ],
        })
    return correlations
