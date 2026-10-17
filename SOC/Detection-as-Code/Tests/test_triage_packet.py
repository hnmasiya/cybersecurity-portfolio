import unittest

from detections.triage_packet import build_triage_packet


class TriagePacketTests(unittest.TestCase):
    def test_packet_summarizes_case_and_requires_approval(self):
        packet = build_triage_packet({
            "anchor_event_id": "IR001-E001",
            "host": "WS-FIN-023",
            "user": "finance.user",
            "timestamp_utc": "2026-10-17T09:14:22Z",
            "alert_rule_ids": ["DE-001"],
            "context_events": [
                {"event_id": "IR001-E002", "context_type": "network"},
                {"event_id": "IR001-E003", "context_type": "file"},
            ],
            "limitations": ["synthetic fixture"],
        })
        self.assertEqual(packet["case_id"], "IR001-E001")
        self.assertEqual(packet["context_event_ids"], ["IR001-E002", "IR001-E003"])
        self.assertTrue(packet["approval_required_before_disruption"])
        self.assertFalse(packet["automated_containment_performed"])
        self.assertTrue(any("analyst" in item.lower() for item in packet["recommended_actions"]))

    def test_authentication_context_adds_review_recommendation(self):
        packet = build_triage_packet({
            "anchor_event_id": "AUTH-CASE-1",
            "alert_rule_ids": ["DE-001"],
            "context_events": [{"event_id": "AUTH-E1", "context_type": "authentication"}],
        })
        self.assertTrue(any("authentication" in item.lower() for item in packet["recommended_actions"]))

    def test_invalid_input_rejected(self):
        with self.assertRaises(TypeError):
            build_triage_packet([])


if __name__ == "__main__":
    unittest.main()
