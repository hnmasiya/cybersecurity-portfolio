"""Build a recommendation-only triage packet from detection and correlation results."""
from __future__ import annotations

from datetime import datetime, timezone
from typing import Any


def build_triage_packet(correlation: dict[str, Any]) -> dict[str, Any]:
    """Return a reviewable incident summary; never performs response actions."""
    if not isinstance(correlation, dict):
        raise TypeError("correlation must be a dictionary")

    rules = correlation.get("alert_rule_ids", [])
    context = correlation.get("context_events", [])
    context_types = sorted({
        str(item.get("context_type"))
        for item in context
        if isinstance(item, dict) and item.get("context_type")
    })
    recommendations = [
        "Verify the alert against the original endpoint and SIEM records.",
        "Confirm the user, host, process ancestry, and UTC timeline with an analyst.",
        "Review correlated network and file events; do not infer successful transfer or execution from event proximity alone.",
        "Preserve relevant evidence according to the organization's incident-response procedure.",
    ]
    if "authentication" in context_types:
        recommendations.append("Review nearby authentication success/failure context and confirm account attribution.")
    recommendations.append("Obtain explicit incident-owner approval before any disruptive containment action.")

    return {
        "packet_version": 1,
        "created_utc": datetime.now(timezone.utc).isoformat(),
        "case_id": str(correlation.get("anchor_event_id", "UNASSIGNED")),
        "host": correlation.get("host"),
        "user": correlation.get("user"),
        "anchor_timestamp_utc": correlation.get("timestamp_utc"),
        "rule_ids": list(rules) if isinstance(rules, list) else [],
        "context_event_ids": [
            item.get("event_id") for item in context if isinstance(item, dict)
        ],
        "context_types": context_types,
        "assessment": "analyst review required; correlation is contextual evidence only",
        "recommended_actions": recommendations,
        "approval_required_before_disruption": True,
        "automated_containment_performed": False,
        "evidence_state": "synthetic-or-lab-dependent; verify source before operational use",
        "limitations": list(correlation.get("limitations", [])),
    }
