# Phase 2 — Linux Process Investigation

Investigation evidence generated from a controlled local Linux host.

## Evidence

The directory contains process, filesystem, socket, HTTP, lineage, executable
hash, findings, and SHA-256 manifest artifacts.

Key evidence files:

- `process-summary.txt`
- `process-lineage.txt`
- `listening-sockets.txt`
- `lsof.txt`
- `proc-cmdline.txt`
- `proc-cwd.txt`
- `proc-exe.txt`
- `proc-root.txt`
- `proc-status.txt`
- `findings.txt`
- `SHA256SUMS.txt`

## Integrity

```bash
cd "evidence/phase2-linux-process-investigation-20260924-131215"
sha256sum -c SHA256SUMS.txt
```

This README describes retained artifacts and does not change their findings.
