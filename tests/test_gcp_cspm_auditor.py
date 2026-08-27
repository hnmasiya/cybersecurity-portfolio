from conftest import load_module

auditor = load_module("Cloud-Security/GCP-Project-Security-Lab/Scripts/gcp_cspm_auditor.py")


def firewall_rule(**overrides):
    base = {
        "name": "allow-internal",
        "direction": "INGRESS",
        "disabled": False,
        "source_ranges": ["10.20.0.0/24"],
        "allowed": [{"protocol": "tcp", "ports": ["22"]}],
    }
    base.update(overrides)
    return base


def bucket(**overrides):
    base = {
        "name": "lab-bucket",
        "uniform_bucket_level_access": True,
        "public_access_prevention": "enforced",
        "iam_bindings": [{"role": "roles/storage.objectViewer", "members": ["user:analyst@example.com"]}],
    }
    base.update(overrides)
    return base


def instance(**overrides):
    base = {
        "name": "hardened-lab-vm",
        "has_external_ip": False,
        "shielded_secure_boot": True,
        "shielded_vtpm": True,
        "shielded_integrity_monitoring": True,
        "service_account_email": "lab-vm-sa@my-project.iam.gserviceaccount.com",
        "service_account_scopes": ["https://www.googleapis.com/auth/cloud-platform"],
    }
    base.update(overrides)
    return base


class TestAuditFirewallRule:
    def test_open_ingress_flagged(self):
        findings = auditor.audit_firewall_rule(firewall_rule(source_ranges=["0.0.0.0/0"]))
        assert len(findings) == 1
        assert findings[0]["check"] == "GCP-001"
        assert findings[0]["mitre_attack"]["technique"] == "T1190"

    def test_scoped_source_not_flagged(self):
        assert auditor.audit_firewall_rule(firewall_rule()) == []

    def test_disabled_rule_not_flagged(self):
        assert auditor.audit_firewall_rule(firewall_rule(source_ranges=["0.0.0.0/0"], disabled=True)) == []

    def test_egress_rule_not_flagged(self):
        assert auditor.audit_firewall_rule(firewall_rule(source_ranges=["0.0.0.0/0"], direction="EGRESS")) == []

    def test_deny_rule_with_no_allowed_not_flagged(self):
        assert auditor.audit_firewall_rule(firewall_rule(source_ranges=["0.0.0.0/0"], allowed=[])) == []


class TestAuditBucket:
    def test_hardened_bucket_not_flagged(self):
        assert auditor.audit_bucket(bucket()) == []

    def test_missing_uniform_access_flagged(self):
        findings = auditor.audit_bucket(bucket(uniform_bucket_level_access=False))
        assert any(f["check"] == "GCP-002" for f in findings)

    def test_missing_public_access_prevention_flagged(self):
        findings = auditor.audit_bucket(bucket(public_access_prevention="inherited"))
        assert any(f["check"] == "GCP-003" for f in findings)

    def test_public_iam_binding_flagged(self):
        findings = auditor.audit_bucket(
            bucket(iam_bindings=[{"role": "roles/storage.objectViewer", "members": ["allUsers"]}])
        )
        assert any(f["check"] == "GCP-004" and f["severity"] == "CRITICAL" for f in findings)


class TestAuditInstance:
    def test_hardened_instance_not_flagged(self):
        assert auditor.audit_instance(instance()) == []

    def test_external_ip_flagged(self):
        findings = auditor.audit_instance(instance(has_external_ip=True))
        assert any(f["check"] == "GCP-005" for f in findings)

    def test_shielded_vm_disabled_flagged(self):
        findings = auditor.audit_instance(instance(shielded_secure_boot=False))
        assert any(f["check"] == "GCP-006" and "shielded_secure_boot" in f["detail"] for f in findings)

    def test_default_compute_service_account_flagged(self):
        findings = auditor.audit_instance(
            instance(service_account_email="123456789-compute@developer.gserviceaccount.com")
        )
        assert any(f["check"] == "GCP-007" for f in findings)

    def test_custom_service_account_not_flagged_for_gcp007(self):
        findings = auditor.audit_instance(instance())
        assert not any(f["check"] == "GCP-007" for f in findings)


class TestAuditProjectIam:
    def test_owner_to_public_flagged(self):
        findings = auditor.audit_project_iam([{"role": "roles/owner", "members": ["allUsers"]}])
        assert len(findings) == 1
        assert findings[0]["check"] == "GCP-008"

    def test_owner_to_real_user_not_flagged(self):
        findings = auditor.audit_project_iam([{"role": "roles/owner", "members": ["user:me@example.com"]}])
        assert findings == []

    def test_non_primitive_role_not_flagged(self):
        findings = auditor.audit_project_iam([{"role": "roles/viewer", "members": ["allUsers"]}])
        assert findings == []


class TestAudit:
    def test_clean_config_zero_findings(self):
        config = {
            "project_id": "my-project",
            "firewall_rules": [firewall_rule()],
            "buckets": [bucket()],
            "instances": [instance()],
            "project_iam_bindings": [{"role": "roles/owner", "members": ["user:me@example.com"]}],
        }
        summary, findings, bucket_results, instance_results = auditor.audit(config)
        assert summary["findings"] == 0
        assert summary["critical"] == 0
        assert findings == []

    def test_summary_counts_by_severity(self):
        config = {
            "project_id": "my-project",
            "firewall_rules": [firewall_rule(source_ranges=["0.0.0.0/0"])],
            "buckets": [bucket(iam_bindings=[{"role": "roles/storage.admin", "members": ["allUsers"]}])],
            "instances": [instance(has_external_ip=True)],
            "project_iam_bindings": [],
        }
        summary, findings, _, _ = auditor.audit(config)
        assert summary["critical"] == 2  # GCP-001 firewall + GCP-004 bucket
        assert summary["high"] == 1  # GCP-005 external IP
        assert summary["findings"] == 3
