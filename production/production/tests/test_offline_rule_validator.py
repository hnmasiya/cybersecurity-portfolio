from conftest import load_module

validator = load_module("SIEM/Wazuh/Detection-Engineering-Lab/Scripts/offline_rule_validator.py")

RULE_XML = """<group>
  <rule id="100010" level="10">
    <if_sid>5710</if_sid>
    <match>Failed password</match>
  </rule>
</group>
"""

RULE_XML_NO_MATCH = """<group>
  <rule id="100020" level="5">
  </rule>
</group>
"""


class TestLoadRule:
    def test_parses_rule_fields(self, tmp_path):
        f = tmp_path / "rule.xml"
        f.write_text(RULE_XML)
        rule = validator.load_rule(f)
        assert rule == {"id": "100010", "level": "10", "match": "Failed password", "if_sid": "5710"}

    def test_missing_match_and_if_sid_are_none(self, tmp_path):
        f = tmp_path / "rule.xml"
        f.write_text(RULE_XML_NO_MATCH)
        rule = validator.load_rule(f)
        assert rule["match"] is None
        assert rule["if_sid"] is None


class TestMatchingRules:
    def test_matches_on_if_sid_and_match_text(self):
        rules = [{"id": "1", "if_sid": "5710", "match": "Failed password"}]
        event = {"base_sid": "5710", "message": "Failed password for root"}
        assert validator.matching_rules(rules, event) == ["1"]

    def test_wrong_base_sid_excludes_rule(self):
        rules = [{"id": "1", "if_sid": "5710", "match": None}]
        event = {"base_sid": "9999", "message": "anything"}
        assert validator.matching_rules(rules, event) == []

    def test_match_text_not_present_excludes_rule(self):
        rules = [{"id": "1", "if_sid": None, "match": "Failed password"}]
        event = {"base_sid": "0", "message": "Accepted password for root"}
        assert validator.matching_rules(rules, event) == []

    def test_rule_with_no_criteria_matches_everything(self):
        rules = [{"id": "1", "if_sid": None, "match": None}]
        event = {"base_sid": "0", "message": "anything at all"}
        assert validator.matching_rules(rules, event) == ["1"]

    def test_multiple_rules_can_all_match(self):
        rules = [
            {"id": "1", "if_sid": None, "match": "Failed"},
            {"id": "2", "if_sid": None, "match": "password"},
        ]
        event = {"base_sid": "0", "message": "Failed password for root"}
        assert validator.matching_rules(rules, event) == ["1", "2"]
