#!/usr/bin/env bash
# Collects a real Linux host configuration snapshot in the JSON schema
# linux_hardening_auditor.py expects. Run with sudo (needs root to read
# sudoers files and scan for world-writable files/SUID binaries reliably).
#
# The expected_suid_allowlist below is not a blind guess: every entry was
# individually verified against its owning package (dpkg -S / dpkg -L)
# before being added - see the lab README for that verification record.
#
# Usage: sudo ./collect_host_snapshot.sh > snapshot.json

set -euo pipefail

HOSTNAME=$(hostname)

# SSH config: sshd -T gives the *effective* config, resolving Include
# files and defaults. If no SSH server is installed/running, this is
# empty - which is itself a legitimate finding (no SSH attack surface).
PERMIT_ROOT_LOGIN=$(sshd -T 2>/dev/null | grep -i "^permitrootlogin" | awk '{print $2}' || true)
PASSWORD_AUTH=$(sshd -T 2>/dev/null | grep -i "^passwordauthentication" | awk '{print $2}' || true)

# Sudoers: look for unrestricted passwordless sudo (NOPASSWD ALL).
NOPASSWD_USERS=$(grep -rhE "NOPASSWD" /etc/sudoers /etc/sudoers.d/ 2>/dev/null || true)

# Firewall state.
FW_ACTIVE="false"
if command -v ufw >/dev/null 2>&1 && ufw status | grep -q "^Status: active"; then
    FW_ACTIVE="true"
fi

# Running services.
SERVICES=$(systemctl list-units --type=service --state=running --no-legend | awk '{print $1}' | sed 's/\.service$//')

# SUID binaries (host filesystem only, -xdev avoids crossing into
# container/network mounts).
SUID_BINARIES=$(find / -xdev -perm -4000 -type f 2>/dev/null || true)

# World-writable files outside /tmp and /var/tmp (system directories only -
# /home is excluded since a user's own writable files there aren't a
# system hardening misconfiguration in the same sense).
WORLD_WRITABLE=$(find /etc /usr /opt /var /root -xdev -type f -perm -0002 2>/dev/null || true)

python3 "$(dirname "$0")/_build_snapshot.py" \
    "$HOSTNAME" "$PERMIT_ROOT_LOGIN" "$PASSWORD_AUTH" "$FW_ACTIVE" \
    "$NOPASSWD_USERS" "$SERVICES" "$SUID_BINARIES" "$WORLD_WRITABLE"
