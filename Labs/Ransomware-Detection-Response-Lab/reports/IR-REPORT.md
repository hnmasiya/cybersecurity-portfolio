# Ransomware Incident Response Report

Severity: Critical. Status: Simulated.

Detection: synthetic endpoint telemetry showed a rapid increase in process creation and file operations across common business document types.

Containment: isolate the affected endpoint, preserve evidence and identify other hosts showing the same telemetry.

Evidence preservation: record timestamps, process lineage, hashes, active connections and relevant logs; preserve originals before analysis.

Recovery: validate backup integrity, eradicate simulated persistence indicators, rebuild or restore systems, rotate credentials where appropriate and monitor.

Lesson: rapid containment is critical, while process, file and identity telemetry correlation improves detection.
