from conftest import load_module

validator = load_module(
    "Endpoint-Security/Windows-Sysmon-Detection-Lab/Scripts/offline_endpoint_validator.py"
)


class TestDetect:
    def test_encoded_powershell_command_triggers_edr001(self):
        event = {"image": "powershell.exe", "command_line": "-EncodedCommand ABC123"}
        alerts = validator.detect(event)
        assert ("EDR-001", "T1059.001", "high") in alerts

    def test_execution_policy_bypass_triggers_edr001(self):
        event = {"image": "powershell.exe", "command_line": "-ExecutionPolicy Bypass -File x.ps1"}
        alerts = validator.detect(event)
        assert ("EDR-001", "T1059.001", "high") in alerts

    def test_powershell_https_traffic_triggers_edr002(self):
        event = {"image": "powershell.exe", "command_line": "", "destination_port": 443}
        alerts = validator.detect(event)
        assert ("EDR-002", "T1059.001", "medium") in alerts

    def test_failed_logon_event_triggers_edr003(self):
        event = {"windows_event_id": 4625}
        alerts = validator.detect(event)
        assert ("EDR-003", "T1110", "medium") in alerts

    def test_powershell_parent_process_triggers_edr004(self):
        event = {"parent_process": "powershell.exe"}
        alerts = validator.detect(event)
        assert ("EDR-004", "T1059.001", "medium") in alerts

    def test_benign_event_triggers_no_alerts(self):
        event = {
            "image": "notepad.exe",
            "command_line": "notepad.exe readme.txt",
            "parent_process": "explorer.exe",
            "windows_event_id": 4688,
        }
        assert validator.detect(event) == []

    def test_case_insensitive_matching(self):
        event = {"image": "POWERSHELL.EXE", "command_line": "-EncodedCommand XYZ"}
        alerts = validator.detect(event)
        assert ("EDR-001", "T1059.001", "high") in alerts

    def test_multiple_rules_can_fire_together(self):
        event = {
            "image": "powershell.exe",
            "command_line": "-EncodedCommand ABC",
            "destination_port": 443,
            "parent_process": "powershell.exe",
        }
        alerts = validator.detect(event)
        names = [a[0] for a in alerts]
        assert set(names) == {"EDR-001", "EDR-002", "EDR-004"}
