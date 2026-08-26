# Linux Host Hardening Audit Lab

This project demonstrates an offline Linux host hardening audit using a
synthetic configuration snapshot, evaluated against CIS-benchmark-style
rules.

## Checks

- SSH root login permitted / password authentication enabled / legacy
  protocol version
- Unrestricted passwordless sudo (`NOPASSWD` on `ALL` commands)
- World-writable files outside `/tmp`
- SUID binaries not on the expected allowlist
- Legacy/insecure services running (telnet, rsh, rlogin, tftp, ...)
- Host firewall inactive

## Validation

Run:

`python3 Scripts/linux_hardening_auditor.py --input Data/synthetic-host-snapshot.json --output Evidence/hardening-audit.json`

Results are written to `Evidence/hardening-audit.json`.

## Current status

**Complete — validated against both synthetic and a real, live host.**

The synthetic snapshot includes both misconfigurations and
correctly-hardened settings (a scoped `NOPASSWD` sudo entry, allowlisted
SUID binaries, files under `/tmp`) to demonstrate the audit logic doesn't
flag ordinary, compliant configuration.

## Real host validation

[`Scripts/collect_host_snapshot.sh`](./Scripts/collect_host_snapshot.sh)
collects a real snapshot (SSH config via `sshd -T`, sudoers, SUID binaries,
running services, firewall state) from a live Linux host in the same JSON
schema, and was run against a real personal machine:

```
sudo ./Scripts/collect_host_snapshot.sh > Data/real-host-snapshot.json
python3 Scripts/linux_hardening_auditor.py --input Data/real-host-snapshot.json --output Evidence/real-hardening-audit.json
```

Result: **0 findings** across all 5 checks — but that's an earned result,
not an assumed one:

- No SSH server is installed on this host, so the SSH checks have nothing
  to flag (genuinely zero SSH attack surface, not a missing check).
- No `NOPASSWD` sudoers entries.
- `ufw` is active with default-deny incoming.
- No legacy/insecure services running.
- All 26 real SUID binaries were individually verified against their
  owning package (`dpkg -S`/`dpkg -L`) before being allowlisted — this
  caught two real issues along the way rather than assuming a clean
  result:
  - An unprivileged first scan looked artificially clean because it
    silently couldn't read into root-owned paths without `sudo` — a
    properly-privileged scan is what actually surfaced everything below.
  - The privileged scan then initially flooded the SUID/world-writable
    results with hundreds of false positives: `containerd` stores every
    Docker image layer as a plain directory tree under
    `/var/lib/containerd`, on the *same filesystem* as the host, so a
    naive `find -xdev` walks straight into every container image's own
    copy of `passwd`, `sudo`, `mount`, etc. The collector explicitly
    excludes `/var/lib/docker` and `/var/lib/containerd` to scope the
    audit to the actual host, not container-internal storage.
  - One binary, `/usr/lib/mysql/plugin/auth_pam_tool_dir/auth_pam_tool`,
    only appeared once the scan ran as root (its permissions are
    restrictive enough that even `find` can't see it unprivileged) and
    was verified as belonging to the `mariadb-server` package before
    being allowlisted.

Real evidence: [`Data/real-host-snapshot.json`](./Data/real-host-snapshot.json)
(the real collected snapshot) and
[`Evidence/real-hardening-audit.json`](./Evidence/real-hardening-audit.json)
(the audit result).
