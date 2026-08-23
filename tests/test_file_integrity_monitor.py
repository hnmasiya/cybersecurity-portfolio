from conftest import load_module

fim = load_module("Security-Automation/Scripts/file_integrity_monitor.py")

import hashlib


class TestSha256File:
    def test_matches_known_hash(self, tmp_path):
        f = tmp_path / "a.txt"
        f.write_bytes(b"hello world")
        expected = hashlib.sha256(b"hello world").hexdigest()
        assert fim.sha256_file(f) == expected

    def test_empty_file(self, tmp_path):
        f = tmp_path / "empty.txt"
        f.write_bytes(b"")
        assert fim.sha256_file(f) == hashlib.sha256(b"").hexdigest()

    def test_large_file_spans_multiple_chunks(self, tmp_path):
        # sha256_file reads in 1MB chunks; make sure a >1MB file still hashes correctly.
        data = b"x" * (1024 * 1024 + 500)
        f = tmp_path / "big.bin"
        f.write_bytes(data)
        assert fim.sha256_file(f) == hashlib.sha256(data).hexdigest()


class TestHashes:
    def test_hashes_all_files_with_relative_paths(self, tmp_path):
        (tmp_path / "a.txt").write_text("a")
        sub = tmp_path / "sub"
        sub.mkdir()
        (sub / "b.txt").write_text("b")

        result = fim.hashes(tmp_path)

        assert set(result.keys()) == {"a.txt", "sub/b.txt"}
        assert result["a.txt"] == hashlib.sha256(b"a").hexdigest()

    def test_empty_directory_yields_no_hashes(self, tmp_path):
        assert fim.hashes(tmp_path) == {}

    def test_ignores_subdirectories_themselves(self, tmp_path):
        (tmp_path / "sub").mkdir()
        assert fim.hashes(tmp_path) == {}


class TestMainBaselineAndDiff(object):
    def _run(self, monkeypatch, args):
        monkeypatch.setattr("sys.argv", ["file_integrity_monitor.py"] + args)
        fim.main()

    def test_first_run_creates_baseline(self, tmp_path, monkeypatch, capsys):
        target = tmp_path / "target"
        target.mkdir()
        (target / "f.txt").write_text("v1")
        state = tmp_path / "state.json"

        self._run(monkeypatch, ["--target", str(target), "--state", str(state)])

        out = capsys.readouterr().out
        assert "BASELINE CREATED" in out
        assert state.exists()

    def test_second_run_detects_added_removed_modified(self, tmp_path, monkeypatch, capsys):
        target = tmp_path / "target"
        target.mkdir()
        (target / "unchanged.txt").write_text("same")
        (target / "will_remove.txt").write_text("bye")
        (target / "will_modify.txt").write_text("before")
        state = tmp_path / "state.json"

        self._run(monkeypatch, ["--target", str(target), "--state", str(state)])
        capsys.readouterr()  # discard baseline output

        (target / "will_remove.txt").unlink()
        (target / "will_modify.txt").write_text("after")
        (target / "new_file.txt").write_text("new")

        self._run(monkeypatch, ["--target", str(target), "--state", str(state)])
        out = capsys.readouterr().out

        assert "ADDED    : new_file.txt" in out
        assert "REMOVED  : will_remove.txt" in out
        assert "MODIFIED : will_modify.txt" in out
        assert "unchanged.txt" not in out.replace("Files: 3", "")
        assert "RESULT   : CHANGES DETECTED" in out

    def test_no_changes_reports_no_changes(self, tmp_path, monkeypatch, capsys):
        target = tmp_path / "target"
        target.mkdir()
        (target / "f.txt").write_text("v1")
        state = tmp_path / "state.json"

        self._run(monkeypatch, ["--target", str(target), "--state", str(state)])
        capsys.readouterr()

        self._run(monkeypatch, ["--target", str(target), "--state", str(state)])
        out = capsys.readouterr().out
        assert "RESULT   : NO CHANGES DETECTED" in out

    def test_missing_target_raises_system_exit(self, tmp_path, monkeypatch):
        import pytest
        state = tmp_path / "state.json"
        monkeypatch.setattr(
            "sys.argv",
            ["file_integrity_monitor.py", "--target", str(tmp_path / "nope"), "--state", str(state)],
        )
        with pytest.raises(SystemExit):
            fim.main()
