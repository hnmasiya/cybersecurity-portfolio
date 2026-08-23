from conftest import load_module

enrichment = load_module("Security-Automation/Wazuh-Alert-Enrichment/Scripts/wazuh_alert_enrichment.py")


class TestSeverityForLevel:
    def test_critical_boundary(self):
        assert enrichment.severity_for_level(12) == ("CRITICAL", "P1", "ESCALATE")

    def test_just_below_critical_is_high(self):
        assert enrichment.severity_for_level(11) == ("HIGH", "P2", "ESCALATE")

    def test_high_boundary(self):
        assert enrichment.severity_for_level(9) == ("HIGH", "P2", "ESCALATE")

    def test_just_below_high_is_medium(self):
        assert enrichment.severity_for_level(8) == ("MEDIUM", "P3", "INVESTIGATE")

    def test_medium_boundary(self):
        assert enrichment.severity_for_level(6) == ("MEDIUM", "P3", "INVESTIGATE")

    def test_just_below_medium_is_low(self):
        assert enrichment.severity_for_level(5) == ("LOW", "P4", "MONITOR")

    def test_zero_and_negative_are_low(self):
        assert enrichment.severity_for_level(0) == ("LOW", "P4", "MONITOR")
        assert enrichment.severity_for_level(-1) == ("LOW", "P4", "MONITOR")

    def test_very_high_level_still_critical(self):
        assert enrichment.severity_for_level(15) == ("CRITICAL", "P1", "ESCALATE")


class TestExtractIocs:
    def test_finds_ipv4_and_domain(self):
        result = enrichment.extract_iocs("blocked 198.51.100.7 hitting bad.example.org")
        assert result["ipv4"] == ["198.51.100.7"]
        assert result["domains"] == ["bad.example.org"]


class TestMapMitre:
    def test_matches_known_group(self):
        hits = enrichment.map_mitre(["authentication_failed"])
        assert [h["technique"] for h in hits] == ["T1110"]

    def test_dedupes_same_technique_across_groups(self):
        # authentication_failed and authentication_failures both map to T1110
        hits = enrichment.map_mitre(["authentication_failed", "authentication_failures"])
        assert len(hits) == 1
        assert hits[0]["technique"] == "T1110"

    def test_unknown_group_yields_no_hits(self):
        assert enrichment.map_mitre(["totally_unknown_group"]) == []

    def test_multiple_distinct_techniques(self):
        hits = enrichment.map_mitre(["sudo", "recon"])
        techniques = {h["technique"] for h in hits}
        assert techniques == {"T1548", "T1595"}


class TestEnrichAlert:
    def test_full_alert_enrichment(self):
        alert = {
            "timestamp": "2026-01-01T00:00:00Z",
            "rule": {"id": "5710", "level": 10, "description": "brute force", "groups": ["authentication_failed"]},
            "agent": {"name": "web01"},
            "data": {"srcip": "203.0.113.9"},
            "full_log": "Failed login from 203.0.113.9",
        }
        result = enrichment.enrich_alert(alert)
        assert result["rule_level"] == 10
        assert result["severity"] == "HIGH"
        assert result["priority"] == "P2"
        assert result["disposition"] == "ESCALATE"
        assert result["agent"] == "web01"
        assert "203.0.113.9" in result["iocs"]["ipv4"]
        assert any(m["technique"] == "T1110" for m in result["mitre_attack"])

    def test_missing_nested_fields_default_safely(self):
        result = enrichment.enrich_alert({})
        assert result["rule_level"] == 0
        assert result["severity"] == "LOW"
        assert result["agent"] == ""
        assert result["mitre_attack"] == []

    def test_string_level_is_coerced_to_int(self):
        alert = {"rule": {"level": "9", "groups": []}}
        result = enrichment.enrich_alert(alert)
        assert result["rule_level"] == 9
        assert result["severity"] == "HIGH"

    def test_non_numeric_level_raises(self):
        # Documents current behavior: a malformed "level" field (e.g. from a
        # corrupt export) crashes int() rather than degrading gracefully.
        alert = {"rule": {"level": "not-a-number", "groups": []}}
        import pytest
        with pytest.raises(ValueError):
            enrichment.enrich_alert(alert)
