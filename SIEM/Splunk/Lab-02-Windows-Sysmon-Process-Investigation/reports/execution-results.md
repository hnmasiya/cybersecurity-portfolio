# Lab 02 Execution Results

Generated from the live local Splunk instance.

- Total Sysmon process-creation events: **32**
- PowerShell process events: **3**
- Suspicious process/command-line events: **2**

These values were retrieved from Splunk after ingestion and are not hard-coded lab claims.

## Parent/Child Evidence

See `process-investigation.spl` and the Splunk search results for the observed parent-child relationships.

## Important limitation

The telemetry is synthetic. It demonstrates investigation technique and detection logic; it does not establish a real-world compromise.
