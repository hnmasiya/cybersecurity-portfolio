from conftest import load_module

extract_iocs = load_module("DFIR/Linux-Forensics/Scripts/extract_iocs.py")


class TestIpPattern:
    def test_matches_valid_ip(self):
        assert extract_iocs.IP_PATTERN.findall("host 192.168.1.10 seen") == ["192.168.1.10"]

    def test_rejects_octet_over_255(self):
        # 999.999.999.999 must not be treated as a valid IPv4 literal.
        assert extract_iocs.IP_PATTERN.findall("bogus 999.999.999.999 here") == []

    def test_accepts_boundary_255(self):
        assert extract_iocs.IP_PATTERN.findall("255.255.255.255") == ["255.255.255.255"]


class TestDomainPattern:
    def test_matches_common_tld(self):
        assert "evil.example.com" in extract_iocs.DOMAIN_PATTERN.findall("beacon to evil.example.com now")

    def test_ignores_unlisted_tld(self):
        # .xyz isn't in the allowed TLD list, so it should not match.
        assert extract_iocs.DOMAIN_PATTERN.findall("visit weird.xyz today") == []


class TestExtractFromFiles:
    def test_extracts_from_existing_file(self, tmp_path):
        f = tmp_path / "log.txt"
        f.write_text("connection from 10.0.0.5 to c2.malicious.net")
        ips, domains = extract_iocs.extract_from_files([str(f)])
        assert ips == {"10.0.0.5"}
        assert domains == {"c2.malicious.net"}

    def test_missing_file_is_skipped_without_raising(self, tmp_path, capsys):
        missing = tmp_path / "does_not_exist.txt"
        ips, domains = extract_iocs.extract_from_files([str(missing)])
        assert ips == set()
        assert domains == set()
        assert "WARNING: File not found" in capsys.readouterr().err

    def test_dedupes_across_files(self, tmp_path):
        f1 = tmp_path / "a.txt"
        f2 = tmp_path / "b.txt"
        f1.write_text("10.0.0.5")
        f2.write_text("10.0.0.5")
        ips, _ = extract_iocs.extract_from_files([str(f1), str(f2)])
        assert ips == {"10.0.0.5"}
