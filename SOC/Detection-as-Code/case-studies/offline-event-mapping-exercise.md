# Offline Event-Mapping Exercise: Windows Process Creation

**Evidence state:** Offline schema-mapping exercise using hand-authored examples. No live Wazuh/Splunk connection or production telemetry is claimed.

## Objective

Map common Windows process-creation JSON fields into the normalized shape consumed by the portfolio reference detection harness. Find schema gaps before connecting a real SIEM.

## Run

From the SOC/Detection-as-Code directory:

    python3 -m unittest discover -s Tests -v
    python3 scripts/run_event_mapping_exercise.py

## Reference mapping

| Normalized field | Common Windows/Sysmon names | Common Wazuh-like JSON path |
|---|---|---|
| Image | Image | data.win.eventdata.image |
| CommandLine | CommandLine | data.win.eventdata.commandLine |
| ParentImage | ParentImage | data.win.eventdata.parentImage |
| User | User or provider-specific username field | data.win.eventdata.user, if emitted |
| ProcessId | ProcessId | data.win.eventdata.processId |
| ParentProcessId | ParentProcessId | data.win.eventdata.parentProcessId |
| UtcTime | UtcTime | envelope timestamp varies |
| Computer | Computer | host/envelope field varies |
| EventID | Windows event system metadata; Sysmon process creation is commonly event 1 | data.win.system.eventID in common envelopes |

Field names vary by provider, Sysmon version, Wazuh decoder and output configuration. Confirm against a real sanitized sample before relying on this mapping. Image and CommandLine are required by the current reference harness; missing values are flagged rather than invented.

## Exercise cases

1. Flat normalized event.
2. Wazuh-like data.win.eventdata envelope.
3. Incomplete event that must be flagged.

## Acceptance criteria

- Tests confirm supported field extraction and explicit incomplete status.
- The mapping report identifies required fields and detection IDs for synthetic examples.
- No conclusion is drawn about every possible Wazuh/Splunk schema.

## Next step with authorized telemetry

Save one sanitized event, compare its exact keys with this table, add a fixture for the actual envelope, and verify event ID, timestamp, host, user, process ID, parent process, image and command line survive parsing. Then run positive and benign controls. This exercise performs no containment or response actions.
