from conftest import load_module

analyzer = load_module("Active-Directory/Detection-Lab/Scripts/ad_security_event_analyzer.py")


def failed_logon(user, ts="2026-08-20T09:00:00Z"):
    return {"timestamp": ts, "event_id": 4625, "target_user": user}


def preauth_failure(user, ts="2026-08-20T09:00:00Z"):
    return {"timestamp": ts, "event_id": 4771, "target_user": user}


def tgs_request(user, service, enc="0x17", ts="2026-08-20T09:00:00Z"):
    return {"timestamp": ts, "event_id": 4769, "target_user": user, "service_name": service, "encryption_type": enc}


class TestBruteForce:
    def test_below_threshold_no_finding(self):
        events = [failed_logon("bob") for _ in range(4)]
        summary, findings = analyzer.analyze(events)
        assert findings == []
        assert summary["findings"] == 0

    def test_at_threshold_flags_brute_force(self):
        events = [failed_logon("bob") for _ in range(5)]
        summary, findings = analyzer.analyze(events)
        assert len(findings) == 1
        assert findings[0]["finding"] == "Brute Force Authentication Attempt"
        assert findings[0]["severity"] == "HIGH"
        assert findings[0]["failed_attempts"] == 5
        assert findings[0]["mitre_attack"]["technique"] == "T1110"

    def test_counts_are_per_user(self):
        events = [failed_logon("bob") for _ in range(5)] + [failed_logon("alice") for _ in range(2)]
        summary, findings = analyzer.analyze(events)
        assert len(findings) == 1
        assert findings[0]["target_user"] == "bob"


class TestPreauthFailureBurst:
    def test_below_threshold_no_finding(self):
        events = [preauth_failure("svc-sql") for _ in range(4)]
        _, findings = analyzer.analyze(events)
        assert findings == []

    def test_at_threshold_flags_burst(self):
        events = [preauth_failure("svc-sql") for _ in range(5)]
        _, findings = analyzer.analyze(events)
        assert len(findings) == 1
        assert findings[0]["finding"] == "Kerberos Pre-Authentication Failure Burst"
        assert findings[0]["severity"] == "HIGH"


class TestKerberoasting:
    def test_three_distinct_rc4_services_flags_kerberoasting(self):
        events = [
            tgs_request("asmith", "MSSQLSvc/db01.corp.local"),
            tgs_request("asmith", "HTTP/web01.corp.local"),
            tgs_request("asmith", "CIFS/fs01.corp.local"),
        ]
        _, findings = analyzer.analyze(events)
        assert len(findings) == 1
        assert findings[0]["finding"] == "Possible Kerberoasting Activity"
        assert findings[0]["mitre_attack"]["technique"] == "T1558.003"
        assert findings[0]["distinct_service_tickets"] == 3

    def test_non_rc4_service_tickets_not_flagged(self):
        events = [
            tgs_request("svc-web", "HTTP/web01.corp.local", enc="0x12"),
            tgs_request("svc-web", "HTTP/web02.corp.local", enc="0x12"),
            tgs_request("svc-web", "HTTP/web03.corp.local", enc="0x12"),
        ]
        _, findings = analyzer.analyze(events)
        assert findings == []

    def test_below_service_count_threshold_not_flagged(self):
        events = [
            tgs_request("asmith", "HTTP/web01.corp.local"),
            tgs_request("asmith", "HTTP/web02.corp.local"),
        ]
        _, findings = analyzer.analyze(events)
        assert findings == []


class TestPrivilegedGroupChange:
    def test_flags_each_group_event_type(self):
        for event_id in (4728, 4732, 4756):
            events = [{"timestamp": "t", "event_id": event_id, "target_user": "u", "group_name": "Domain Admins", "subject_user": "admin"}]
            _, findings = analyzer.analyze(events)
            assert len(findings) == 1
            assert findings[0]["finding"] == "Privileged Group Membership Change"
            assert findings[0]["mitre_attack"]["technique"] == "T1098"


class TestAccountCreationAndPrivileges:
    def test_account_creation_flagged_medium(self):
        events = [{"timestamp": "t", "event_id": 4720, "target_user": "svc-new", "subject_user": "admin"}]
        _, findings = analyzer.analyze(events)
        assert findings[0]["finding"] == "New User Account Created"
        assert findings[0]["severity"] == "MEDIUM"
        assert findings[0]["mitre_attack"]["technique"] == "T1136"

    def test_special_privileges_flagged_medium(self):
        events = [{"timestamp": "t", "event_id": 4672, "target_user": "svc-new"}]
        _, findings = analyzer.analyze(events)
        assert findings[0]["finding"] == "Special Privileges Assigned to New Logon"
        assert findings[0]["severity"] == "MEDIUM"


class TestAuditLogCleared:
    def test_flagged_critical(self):
        events = [{"timestamp": "t", "event_id": 1102, "subject_user": "admin"}]
        _, findings = analyzer.analyze(events)
        assert findings[0]["finding"] == "Security Audit Log Cleared"
        assert findings[0]["severity"] == "CRITICAL"
        assert findings[0]["mitre_attack"]["technique"] == "T1070.001"


class TestBenignActivity:
    def test_successful_logon_alone_not_flagged(self):
        events = [{"timestamp": "t", "event_id": 4624, "target_user": "jdoe"}]
        _, findings = analyzer.analyze(events)
        assert findings == []

    def test_empty_event_list(self):
        summary, findings = analyzer.analyze([])
        assert findings == []
        assert summary == {"events_analyzed": 0, "findings": 0, "critical": 0, "high": 0, "medium": 0}


class TestSummaryCounts:
    def test_summary_matches_finding_severities(self):
        events = (
            [failed_logon("bob") for _ in range(5)]
            + [{"timestamp": "t", "event_id": 1102, "subject_user": "admin"}]
            + [{"timestamp": "t", "event_id": 4720, "target_user": "svc-new", "subject_user": "admin"}]
        )
        summary, findings = analyzer.analyze(events)
        assert summary["events_analyzed"] == len(events)
        assert summary["findings"] == len(findings) == 3
        assert summary["critical"] == 1
        assert summary["high"] == 1
        assert summary["medium"] == 1
