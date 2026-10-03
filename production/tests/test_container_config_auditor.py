from conftest import load_module

auditor = load_module("Docker-Labs/Container-Audit-Lab/Scripts/container_config_auditor.py")


def container(**overrides):
    base = {
        "name": "c1",
        "image": "app:2.0.0",
        "user": "appuser",
        "env": {},
        "privileged": False,
        "network_mode": "bridge",
        "volumes": [],
    }
    base.update(overrides)
    return base


class TestAuditUser:
    def test_root_user_flagged(self):
        findings = auditor.audit_user(container(user="root"))
        assert len(findings) == 1
        assert findings[0]["check"] == "CTR-001"
        assert findings[0]["mitre_attack"]["technique"] == "T1611"

    def test_missing_user_flagged(self):
        c = container()
        del c["user"]
        assert len(auditor.audit_user(c)) == 1

    def test_non_root_user_not_flagged(self):
        assert auditor.audit_user(container(user="appuser")) == []


class TestAuditImageTag:
    def test_latest_tag_flagged(self):
        findings = auditor.audit_image_tag(container(image="app:latest"))
        assert len(findings) == 1
        assert findings[0]["check"] == "CTR-002"

    def test_missing_tag_defaults_to_latest_and_is_flagged(self):
        findings = auditor.audit_image_tag(container(image="app"))
        assert len(findings) == 1

    def test_pinned_tag_not_flagged(self):
        assert auditor.audit_image_tag(container(image="app:2.4.1")) == []


class TestAuditSecrets:
    def test_api_key_with_real_value_flagged(self):
        findings = auditor.audit_secrets(container(env={"API_KEY": "sk-live-abcdef123456"}))
        assert len(findings) == 1
        assert findings[0]["check"] == "CTR-003"
        assert findings[0]["mitre_attack"]["technique"] == "T1552.001"

    def test_password_key_flagged(self):
        findings = auditor.audit_secrets(container(env={"DB_PASSWORD": "hunter2"}))
        assert len(findings) == 1

    def test_placeholder_value_not_flagged(self):
        assert auditor.audit_secrets(container(env={"API_KEY": "changeme"})) == []

    def test_empty_value_not_flagged(self):
        assert auditor.audit_secrets(container(env={"API_KEY": ""})) == []

    def test_non_secret_env_var_not_flagged(self):
        assert auditor.audit_secrets(container(env={"APP_ENV": "production"})) == []


class TestAuditPrivileged:
    def test_privileged_true_flagged_critical(self):
        findings = auditor.audit_privileged(container(privileged=True))
        assert len(findings) == 1
        assert findings[0]["severity"] == "CRITICAL"

    def test_privileged_false_not_flagged(self):
        assert auditor.audit_privileged(container(privileged=False)) == []


class TestAuditDockerSocket:
    def test_docker_sock_mount_flagged_critical(self):
        findings = auditor.audit_docker_socket(
            container(volumes=["/var/run/docker.sock:/var/run/docker.sock"])
        )
        assert len(findings) == 1
        assert findings[0]["severity"] == "CRITICAL"

    def test_unrelated_volume_not_flagged(self):
        assert auditor.audit_docker_socket(container(volumes=["/data:/data"])) == []


class TestAuditNetworkMode:
    def test_host_network_flagged(self):
        findings = auditor.audit_network_mode(container(network_mode="host"))
        assert len(findings) == 1
        assert findings[0]["check"] == "CTR-006"

    def test_bridge_network_not_flagged(self):
        assert auditor.audit_network_mode(container(network_mode="bridge")) == []


class TestAuditIntegration:
    def test_fully_hardened_container_yields_no_findings(self):
        c = container(image="app:2.4.1", user="appuser", env={"API_KEY": "changeme"},
                       privileged=False, network_mode="bridge", volumes=["/data:/data:ro"])
        assert auditor.audit_container(c) == []

    def test_maximally_misconfigured_container_flags_everything(self):
        c = container(
            image="app:latest",
            user="root",
            env={"API_KEY": "sk-live-abcdef123456"},
            privileged=True,
            network_mode="host",
            volumes=["/var/run/docker.sock:/var/run/docker.sock"],
        )
        findings = auditor.audit_container(c)
        checks = {f["check"] for f in findings}
        assert checks == {"CTR-001", "CTR-002", "CTR-003", "CTR-004", "CTR-005", "CTR-006"}

    def test_summary_counts_across_multiple_containers(self):
        containers = [
            container(name="bad", user="root", privileged=True),
            container(name="good"),
        ]
        summary, results = auditor.audit(containers)
        assert summary["containers_analyzed"] == 2
        assert summary["findings"] == 2
        assert summary["critical"] == 1
        assert summary["high"] == 1
        assert results[0]["name"] == "bad"
        assert len(results[0]["findings"]) == 2
        assert results[1]["findings"] == []
