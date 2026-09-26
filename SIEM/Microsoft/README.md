# Microsoft Defender XDR + Microsoft Sentinel

This is the next planned enterprise SIEM/security operations track following the completed Wazuh and Splunk work.

## Progression
Wazuh → Splunk → Microsoft Sentinel + Microsoft Defender XDR

## Labs
1. Sentinel Foundations
2. KQL Threat Hunting
3. Detection Engineering
4. Incident Investigation
5. Defender XDR Advanced Hunting
6. Response Automation
7. End-to-End SOC Case

All labs start as PREPARATION. They are promoted to EXECUTED only after genuine Microsoft cloud activity and evidence are captured.

## Master controller
Run:

    scripts/microsoft-defender-sentinel-MASTER-BUILD-VALIDATE.sh

For an Azure authentication status check:

    RUN_CLOUD_CHECKS=1 scripts/microsoft-defender-sentinel-MASTER-BUILD-VALIDATE.sh

The script never stores credentials.
