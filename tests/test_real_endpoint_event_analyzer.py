import json

from conftest import load_module

analyzer = load_module("Endpoint-Security/Windows-Sysmon-Detection-Lab/Scripts/real_endpoint_event_analyzer.py")


def run_main(tmp_path, events, monkeypatch, capsys):
    input_path = tmp_path / "events.json"
    output_path = tmp_path / "output.json"
    input_path.write_text(json.dumps(events))

    monkeypatch.setattr(
        "sys.argv",
        ["real_endpoint_event_analyzer.py", "--input", str(input_path), "--output", str(output_path)],
    )
    analyzer.main()
    return json.loads(output_path.read_text())


class TestRealEndpointEventAnalyzer:
    def test_flags_powershell_with_encoded_command(self, tmp_path, monkeypatch, capsys):
        events = [{"windows_event_id": 1, "image": "powershell.exe", "command_line": "powershell -EncodedCommand abc123"}]
        result = run_main(tmp_path, events, monkeypatch, capsys)
        assert result["summary"]["findings"] == 1
        assert result["findings"][0]["rule_id"] == "EDR-001"
        assert result["findings"][0]["mitre_technique"] == "T1059.001"

    def test_flags_powershell_https_connection(self, tmp_path, monkeypatch, capsys):
        events = [{"windows_event_id": 3, "image": "powershell.exe", "destination_port": 443}]
        result = run_main(tmp_path, events, monkeypatch, capsys)
        assert result["summary"]["findings"] == 1
        assert result["findings"][0]["rule_id"] == "EDR-002"

    def test_flags_failed_logon(self, tmp_path, monkeypatch, capsys):
        events = [{"windows_event_id": 4625}]
        result = run_main(tmp_path, events, monkeypatch, capsys)
        assert result["summary"]["findings"] == 1
        assert result["findings"][0]["rule_id"] == "EDR-003"

    def test_flags_process_spawned_by_powershell(self, tmp_path, monkeypatch, capsys):
        events = [{"windows_event_id": 1, "image": "cmd.exe", "parent_process": "powershell.exe"}]
        result = run_main(tmp_path, events, monkeypatch, capsys)
        assert result["summary"]["findings"] == 1
        assert result["findings"][0]["rule_id"] == "EDR-004"

    def test_benign_event_produces_no_findings(self, tmp_path, monkeypatch, capsys):
        events = [{"windows_event_id": 1, "image": "notepad.exe", "command_line": "notepad.exe", "parent_process": "explorer.exe"}]
        result = run_main(tmp_path, events, monkeypatch, capsys)
        assert result["summary"]["findings"] == 0

    def test_summary_counts_by_severity(self, tmp_path, monkeypatch, capsys):
        events = [
            {"windows_event_id": 4625},
            {"windows_event_id": 3, "image": "powershell.exe", "destination_port": 443},
        ]
        result = run_main(tmp_path, events, monkeypatch, capsys)
        assert result["summary"]["events_analyzed"] == 2
        assert result["summary"]["medium"] == 2
        assert result["summary"]["high"] == 0

    def test_empty_input(self, tmp_path, monkeypatch, capsys):
        result = run_main(tmp_path, [], monkeypatch, capsys)
        assert result["summary"] == {"events_analyzed": 0, "findings": 0, "high": 0, "medium": 0}
