from conftest import load_module

quality = load_module("Scripts/portfolio_quality_check.py")


class TestScanLinks:
    def test_flags_broken_relative_link(self, tmp_path):
        (tmp_path / "doc.md").write_text("See [details](missing.md) for more.")
        findings = quality.scan(tmp_path)
        assert any("missing.md" in item for item in findings["broken_links"])

    def test_valid_relative_link_not_flagged(self, tmp_path):
        (tmp_path / "target.md").write_text("target")
        (tmp_path / "doc.md").write_text("See [details](target.md) for more.")
        findings = quality.scan(tmp_path)
        assert findings["broken_links"] == []

    def test_external_and_anchor_links_ignored(self, tmp_path):
        (tmp_path / "doc.md").write_text(
            "[ext](https://example.com) [anchor](#section) [mail](mailto:a@b.com)"
        )
        findings = quality.scan(tmp_path)
        assert findings["broken_links"] == []


class TestScanImages:
    def test_flags_broken_image_ref(self, tmp_path):
        (tmp_path / "doc.md").write_text("![alt](missing.png)")
        findings = quality.scan(tmp_path)
        assert any("missing.png" in item for item in findings["broken_images"])

    def test_valid_image_ref_not_flagged(self, tmp_path):
        (tmp_path / "img.png").write_bytes(b"\x89PNG")
        (tmp_path / "doc.md").write_text("![alt](img.png)")
        findings = quality.scan(tmp_path)
        assert findings["broken_images"] == []


class TestScanPlaceholdersAndSecrets:
    def test_flags_placeholder_text(self, tmp_path):
        (tmp_path / "doc.md").write_text("This section is a PLACEHOLDER for now.")
        findings = quality.scan(tmp_path)
        assert findings["placeholders"] == ["doc.md"]

    def test_flags_secret_pattern(self, tmp_path):
        (tmp_path / "doc.md").write_text("INDEXER_PASSWORD=hunter2")
        findings = quality.scan(tmp_path)
        assert findings["secrets"] == ["doc.md"]

    def test_clean_doc_flags_nothing(self, tmp_path):
        (tmp_path / "doc.md").write_text("Everything here is finished and accurate.")
        findings = quality.scan(tmp_path)
        assert findings["placeholders"] == []
        assert findings["secrets"] == []


class TestScanIgnoresAndNonMarkdown:
    def test_ignores_configured_directories(self, tmp_path):
        archive = tmp_path / "Documentation-Archive"
        archive.mkdir()
        (archive / "doc.md").write_text("PLACEHOLDER")
        findings = quality.scan(tmp_path)
        assert findings["placeholders"] == []

    def test_non_markdown_files_are_not_content_scanned(self, tmp_path):
        (tmp_path / "notes.txt").write_text("PLACEHOLDER")
        findings = quality.scan(tmp_path)
        assert findings["placeholders"] == []

    def test_pycache_flagged_as_runtime_artifact(self, tmp_path):
        pycache = tmp_path / "__pycache__"
        pycache.mkdir()
        (pycache / "mod.cpython-311.pyc").write_bytes(b"")
        findings = quality.scan(tmp_path)
        assert len(findings["runtime"]) == 1
