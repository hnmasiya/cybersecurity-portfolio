import unittest
import json
from pathlib import Path

from detections.correlation_engine import correlate_process_alerts


class CorrelationEngineTests(unittest.TestCase):
    def setUp(self):
        self.events = [
            {
                "event_id": "E001",
                "timestamp_utc": "2026-10-17T10:00:00Z",
                "host": "WS-TEST-01",
                "user": "lab\\analyst",
                "Image": r"C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",
                "CommandLine": "powershell.exe -EncodedCommand SQBFAFgA",
                "evidence_type": "synthetic",
            },
            {
                "event_id": "E002",
                "timestamp_utc": "2026-10-17T10:01:00Z",
                "host": "WS-TEST-01",
                "user": "lab\\analyst",
                "event_code": "3",
                "destination_ip": "127.0.0.1",
                "evidence_type": "synthetic",
            },
            {
                "event_id": "E003",
                "timestamp_utc": "2026-10-17T10:02:00Z",
                "host": "WS-TEST-01",
                "user": "lab\\analyst",
                "event_code": "11",
                "target_filename": "marker.tmp",
                "evidence_type": "synthetic",
            },
            {
                "event_id": "E004",
                "timestamp_utc": "2026-10-17T10:03:00Z",
                "host": "WS-TEST-01",
                "user": "lab\\analyst",
                "Image": r"C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",
                "CommandLine": "powershell.exe -NoProfile -File inventory.ps1",
                "evidence_type": "synthetic-benign-control",
            },
        ]

    def test_correlates_in_window_network_and_file_context(self):
        results = correlate_process_alerts(self.events)
        self.assertEqual(len(results), 1)
        self.assertEqual(results[0]["alert_rule_ids"], ["DE-001"])
        self.assertEqual(
            {e["context_type"] for e in results[0]["context_events"]},
            {"network", "file"},
        )

    def test_duplicate_event_ids_do_not_override_timestamps(self):
        events = [dict(event) for event in self.events]
        events[1]["event_id"] = events[0]["event_id"]
        events[1]["timestamp_utc"] = "2026-10-17T10:30:00Z"
        results = correlate_process_alerts(events, window_seconds=300)
        self.assertEqual(len(results), 1)
        self.assertEqual(results[0]["context_event_count"], 1)
        self.assertEqual(results[0]["context_events"][0]["context_type"], "file")

    def test_different_host_is_not_correlated(self):
        events = [dict(event) for event in self.events]
        events[1]["host"] = "WS-OTHER-02"
        results = correlate_process_alerts(events)
        self.assertEqual(results[0]["context_event_count"], 1)
        self.assertEqual(results[0]["context_events"][0]["context_type"], "file")

    def test_user_mismatch_is_not_correlated_when_both_present(self):
        events = [dict(event) for event in self.events]
        events[1]["user"] = "different.user"
        results = correlate_process_alerts(events)
        self.assertEqual(results[0]["context_event_count"], 1)
        self.assertEqual(results[0]["context_events"][0]["context_type"], "file")

    def test_missing_timestamp_is_not_correlated(self):
        events = [dict(event) for event in self.events]
        events[1]["timestamp_utc"] = "not-a-time"
ROOT = Path(__file__).resolve().parents[1]
FIXTURES = ROOT / "fixtures" / "ir-001-synthetic-timeline.json"


class CorrelationEngineTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.events = json.loads(FIXTURES.read_text(encoding="utf-8"))

    def test_ir001_correlates_process_network_and_file_by_host_user_time(self):
        results = correlate_process_alerts(self.events, window_seconds=300)
        self.assertEqual(len(results), 1)
        result = results[0]
        self.assertEqual(result["anchor_event_id"], "IR001-E001")
        self.assertEqual(result["alert_rule_ids"], ["DE-001"])
        self.assertEqual(result["context_event_count"], 2)
        self.assertEqual(
            {event["context_type"] for event in result["context_events"]},
            {"network", "file"},
        )

    def test_different_host_is_not_correlated(self):
        events = [dict(event) for event in self.events]
        events[1]["host"] = "WS-OTHER-999"
        results = correlate_process_alerts(events)
        self.assertEqual(results[0]["context_event_count"], 1)
        self.assertEqual(
            [event["context_type"] for event in results[0]["context_events"]],
            ["file"],
        )

    def test_events_outside_window_are_not_correlated(self):
        events = [dict(event) for event in self.events]
        events[2]["timestamp_utc"] = "2026-10-17T10:30:00Z"
        results = correlate_process_alerts(events, window_seconds=300)
        self.assertEqual(results[0]["context_event_count"], 1)
        self.assertEqual(results[0]["context_events"][0]["context_type"], "network")

    def test_benign_power_shell_does_not_create_correlation_anchor(self):
        events = [self.events[3]]
        self.assertEqual(correlate_process_alerts(events), [])

    def test_missing_or_invalid_timestamps_do_not_correlate(self):
        events = [dict(event) for event in self.events]
        events[1]["timestamp_utc"] = "not-a-timestamp"
        results = correlate_process_alerts(events)
        self.assertEqual(results[0]["context_event_count"], 1)
        self.assertEqual(results[0]["context_events"][0]["context_type"], "file")

    def test_naive_timestamp_is_not_correlated(self):
        events = [dict(event) for event in self.events]
        events[1]["timestamp_utc"] = "2026-10-17T10:01:00"
    def test_user_mismatch_does_not_correlate_when_both_users_are_present(self):
        events = [dict(event) for event in self.events]
        events[1]["user"] = "different.user"
        results = correlate_process_alerts(events)
        self.assertEqual(results[0]["context_event_count"], 1)
        self.assertEqual(results[0]["context_events"][0]["context_type"], "file")

    def test_negative_window_is_rejected(self):
        with self.assertRaises(ValueError):
            correlate_process_alerts(self.events, window_seconds=-1)


if __name__ == "__main__":
    unittest.main()
