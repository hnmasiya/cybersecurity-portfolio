from conftest import load_module

auditor = load_module("Linux-Security/Hardening-Lab/Scripts/linux_hardening_auditor.py")


class TestSshConfig:
    def test_root_login_yes_flagged_high(self):
        findings = auditor.audit_ssh_config({"PermitRootLogin": "yes"})
        assert any(f["check"] == "SSH-001" and f["severity"] == "HIGH" for f in findings)

    def test_root_login_without_password_also_flagged(self):
        findings = auditor.audit_ssh_config({"PermitRootLogin": "without-password"})
        assert any(f["check"] == "SSH-001" for f in findings)

    def test_root_login_no_not_flagged(self):
        findings = auditor.audit_ssh_config({"PermitRootLogin": "no"})
        assert findings == []

    def test_password_authentication_yes_flagged_medium(self):
        findings = auditor.audit_ssh_config({"PasswordAuthentication": "yes"})
        assert any(f["check"] == "SSH-002" and f["severity"] == "MEDIUM" for f in findings)

    def test_legacy_protocol_flagged(self):
        findings = auditor.audit_ssh_config({"Protocol": "1"})
        assert any(f["check"] == "SSH-003" for f in findings)

    def test_default_protocol_2_not_flagged(self):
        findings = auditor.audit_ssh_config({})
        assert findings == []


class TestSudoers:
    def test_unrestricted_nopasswd_flagged(self):
        entries = [{"user": "deploy", "commands": "ALL", "nopasswd": True}]
        findings = auditor.audit_sudoers(entries)
        assert len(findings) == 1
        assert findings[0]["check"] == "SUDO-001"
        assert findings[0]["severity"] == "HIGH"

    def test_scoped_nopasswd_not_flagged(self):
        entries = [{"user": "backup-svc", "commands": "/usr/bin/rsync", "nopasswd": True}]
        assert auditor.audit_sudoers(entries) == []

    def test_all_commands_without_nopasswd_not_flagged(self):
        entries = [{"user": "admin", "commands": "ALL", "nopasswd": False}]
        assert auditor.audit_sudoers(entries) == []


class TestFilePermissions:
    def test_world_writable_outside_tmp_flagged(self):
        findings = auditor.audit_file_permissions(["/var/www/html/uploads"], [], set())
        assert len(findings) == 1
        assert findings[0]["check"] == "PERM-001"

    def test_world_writable_inside_tmp_not_flagged(self):
        findings = auditor.audit_file_permissions(["/tmp/cache", "/var/tmp/x"], [], set())
        assert findings == []

    def test_unexpected_suid_binary_flagged(self):
        findings = auditor.audit_file_permissions([], ["/opt/app/helper"], {"/usr/bin/sudo"})
        assert len(findings) == 1
        assert findings[0]["check"] == "PERM-002"
        assert findings[0]["severity"] == "HIGH"

    def test_allowlisted_suid_binary_not_flagged(self):
        findings = auditor.audit_file_permissions([], ["/usr/bin/sudo"], {"/usr/bin/sudo"})
        assert findings == []


class TestServices:
    def test_risky_service_flagged(self):
        findings = auditor.audit_services(["telnet"])
        assert len(findings) == 1
        assert findings[0]["check"] == "SVC-001"

    def test_case_insensitive_match(self):
        findings = auditor.audit_services(["TELNET"])
        assert len(findings) == 1

    def test_normal_services_not_flagged(self):
        findings = auditor.audit_services(["sshd", "nginx", "cron"])
        assert findings == []


class TestFirewall:
    def test_inactive_firewall_flagged(self):
        findings = auditor.audit_firewall(False)
        assert len(findings) == 1
        assert findings[0]["check"] == "FW-001"

    def test_active_firewall_not_flagged(self):
        assert auditor.audit_firewall(True) == []


class TestAuditIntegration:
    def test_full_snapshot_aggregates_all_checks(self):
        snapshot = {
            "ssh_config": {"PermitRootLogin": "yes", "PasswordAuthentication": "yes"},
            "sudoers_entries": [{"user": "deploy", "commands": "ALL", "nopasswd": True}],
            "world_writable_files": ["/srv/data"],
            "suid_binaries": ["/opt/app/helper"],
            "expected_suid_allowlist": [],
            "running_services": ["telnet"],
            "firewall_active": False,
        }
        summary, findings = auditor.audit(snapshot)
        assert summary["findings"] == len(findings) == 7
        assert summary["high"] == 4
        assert summary["medium"] == 3

    def test_clean_snapshot_yields_no_findings(self):
        snapshot = {
            "ssh_config": {"PermitRootLogin": "no", "PasswordAuthentication": "no", "Protocol": "2"},
            "sudoers_entries": [{"user": "admin", "commands": "/usr/bin/systemctl", "nopasswd": True}],
            "world_writable_files": ["/tmp/scratch"],
            "suid_binaries": ["/usr/bin/sudo"],
            "expected_suid_allowlist": ["/usr/bin/sudo"],
            "running_services": ["sshd"],
            "firewall_active": True,
        }
        summary, findings = auditor.audit(snapshot)
        assert findings == []
        assert summary["findings"] == 0
