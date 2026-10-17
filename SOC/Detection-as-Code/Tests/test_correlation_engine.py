import json
import unittest
from pathlib import Path

from detections.correlation_engine import correlate_process_alerts


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
