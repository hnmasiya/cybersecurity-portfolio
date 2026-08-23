from conftest import load_module

detector = load_module("Security-Automation/Log-Anomaly-Detection/Scripts/log_anomaly_detector.py")


def failed_line(host, ip, ts="Jan  1 02:00:00", user="root"):
    return f"{ts} {host} sshd[123]: Failed password for {user} from {ip} port 4444 ssh2"


def accepted_line(host, ip, ts="Jan  1 03:00:00", user="admin"):
    return f"{ts} {host} sshd[123]: Accepted password for {user} from {ip} port 4444 ssh2"


def sudo_line(host, user="alice", command="/usr/bin/whoami", ts="Jan  1 12:00:00"):
    return f"{ts} {host} sudo: {user} : TTY=pts/0 ; PWD=/home/alice ; USER=root ; COMMAND={command}"


class TestParseHour:
    def test_parses_hour_from_timestamp(self):
        assert detector.parse_hour("Jan  1 23:59:59") == 23

    def test_parses_midnight(self):
        assert detector.parse_hour("Jan  1 00:00:00") == 0


class TestAnalyzeBruteForce:
    def test_below_threshold_no_anomaly(self):
        lines = [failed_line("host1", "10.0.0.9") for _ in range(4)]
        summary, anomalies = detector.analyze(lines)
        assert summary["anomalies_detected"] == 0
        assert anomalies == []

    def test_at_threshold_flags_brute_force(self):
        lines = [failed_line("host1", "10.0.0.9") for _ in range(5)]
        summary, anomalies = detector.analyze(lines)
        brute = [a for a in anomalies if a["anomaly"] == "Brute Force Login Attempt"]
        assert len(brute) == 1
        assert brute[0]["source_ip"] == "10.0.0.9"
        assert brute[0]["failed_attempts"] == 5
        assert summary["high"] == 1

    def test_counts_are_per_source_ip(self):
        lines = [failed_line("host1", "10.0.0.1") for _ in range(5)] + \
                [failed_line("host1", "10.0.0.2") for _ in range(2)]
        summary, anomalies = detector.analyze(lines)
        brute = [a for a in anomalies if a["anomaly"] == "Brute Force Login Attempt"]
        assert len(brute) == 1
        assert brute[0]["source_ip"] == "10.0.0.1"


class TestAnalyzeOffHours:
    def test_login_at_hour_zero_is_off_hours(self):
        lines = [accepted_line("host1", "10.0.0.5", ts="Jan  1 00:30:00")]
        summary, anomalies = detector.analyze(lines)
        assert any(a["anomaly"] == "Off-Hours Successful Login" for a in anomalies)

    def test_login_at_hour_six_is_not_off_hours(self):
        lines = [accepted_line("host1", "10.0.0.5", ts="Jan  1 06:00:00")]
        summary, anomalies = detector.analyze(lines)
        assert not any(a["anomaly"] == "Off-Hours Successful Login" for a in anomalies)

    def test_login_at_hour_five_is_off_hours(self):
        lines = [accepted_line("host1", "10.0.0.5", ts="Jan  1 05:59:00")]
        summary, anomalies = detector.analyze(lines)
        assert any(a["anomaly"] == "Off-Hours Successful Login" for a in anomalies)

    def test_daytime_login_is_not_anomalous(self):
        lines = [accepted_line("host1", "10.0.0.5", ts="Jan  1 14:00:00")]
        summary, anomalies = detector.analyze(lines)
        assert anomalies == []


class TestAnalyzePrivilegedCommand:
    def test_sudo_command_is_flagged(self):
        lines = [sudo_line("host1", user="alice", command="/bin/cat /etc/shadow")]
        summary, anomalies = detector.analyze(lines)
        assert len(anomalies) == 1
        assert anomalies[0]["anomaly"] == "Privileged Command Execution"
        assert anomalies[0]["user"] == "alice"
        assert anomalies[0]["command"] == "/bin/cat /etc/shadow"


class TestAnalyzeRobustness:
    def test_blank_and_malformed_lines_are_skipped(self):
        lines = ["", "   ", "this is not a syslog line at all"]
        summary, anomalies = detector.analyze(lines)
        assert summary["lines_parsed"] == 0
        assert anomalies == []

    def test_summary_counts_match_anomaly_severities(self):
        lines = (
            [failed_line("host1", "10.0.0.1") for _ in range(5)]
            + [accepted_line("host1", "10.0.0.2", ts="Jan  1 01:00:00")]
            + [sudo_line("host1")]
        )
        summary, anomalies = detector.analyze(lines)
        assert summary["anomalies_detected"] == len(anomalies) == 3
        assert summary["high"] == 1
        assert summary["medium"] == 1
        assert summary["low"] == 1
