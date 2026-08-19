# Wazuh Live Server Integration Report

## Environment
- Wazuh Manager 4.14.7
- Wazuh Indexer 4.14.7
- Wazuh Dashboard 4.14.7
- Docker single-node deployment

## Verified
- Manager operational
- Indexer GREEN
- Dashboard operational
- Wazuh API authentication successful
- Windows/Sysmon centralized group configured

## Windows/Sysmon Collection
The persistent `windows-sysmon` group collects Windows Security, Sysmon, PowerShell and Windows Defender event channels.

## Limitation
No live Windows endpoint is currently attached. Therefore live Windows/Sysmon telemetry and live Windows Wazuh screenshots are not claimed.

## Conclusion
The Wazuh server-side deployment is operational and portfolio-ready. Live endpoint validation remains the external dependency.
