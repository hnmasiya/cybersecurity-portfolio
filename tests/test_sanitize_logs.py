from conftest import load_module

sanitize = load_module("scripts/sanitize-logs.py")


class TestPrivateIpRedaction:
    def test_redacts_10_range(self):
        assert sanitize.sanitize_content("host 10.1.2.3 connected") == "host [REDACTED_PRIVATE_IP] connected"

    def test_redacts_192_168_range(self):
        assert sanitize.sanitize_content("host 192.168.0.1 connected") == "host [REDACTED_PRIVATE_IP] connected"

    def test_redacts_172_16_to_31_range(self):
        for second_octet in (16, 20, 31):
            ip = f"172.{second_octet}.0.1"
            assert "[REDACTED_PRIVATE_IP]" in sanitize.sanitize_content(f"host {ip}")

    def test_does_not_redact_172_15(self):
        # 172.15.0.1 is public (below the 172.16/12 private block) and must be preserved.
        result = sanitize.sanitize_content("host 172.15.0.1 connected")
        assert "172.15.0.1" in result
        assert "[REDACTED_PRIVATE_IP]" not in result

    def test_does_not_redact_172_32(self):
        # 172.32.0.1 is public (above the 172.16/12 private block) and must be preserved.
        result = sanitize.sanitize_content("host 172.32.0.1 connected")
        assert "172.32.0.1" in result
        assert "[REDACTED_PRIVATE_IP]" not in result

    def test_does_not_redact_public_ip(self):
        result = sanitize.sanitize_content("scanner hit 8.8.8.8")
        assert "8.8.8.8" in result
        assert "[REDACTED_PRIVATE_IP]" not in result


class TestSecretRedaction:
    def test_redacts_api_key_assignment(self):
        result = sanitize.sanitize_content('api_key: "abcdefghij1234567890"')
        assert "[REDACTED_SECRET]" in result
        assert "abcdefghij1234567890" not in result

    def test_redacts_bearer_token(self):
        result = sanitize.sanitize_content("Authorization: Bearer abcdefghijklmnopqrstuvwxyz012345")
        assert "[REDACTED_SECRET]" in result

    def test_short_token_under_20_chars_not_redacted(self):
        # Below the 20-char threshold, the secret pattern intentionally doesn't match.
        result = sanitize.sanitize_content("token: short1234567")
        assert "[REDACTED_SECRET]" not in result

    def test_case_insensitive_key_label(self):
        result = sanitize.sanitize_content('SECRET=abcdefghij1234567890abcdef')
        assert "[REDACTED_SECRET]" in result


class TestCombined:
    def test_leaves_unrelated_text_untouched(self):
        text = "2026-01-01 INFO: service started normally"
        assert sanitize.sanitize_content(text) == text

    def test_redacts_multiple_occurrences(self):
        text = "10.0.0.1 talked to 192.168.1.1"
        result = sanitize.sanitize_content(text)
        assert result == "[REDACTED_PRIVATE_IP] talked to [REDACTED_PRIVATE_IP]"
