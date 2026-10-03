from conftest import load_module

analyzer = load_module("Network-Security/PCAP-Analysis/Scripts/pcap_soc_analyzer.py")


def row(host="benign.example.com", uri="/index.html", ua="Mozilla/5.0"):
    return {
        "frame.number": "1",
        "ip.src": "10.0.0.5",
        "ip.dst": "10.0.0.6",
        "http.host": host,
        "http.request.uri": uri,
        "http.user_agent": ua,
    }


class TestScoreRequest:
    def test_benign_request_scores_zero(self):
        score, reasons = analyzer.score_request(row())
        assert score == 0
        assert reasons == []

    def test_malicious_host_flagged(self):
        score, reasons = analyzer.score_request(row(host="malicious.example.test"))
        assert score == 3
        assert "synthetic suspicious host" in reasons

    def test_command_execution_pattern_flagged(self):
        score, reasons = analyzer.score_request(row(uri="/run?cmd=whoami"))
        assert score == 3

    def test_sql_injection_pattern_flagged(self):
        score, reasons = analyzer.score_request(row(uri="/login?user=admin&pass=x' OR '1'='1"))
        assert score == 3

    def test_sensitive_file_pattern_flagged(self):
        score, reasons = analyzer.score_request(row(uri="/download?file=/etc/passwd"))
        assert score == 3

    def test_scanner_user_agent_adds_partial_score(self):
        score, reasons = analyzer.score_request(row(ua="sqlmap scanner/1.0"))
        assert score == 2
        assert "scanner-like user agent" in reasons

    def test_uri_is_url_decoded_before_matching(self):
        score, _ = analyzer.score_request(row(uri="/etc%2Fpasswd"))
        # %2F decodes to '/', so this should match the sensitive-file pattern.
        assert score == 3

    def test_combined_indicators_stack_score(self):
        score, reasons = analyzer.score_request(
            row(host="malicious.example.test", uri="/etc/passwd", ua="scanner")
        )
        assert score == 3 + 3 + 2
        assert len(reasons) == 3


class TestFindSuspicious:
    def test_filters_out_low_score_rows(self):
        rows = [row(), row(ua="scanner")]  # score 0 and score 2, both below threshold 3
        assert analyzer.find_suspicious(rows) == []

    def test_keeps_rows_at_or_above_threshold(self):
        rows = [row(), row(host="malicious.example.test")]
        suspicious = analyzer.find_suspicious(rows)
        assert len(suspicious) == 1
        assert suspicious[0]["score"] == 3
        assert suspicious[0]["reasons"] == "synthetic suspicious host"

    def test_does_not_mutate_original_rows(self):
        rows = [row(host="malicious.example.test")]
        analyzer.find_suspicious(rows)
        assert "score" not in rows[0]
