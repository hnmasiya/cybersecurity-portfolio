"""Offline adapter for common Windows process-event JSON shapes."""
from __future__ import annotations
from typing import Any

ALIASES = {
    "Image": ("Image", "image", "NewProcessName", "process.executable"),
    "CommandLine": ("CommandLine", "commandLine", "command_line", "process.command_line"),
    "ParentImage": ("ParentImage", "parentImage", "ParentProcessName", "process.parent.executable"),
    "User": ("User", "user", "SubjectUserName", "user.name"),
    "ProcessId": ("ProcessId", "ProcessID", "processId", "process.pid"),
    "ParentProcessId": ("ParentProcessId", "ParentProcessID", "parentProcessId", "process.parent.pid"),
    "UtcTime": ("UtcTime", "UtcTimeStamp", "TimeCreated", "timestamp", "@timestamp"),
    "Computer": ("Computer", "ComputerName", "computer", "host.name"),
}

def _first(obj: dict[str, Any], names: tuple[str, ...]) -> Any:
    for name in names:
        value = obj.get(name)
        if value not in (None, ""):
            return value
    return None

def normalize_process_event(raw: dict[str, Any]) -> dict[str, Any]:
    """Normalize flat, EventData, win.eventdata, and data.win.eventdata examples.

    This is a best-effort teaching adapter, not a universal Wazuh/Sysmon parser.
    """
    candidates = [raw]
    data = raw.get("data")
    win = data.get("win") if isinstance(data, dict) else raw.get("win")
    if isinstance(win, dict) and isinstance(win.get("eventdata"), dict):
        candidates.insert(0, win["eventdata"])
    if isinstance(raw.get("EventData"), dict):
        candidates.insert(0, raw["EventData"])
    system = win.get("system", {}) if isinstance(win, dict) and isinstance(win.get("system"), dict) else {}
    out = {}
    for target, aliases in ALIASES.items():
        value = None
        for obj in candidates:
            value = _first(obj, aliases)
            if value is not None:
                break
        out[target] = str(value) if value is not None else ""
    event_id = _first(system, ("eventID", "eventId", "EventID"))
    if event_id is None:
        event_id = _first(raw, ("EventID", "event_id", "event.code"))
    out["EventID"] = str(event_id) if event_id is not None else ""
    out["mapping_status"] = "ready_for_reference_harness" if out["Image"] and out["CommandLine"] else "incomplete_required_fields"
    out["evidence_type"] = "offline-mapped-example"
    return out
