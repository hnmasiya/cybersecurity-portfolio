from conftest import load_module

ad_parser = load_module("Scripts/log-parsers/ad_event_parser.py")


class TestParseEvent:
    def test_known_failed_login_event(self):
        assert "T1110" in ad_parser.parse_event(4625)

    def test_known_group_membership_event(self):
        assert "T1098" in ad_parser.parse_event(4728)

    def test_known_successful_login_event(self):
        result = ad_parser.parse_event(4624)
        assert result.startswith("INFO")

    def test_unknown_event_id_falls_back_to_generic_info(self):
        assert ad_parser.parse_event(9999) == "INFO: Standard Event Logged"
