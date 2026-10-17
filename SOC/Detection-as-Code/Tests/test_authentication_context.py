import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
FIXTURE = ROOT / "fixtures" / "authentication-context-synthetic.json"


class AuthenticationContextTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.events = json.loads(FIXTURE.read_text(encoding="utf-8"))

    def test_fixture_contains_success_failure_and_benign_control(self):
        self.assertEqual([event["event_code"] for event in self.events], ["4625", "4624", "4624"])
        self.assertEqual(
            [event["expected_classification"] for event in self.events],
            ["authentication-failure-context", "authentication-success-context", "benign-control"],
        )
        self.assertTrue(all(event["evidence_type"].startswith("synthetic") for event in self.events))

    def test_documentation_ip_is_not_treated_as_real_indicator(self):
        self.assertEqual(self.events[0]["source_ip"], "192.0.2.77")
        self.assertIn("not a real IOC", self.events[0]["notes"])


if __name__ == "__main__":
    unittest.main()
