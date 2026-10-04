import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def test_phishing_synthetic_evidence():
    text = (ROOT / "SOC/Phishing-Investigation/evidence/synthetic-phishing.eml").read_text()
    assert "X-Synthetic-Training: true" in text
    assert "spf=fail" in text
    assert "dkim=none" in text
    assert "dmarc=fail" in text
    assert "Reply-To: verify@payroll-example.invalid" in text


def test_ioc_synthetic_case_is_documentation_safe():
    data = json.loads((ROOT / "Threat-Intelligence/IOC-Investigation/evidence/synthetic-ioc-case.json").read_text())
    assert data["evidence_state"] == "CONTROLLED / SYNTHETIC"
    assert len(data["indicators"]) == 3
    assert any(i["value"] == "198.51.100.23" for i in data["indicators"])
    assert any(i["value"].endswith(".invalid") for i in data["indicators"])


def test_cloud_detection_dataset_has_two_iam_changes():
    events = json.loads((ROOT / "Cloud-Security/Cloud-Detection/evidence/synthetic-gcp-audit-log.json").read_text())
    matches = [e for e in events if e["protoPayload"]["methodName"].endswith("SetIAMPolicy")]
    assert len(matches) == 2
    assert len(events) == 3


def test_soc_automation_retained_output():
    output = json.loads((ROOT / "Automation/SOC-Automation/evidence/execution-output.json").read_text())
    assert output["evidence_state"] == "CONTROLLED / SYNTHETIC"
    assert output["summary"] == {"total": 3, "escalate": 1, "investigate": 1, "monitor": 1}
    assert output["alerts"][0]["disposition"] == "ESCALATE"
    assert output["alerts"][1]["disposition"] == "INVESTIGATE"
    assert output["alerts"][2]["disposition"] == "MONITOR"
