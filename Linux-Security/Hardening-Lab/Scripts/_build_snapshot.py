#!/usr/bin/env python3
"""Builds the host snapshot JSON from arguments collected by
collect_host_snapshot.sh. Not meant to be run standalone - see that
script for the actual data collection commands.
"""
import json
import sys

# Known-good SUID allowlist for this specific host, verified via
# dpkg -S/-L against the official Ubuntu/Zorin package archive before
# being added (see the lab README for the verification record, including
# the fusermount3/usrmerge path-aliasing quirk that was investigated
# rather than assumed benign).
EXPECTED_SUID_ALLOWLIST = [
    "/usr/sbin/pppd", "/usr/libexec/xscreensaver/xscreensaver-auth",
    "/usr/libexec/spice-client-glib-usb-acl-helper", "/usr/bin/newgrp",
    "/usr/bin/passwd", "/usr/bin/chfn", "/usr/bin/umount",
    "/usr/bin/gpasswd", "/usr/bin/fusermount3", "/usr/bin/sudo",
    "/usr/bin/su", "/usr/bin/mount", "/usr/bin/pkexec", "/usr/bin/chsh",
    "/usr/lib/openssh/ssh-keysign", "/usr/lib/polkit-1/polkit-agent-helper-1",
    "/usr/lib/virtualbox/VirtualBoxVM", "/usr/lib/virtualbox/VBoxHeadless",
    "/usr/lib/virtualbox/VBoxNetNAT", "/usr/lib/virtualbox/VBoxNetDHCP",
    "/usr/lib/virtualbox/VBoxSDL", "/usr/lib/virtualbox/VBoxNetAdpCtl",
    "/usr/lib/xorg/Xorg.wrap", "/usr/lib/dbus-1.0/dbus-daemon-launch-helper",
    "/opt/brave.com/brave/chrome-sandbox",
]


def main():
    hostname, permit_root_login, password_auth, fw_active, nopasswd_raw, services_raw, suid_raw, world_writable_raw = sys.argv[1:9]

    sudoers_entries = []
    for line in nopasswd_raw.splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        parts = line.split()
        user = parts[0] if parts else "unknown"
        commands = "ALL" if "ALL" in line else line
        sudoers_entries.append({"user": user, "commands": commands, "nopasswd": True})

    snapshot = {
        "hostname": hostname,
        "ssh_config": (
            {"PermitRootLogin": permit_root_login, "PasswordAuthentication": password_auth, "Protocol": "2"}
            if permit_root_login or password_auth else {}
        ),
        "sudoers_entries": sudoers_entries,
        "world_writable_files": [p for p in world_writable_raw.splitlines() if p.strip()],
        "suid_binaries": [p for p in suid_raw.splitlines() if p.strip()],
        "expected_suid_allowlist": EXPECTED_SUID_ALLOWLIST,
        "running_services": [s for s in services_raw.splitlines() if s.strip()],
        "firewall_active": fw_active == "true",
    }

    print(json.dumps(snapshot, indent=2))


if __name__ == "__main__":
    main()
