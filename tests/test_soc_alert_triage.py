from conftest import load_module

triage = load_module("Security-Automation/SOC-Alert-Triage/Scripts/soc_alert_triage.py")


class TestExtractIocs:
    def test_finds_ipv4(self):
        result = triage.extract_iocs("connection from 10.0.0.5 observed")
        assert result["ipv4"] == ["10.0.0.5"]

    def test_dedupes_and_sorts_ipv4(self):
        result = triage.extract_iocs("10.0.0.5 talked to 10.0.0.5 then 1.2.3.4")
        assert result["ipv4"] == ["1.2.3.4", "10.0.0.5"]

    def test_finds_domain_and_excludes_ip(self):
        result = triage.extract_iocs("beacon to evil.example.com from 10.0.0.5")
        assert result["domains"] == ["evil.example.com"]
        assert "10.0.0.5" not in result["domains"]

    def test_finds_sha256_case_insensitive(self):
        h = "a" * 64
        result = triage.extract_iocs(f"hash observed: {h.upper()}")
        assert result["sha256"] == [h.upper()]

    def test_empty_text_yields_empty_iocs(self):
        result = triage.extract_iocs("")
        assert result == {"ipv4": [], "domains": [], "sha256": []}


class TestMapMitre:
    def test_matches_keyword_case_insensitively(self):
        hits = triage.map_mitre("Detected PowerShell execution on host")
        techniques = [h["technique"] for h in hits]
        assert "T1059.001" in techniques

    def test_matches_multiple_keywords(self):
        hits = triage.map_mitre("brute force attempt followed by lateral movement")
        techniques = {h["technique"] for h in hits}
        assert techniques == {"T1110", "T1021"}

    def test_no_keywords_yields_empty_list(self):
        assert triage.map_mitre("routine health check, nothing unusual") == []


class TestTriageAlert:
    def test_known_severity_maps_priority_and_disposition(self):
        alert = {"alert_id": "A1", "severity": "critical", "description": ""}
        result = triage.triage_alert(alert)
        assert result["severity"] == "CRITICAL"
        assert result["priority"] == "P1"
        assert result["disposition"] == "ESCALATE"

    def test_all_severity_levels(self):
        expected = {
            "CRITICAL": ("P1", "ESCALATE"),
            "HIGH": ("P2", "ESCALATE"),
            "MEDIUM": ("P3", "INVESTIGATE"),
            "LOW": ("P4", "MONITOR"),
        }
        for sev, (priority, disposition) in expected.items():
            result = triage.triage_alert({"severity": sev, "description": ""})
            assert result["priority"] == priority
            assert result["disposition"] == disposition

    def test_missing_severity_defaults_to_medium(self):
        result = triage.triage_alert({"description": ""})
        assert result["severity"] == "MEDIUM"
        assert result["priority"] == "P3"
        assert result["disposition"] == "INVESTIGATE"

    def test_unknown_severity_falls_back_to_medium(self):
        result = triage.triage_alert({"severity": "BOGUS", "description": ""})
        assert result["severity"] == "MEDIUM"

    def test_missing_fields_default_sensibly(self):
        result = triage.triage_alert({})
        assert result["alert_id"] == "UNKNOWN"
        assert result["timestamp"] == ""
        assert result["source"] == ""
        assert result["description"] == ""

    def test_description_drives_iocs_and_mitre(self):
        alert = {
            "severity": "HIGH",
            "description": "brute force from 203.0.113.5 against admin panel",
        }
        result = triage.triage_alert(alert)
        assert result["iocs"]["ipv4"] == ["203.0.113.5"]
        assert any(m["technique"] == "T1110" for m in result["mitre_attack"])
