from conftest import load_module

validator = load_module("Threat-Hunting/Detection-Validation-Lab/Scripts/offline_hunt_validator.py")


class TestHunt001BruteForce:
    def test_below_threshold_fails(self):
        events = [{"event_code": 4625, "src_ip": "10.0.0.1"} for _ in range(2)]
        results, failures = validator.run_hunts(events)
        assert failures == 1
        assert results[0]["status"] == "FAIL"

    def test_at_threshold_passes(self):
        events = [{"event_code": 4625, "src_ip": "10.0.0.1"} for _ in range(3)]
        results, failures = validator.run_hunts(events)
        assert failures == 0
        assert results[0]["status"] == "PASS"
        assert results[0]["count"] == 3

    def test_no_failed_auth_events_yields_no_hunt001_results(self):
        events = [{"event_code": 4624, "src_ip": "10.0.0.1"}]
        results, failures = validator.run_hunts(events)
        assert results == []
        assert failures == 0


class TestHunt002EncodedPowershell:
    def test_encoded_command_passes(self):
        events = [{"image": "powershell.exe", "command_line": "-EncodedCommand ABC", "event_id": "E1"}]
        results, failures = validator.run_hunts(events)
        hunt2 = [r for r in results if r["hunt"] == "HUNT-002"]
        assert len(hunt2) == 1
        assert hunt2[0]["status"] == "PASS"

    def test_plain_powershell_command_no_hunt002(self):
        events = [{"image": "powershell.exe", "command_line": "Get-Process", "event_id": "E1"}]
        results, failures = validator.run_hunts(events)
        assert [r for r in results if r["hunt"] == "HUNT-002"] == []


class TestHunt003PowershellNetwork:
    def test_https_destination_passes(self):
        events = [{"image": "powershell.exe", "command_line": "", "destination_port": 443, "event_id": "E2"}]
        results, failures = validator.run_hunts(events)
        hunt3 = [r for r in results if r["hunt"] == "HUNT-003"]
        assert len(hunt3) == 1
        assert hunt3[0]["status"] == "PASS"

    def test_non_https_port_no_hunt003(self):
        events = [{"image": "powershell.exe", "command_line": "", "destination_port": 80, "event_id": "E2"}]
        results, failures = validator.run_hunts(events)
        assert [r for r in results if r["hunt"] == "HUNT-003"] == []


class TestRunHuntsOverall:
    def test_only_failed_hunts_count_toward_failures(self):
        events = [
            {"event_code": 4625, "src_ip": "10.0.0.1"},  # below threshold -> FAIL
            {"image": "powershell.exe", "command_line": "-EncodedCommand X", "event_id": "E1"},  # PASS
        ]
        results, failures = validator.run_hunts(events)
        assert failures == 1
        assert len(results) == 2

    def test_empty_events_yields_no_results_no_failures(self):
        results, failures = validator.run_hunts([])
        assert results == []
        assert failures == 0
