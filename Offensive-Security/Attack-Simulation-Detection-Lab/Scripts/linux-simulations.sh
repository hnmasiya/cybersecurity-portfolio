#!/usr/bin/env bash
# Attack Simulation & Detection Engineering Lab - Linux-side simulations.
# Run ONE technique at a time (pass its name as $1), not all at once, so
# each Wazuh alert is unambiguous about which simulation triggered it.
# See ../README.md for prerequisites (auditd rules, syscheck paths) and
# the matching Windows-side commands.

set -euo pipefail

usage() {
  echo "Usage: $0 {execution|persistence|persistence-cleanup|credential-access}"
  exit 1
}

[ $# -eq 1 ] || usage

case "$1" in
  execution)
    # T1059: base64-obfuscated command piped into a shell. Wrapped in
    # `bash -c "..."` deliberately: running the pipeline directly forks
    # echo/base64/bash as three separate processes, none of which has
    # "base64 -d | bash" as a literal argument (that text is shell
    # syntax, consumed before any exec happens) - so it never produces
    # a matchable audit record. Wrapping it as one bash -c argument is
    # both how the detection rule was actually validated and how real
    # obfuscated droppers commonly invoke a decoded payload in practice.
    bash -c "echo 'aWQ7d2hvYW1p' | base64 -d | bash"
    ;;
  persistence)
    # T1053.003: cron job added, beacon target is localhost only
    (crontab -l 2>/dev/null; echo "* * * * * curl -s http://127.0.0.1:9999/beacon") | crontab -
    echo "Cron entry added. Capture the Wazuh FIM alert, then run:"
    echo "  $0 persistence-cleanup"
    ;;
  persistence-cleanup)
    crontab -l | grep -v '127.0.0.1:9999' | crontab -
    echo "Cron entry removed."
    ;;
  credential-access)
    # T1003.008: expected to fail with "Permission denied" as a non-root
    # user - that failure IS the signal, not an error to fix.
    cat /etc/shadow
    ;;
  *)
    usage
    ;;
esac
