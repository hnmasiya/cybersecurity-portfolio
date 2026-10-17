import json
import unittest
from pathlib import Path

from detections.detection_engine import detect_event


ROOT = Path(__file__).resolve().parents[1]
FIXTURE_PATH = ROOT / "fixtures" / "ir-001-synthetic-timeline.json"


class IR001CaseTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.events = json.loads(FIXTURE_PATH.read_text(encoding="utf-8"))

    def test_fixture_contains_expected_synthetic_timeline(self):
        self.assertEqual(
            [event["event_id"] for event in self.events],
            ["IR001-E001", "IR001-E002", "IR001-E003", "IR001-E004"],
        )
        self.assertTrue(all(event["evidence_type"].startswith("synthetic") for event in self.events))

    def test_word_to_encoded_powershell_produces_de001(self):
        event = self.events[0]
        alerts = detect_event(event)
        self.assertEqual([alert["rule_id"] for alert in alerts], ["DE-001"])
        self.assertIn("WINWORD.EXE", event["ParentImage"])
        self.assertEqual(event["event_code"], "4688")
        self.assertIn("[REDACTED]", event["CommandLine"])

    def test_network_and_file_records_are_present_but_not_misclassified_as_process_alerts(self):
        network, file_create = self.events[1:3]
        self.assertEqual((network["event_code"], network["destination_port"]), ("3", 443))
        self.assertEqual(file_create["event_code"], "11")
        self.assertEqual(detect_event(network), [])
        self.assertEqual(detect_event(file_create), [])

    def test_benign_powershell_control_does_not_alert(self):
        self.assertEqual(detect_event(self.events[3]), [])
        self.assertEqual(self.events[3]["evidence_type"], "synthetic-benign-control")


if __name__ == "__main__":
    unittest.main()
