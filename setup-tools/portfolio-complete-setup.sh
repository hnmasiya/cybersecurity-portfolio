#!/bin/bash
# Comprehensive Cybersecurity Portfolio Setup & Verification
# This script sets up the complete portfolio structure with all improvements

set -e

PORTFOLIO_ROOT="${1:-.}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="$PORTFOLIO_ROOT/setup_${TIMESTAMP}.log"

echo "=========================================="
echo "Portfolio Complete Setup & Verification"
echo "=========================================="
echo "Root: $PORTFOLIO_ROOT"
echo "Log: $LOG_FILE"
echo ""

# Initialize log
{
    echo "Setup started: $(date)"
    echo "Portfolio root: $PORTFOLIO_ROOT"
    echo ""
} > "$LOG_FILE"

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to log and print
log_step() {
    echo -e "${BLUE}[$(date +'%H:%M:%S')]${NC} $1"
    echo "[$(date +'%H:%M:%S')] $1" >> "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
    echo "✓ $1" >> "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
    echo "⚠ $1" >> "$LOG_FILE"
}

# ============================================
# PHASE 1: Create SOC Structure
# ============================================
log_step "PHASE 1: Creating Security Operations Structure"

mkdir -p "$PORTFOLIO_ROOT/SOC/Microsoft-Sentinel-KQL/KQL"
mkdir -p "$PORTFOLIO_ROOT/SOC/Microsoft-Sentinel-KQL/Detection-Rules"
mkdir -p "$PORTFOLIO_ROOT/SOC/Endpoint-Detection"
mkdir -p "$PORTFOLIO_ROOT/SOC/MITRE-ATT&CK"
mkdir -p "$PORTFOLIO_ROOT/Cloud-Security/Unified-Cloud-Detection"
mkdir -p "$PORTFOLIO_ROOT/Automation/SOC-Automation"

log_success "Created directory structure"

# ============================================
# PHASE 2: Create Sentinel/KQL README
# ============================================
log_step "PHASE 2: Creating Microsoft Sentinel & KQL Documentation"

cat > "$PORTFOLIO_ROOT/SOC/Microsoft-Sentinel-KQL/README.md" << 'EOF'
# Microsoft Sentinel & KQL Security Operations

## Purpose

This project extends the portfolio's existing Wazuh and detection-engineering experience into the Microsoft Sentinel and Kusto Query Language (KQL) security-operations model.

The objective is to demonstrate transferable SIEM skills:
**Telemetry → Query → Detection → Triage → Investigation → ATT&CK mapping → Response**

## Validation status

The KQL content in this repository is documented detection and investigation logic.

Unless an execution artifact is explicitly retained, queries are classified as:
**ARCHITECTURE / METHODOLOGY**

They must not be presented as queries executed against a live Microsoft Sentinel workspace.

## Why Sentinel/KQL

Modern SOC environments commonly use Microsoft Sentinel, Microsoft Defender and related Microsoft security telemetry. KQL provides a practical language for querying authentication, process, endpoint and network telemetry.

This portfolio demonstrates both:
- SIEM experience using Wazuh
- Transferable KQL/Sentinel investigation methodology

## Investigation workflow

```
Security telemetry
       ↓
KQL investigation
       ↓
Suspicious activity identified
       ↓
Alert / incident triage
       ↓
Host + user + process analysis
       ↓
MITRE ATT&CK mapping
       ↓
Scope assessment
       ↓
Response recommendation
       ↓
Detection tuning
```

## Included investigations

| Investigation | Purpose |
|---|---|
| Authentication | Identify suspicious authentication activity |
| PowerShell | Investigate suspicious PowerShell execution |
| Process activity | Identify unusual process relationships |
| Network | Investigate suspicious outbound connections |

## Relationship to existing portfolio

The Sentinel work complements:
- `SOC/Detection-as-Code/`
- `SOC/Detection-Validation/`
- `SOC/Flagship-Investigation/`
- `Cloud-Security/Azure-Windows-Server-Lab/`
- `Endpoint-Security/Windows-Sysmon-Detection-Lab/`
- `Automation/SOC-Automation/`

The underlying analyst methodology remains the same regardless of SIEM.

## Evidence integrity

No live Sentinel execution, alert count, detection rate or incident outcome is claimed unless corresponding evidence is retained in the repository.
EOF

log_success "Created Sentinel/KQL README"

# ============================================
# PHASE 3: Create KQL Investigation Queries
# ============================================
log_step "PHASE 3: Creating KQL Investigation Queries"

cat > "$PORTFOLIO_ROOT/SOC/Microsoft-Sentinel-KQL/KQL/Authentication-Investigation.kql" << 'EOF'
// Microsoft Sentinel / KQL
// Purpose: investigate unusual authentication activity.
//
// Status: ARCHITECTURE / METHODOLOGY
// This query has not been represented as executed against a live Sentinel
// workspace unless a corresponding execution artifact is retained.

// Recent successful and failed authentication activity
SigninLogs
| where TimeGenerated >= ago(24h)
| project
    TimeGenerated,
    UserPrincipalName,
    IPAddress,
    Location,
    AppDisplayName,
    ResultType,
    ResultDescription,
    AuthenticationRequirement
| order by TimeGenerated desc

// Identify users with repeated failed authentication attempts
SigninLogs
| where TimeGenerated >= ago(24h)
| where ResultType != "0"
| summarize
    FailedAttempts = count(),
    SourceIPs = make_set(IPAddress, 20),
    Applications = make_set(AppDisplayName, 20)
    by UserPrincipalName
| where FailedAttempts >= 5
| order by FailedAttempts desc
EOF

cat > "$PORTFOLIO_ROOT/SOC/Microsoft-Sentinel-KQL/KQL/Suspicious-PowerShell.kql" << 'EOF'
// Microsoft Sentinel / KQL
// Purpose: identify potentially suspicious PowerShell execution.
//
// Status: ARCHITECTURE / METHODOLOGY
// Execution against a live workspace must be evidenced separately.

// Microsoft Defender for Endpoint process telemetry
DeviceProcessEvents
| where Timestamp >= ago(24h)
| where FileName =~ "powershell.exe"
    or FileName =~ "pwsh.exe"
| project
    Timestamp,
    DeviceName,
    AccountName,
    FileName,
    ProcessCommandLine,
    InitiatingProcessFileName,
    InitiatingProcessCommandLine
| order by Timestamp desc

// Investigate common high-risk PowerShell indicators
DeviceProcessEvents
| where Timestamp >= ago(24h)
| where FileName =~ "powershell.exe"
| where ProcessCommandLine has_any (
    "-EncodedCommand",
    "FromBase64String",
    "DownloadString",
    "Invoke-WebRequest",
    "IEX",
    "Invoke-Expression"
)
| project
    Timestamp,
    DeviceName,
    AccountName,
    ProcessCommandLine,
    InitiatingProcessFileName
EOF

cat > "$PORTFOLIO_ROOT/SOC/Microsoft-Sentinel-KQL/KQL/Suspicious-Process-Activity.kql" << 'EOF'
// Microsoft Sentinel / KQL
// Purpose: investigate unusual parent/child process relationships.
//
// Status: ARCHITECTURE / METHODOLOGY

// Parent/child process relationships
DeviceProcessEvents
| where Timestamp >= ago(24h)
| project
    Timestamp,
    DeviceName,
    AccountName,
    FileName,
    ProcessCommandLine,
    InitiatingProcessFileName,
    InitiatingProcessCommandLine
| order by Timestamp desc

// Identify scripting interpreters launched by unexpected parents
DeviceProcessEvents
| where Timestamp >= ago(24h)
| where FileName in~ (
    "powershell.exe",
    "pwsh.exe",
    "cmd.exe",
    "wscript.exe",
    "cscript.exe",
    "mshta.exe"
)
| where InitiatingProcessFileName !in~ (
    "explorer.exe",
    "services.exe",
    "svchost.exe"
)
| project
    Timestamp,
    DeviceName,
    AccountName,
    FileName,
    ProcessCommandLine,
    InitiatingProcessFileName
| order by Timestamp desc
EOF

cat > "$PORTFOLIO_ROOT/SOC/Microsoft-Sentinel-KQL/KQL/Network-Investigation.kql" << 'EOF'
// Microsoft Sentinel / KQL
// Purpose: investigate endpoint network connections.
//
// Status: ARCHITECTURE / METHODOLOGY

// Recent network connections
DeviceNetworkEvents
| where Timestamp >= ago(24h)
| project
    Timestamp,
    DeviceName,
    InitiatingProcessAccountName,
    InitiatingProcessFileName,
    InitiatingProcessCommandLine,
    RemoteIP,
    RemotePort,
    RemoteUrl,
    Protocol
| order by Timestamp desc

// Investigate unusual outbound connections by process
DeviceNetworkEvents
| where Timestamp >= ago(24h)
| summarize
    ConnectionCount = count(),
    RemoteIPs = make_set(RemoteIP, 50),
    RemotePorts = make_set(RemotePort, 50)
    by DeviceName, InitiatingProcessFileName
| order by ConnectionCount desc
EOF

log_success "Created KQL investigation queries"

# ============================================
# PHASE 4: Create Detection Rules Documentation
# ============================================
log_step "PHASE 4: Creating Detection Rules Documentation"

cat > "$PORTFOLIO_ROOT/SOC/Microsoft-Sentinel-KQL/Detection-Rules/README.md" << 'EOF'
# Sentinel Detection Engineering

## Detection lifecycle

The Sentinel detection model follows the same engineering discipline used by the portfolio's Wazuh/Sigma detections:

**Detection concept → telemetry → query → analytic rule → test → expected result → actual result → tuning**

## Candidate detections

### Authentication anomaly
**Telemetry:** `SigninLogs`

Potential signals:
- repeated authentication failures
- unusual source IP
- unusual location
- unexpected application
- suspicious authentication requirement

### Suspicious PowerShell
**Telemetry:** `DeviceProcessEvents`

Potential signals:
- encoded commands
- download activity
- suspicious execution chains
- unusual parent process
- script interpreter abuse

### Suspicious process relationship
**Telemetry:** `DeviceProcessEvents`

Potential signals:
- unexpected parent/child relationships
- scripting interpreters launched by unusual applications
- administrative tools executing from unusual contexts

### Suspicious network activity
**Telemetry:** `DeviceNetworkEvents`

Potential signals:
- unusual destination
- unexpected process/network relationship
- abnormal outbound connection pattern
- suspicious remote port

## False-positive handling

A production detection should not be considered complete simply because it returns results.

Analysts should establish:
1. What legitimate behavior produces the signal?
2. What makes the suspicious case different?
3. Which fields provide useful context?
4. What exclusions are justified?
5. Can exclusions be scoped to known hosts/users/processes?
6. How will the rule be regression-tested?

## Validation status

Unless execution evidence is retained, these detections remain:
**PENDING LIVE VALIDATION**
EOF

log_success "Created Detection Rules documentation"

# ============================================
# PHASE 5: Create ATT&CK Mapping
# ============================================
log_step "PHASE 5: Creating MITRE ATT&CK Coverage"

cat > "$PORTFOLIO_ROOT/SOC/Microsoft-Sentinel-KQL/ATT&CK-Mapping.md" << 'EOF'
# Sentinel Investigation — MITRE ATT&CK Mapping

| Investigation | Behavior | ATT&CK | Evidence status |
|---|---|---|---|
| Authentication | Valid account use | T1078 | METHODOLOGY unless evidenced |
| PowerShell | PowerShell execution | T1059.001 | METHODOLOGY unless evidenced |
| Process | Command/scripting execution | T1059 | METHODOLOGY unless evidenced |
| Network | Application/network communication | T1071 | METHODOLOGY unless evidenced |

## Evidence rule

ATT&CK mappings are only promoted to OBSERVED when repository evidence demonstrates the corresponding behavior.

A query containing a technique does not itself prove that the technique was executed.

This distinction is maintained throughout the portfolio.
EOF

log_success "Created ATT&CK Mapping"

# ============================================
# PHASE 6: Create Endpoint Detection
# ============================================
log_step "PHASE 6: Creating Endpoint Detection Documentation"

cat > "$PORTFOLIO_ROOT/SOC/Endpoint-Detection/README.md" << 'EOF'
# Endpoint Detection & Response

## Purpose

This area consolidates the portfolio's Windows endpoint security evidence around an EDR/SOC investigation model.

The primary evidence source is the deployed Azure Windows Server 2022 lab, which has retained:
- Windows Security telemetry
- Sysmon telemetry
- Wazuh agent connectivity
- Wazuh-generated alerts
- PowerShell automation
- Active Directory telemetry
- endpoint detection analysis

## Endpoint detection workflow

```
Windows endpoint
      |
      ├──→ Security Events
      ├──→ Sysmon
      ├──→ Windows Defender
      |
      v
Wazuh collection
      |
      v
Detection
      |
      v
Triage
      |
      v
Process + user + host + network investigation
      |
      v
MITRE ATT&CK
      |
      v
Response
```

## Existing real evidence

See: `Cloud-Security/Azure-Windows-Server-Lab/Evidence/`

Important retained artifacts include:
- `raw-security-events.json`
- `raw-sysmon-events.json`
- `real-ad-analysis.json`
- `real-sysmon-analysis.json`
- `wazuh-agent-connection.txt`
- `wazuh-dashboard-agent-active.jpg`

## What the evidence demonstrates

The Azure lab provides real endpoint telemetry and demonstrates the ability to interpret detections in context rather than treating every alert as malicious.

The retained Sysmon analysis identified explainable activity including:
- PowerShell process/network activity
- controlled `notepad.exe` child process
- failed authentication event

These findings were tied back to the administrator's actual lab activity.

## EDR positioning

This portfolio demonstrates endpoint detection concepts and real Windows/Sysmon telemetry.

It does **not** claim production experience operating a commercial EDR platform such as CrowdStrike, SentinelOne or Microsoft Defender for Endpoint unless that platform has actually been used and evidenced.

## Analyst workflow

**Alert → host identification → user → process → parent process → command line → network → timeline → ATT&CK → scope → response → tuning**
EOF

log_success "Created Endpoint Detection README"

# ============================================
# PHASE 7: Create Endpoint Investigation Docs
# ============================================
log_step "PHASE 7: Creating Endpoint Investigation Guides"

cat > "$PORTFOLIO_ROOT/SOC/Endpoint-Detection/Windows-Sysmon-Investigation.md" << 'EOF'
# Windows / Sysmon Investigation

## Evidence source

The primary evidence is retained in:
`Cloud-Security/Azure-Windows-Server-Lab/Evidence/`

The lab contains real Sysmon and Windows telemetry collected from the deployed Windows Server 2022 environment.

## Relevant telemetry

| Event | Purpose |
|---|---|
| Sysmon Event ID 1 | Process creation |
| Sysmon Event ID 3 | Network connection |
| Security Event ID 4625 | Failed logon |

## Investigation process

1. Identify the host
2. Identify the user
3. Identify the process
4. Examine the parent process
5. Review command-line arguments
6. Review network activity
7. Establish the timeline
8. Determine whether behavior is malicious, benign or inconclusive
9. Map demonstrated behavior to ATT&CK
10. Determine response and tuning requirements

## Real lab findings

The retained endpoint analysis produced five findings from the captured telemetry.

The documented interpretation is important: the findings were explainable by actions performed during the lab deployment and testing.

This demonstrates an important SOC skill:
**Detection ≠ confirmed compromise**

Analysts must distinguish suspicious telemetry from malicious activity by examining context and corroborating evidence.
EOF

cat > "$PORTFOLIO_ROOT/SOC/Endpoint-Detection/PowerShell-Investigation.md" << 'EOF'
# PowerShell Investigation

## Investigation objective

Investigate PowerShell execution using:
- process creation telemetry
- command-line arguments
- parent process
- user context
- network activity
- timeline correlation

## High-value indicators

Examples include:
- encoded commands
- download activity
- execution from unusual parent processes
- suspicious child processes
- remote administration behavior
- script interpreters chained with unexpected applications

## ATT&CK

PowerShell activity may map to:
**T1059.001 — PowerShell**

The technique should only be marked OBSERVED when the retained telemetry demonstrates the behavior.

## Analyst decision

PowerShell is a legitimate administrative tool.

Therefore:
**PowerShell execution alone is not sufficient evidence of compromise**

The investigation must establish whether the command, parent process, account, destination and surrounding timeline indicate malicious behavior.

## Evidence

See the Azure Windows/Sysmon evidence and the existing endpoint detection lab.

Live production compromise is not claimed.
EOF

log_success "Created Endpoint Investigation guides"

# ============================================
# PHASE 8: Create MITRE ATT&CK Coverage
# ============================================
log_step "PHASE 8: Creating MITRE ATT&CK Coverage Matrix"

cat > "$PORTFOLIO_ROOT/SOC/MITRE-ATT&CK/README.md" << 'EOF'
# MITRE ATT&CK Coverage

MITRE ATT&CK is used throughout the portfolio as an investigation and detection-mapping framework.

## Principle

The portfolio distinguishes between:
- **OBSERVED** — demonstrated by retained telemetry/evidence
- **SIMULATED** — deliberately generated training behavior
- **METHODOLOGY** — documented detection/investigation logic
- **PENDING LIVE VALIDATION** — not yet executed

A technique is never marked observed merely because a detection rule references it.

## Coverage areas

- Authentication
- PowerShell
- Process execution
- Network activity
- Account and privilege changes
- Cloud identity activity
- Suspicious administrative activity

See `COVERAGE-MATRIX.md`.
EOF

cat > "$PORTFOLIO_ROOT/SOC/MITRE-ATT&CK/COVERAGE-MATRIX.md" << 'EOF'
# MITRE ATT&CK Coverage Matrix

| Technique | Area | Evidence source | Status |
|---|---|---|---|
| T1059.001 PowerShell | Endpoint | Azure/Sysmon evidence | OBSERVED where telemetry supports it |
| T1078 Valid Accounts | Windows/Wazuh | Wazuh evidence | OBSERVED where retained alert supports it |
| Account manipulation | AD | Azure/AD evidence | Context-dependent |
| Network communication | Endpoint | Sysmon Event ID 3 | OBSERVED where retained telemetry supports it |
| Cloud account/IAM activity | Cloud | GCP/Azure audit evidence | Evidence-dependent |
| Credential access | Endpoint | Investigation methodology | PENDING unless evidenced |
| Lateral movement | Endpoint | Investigation methodology | PENDING unless evidenced |
| Command and control | Endpoint | Investigation methodology | PENDING unless evidenced |

## Coverage rule

The matrix is intentionally conservative.

Absence of evidence is not converted into an attacker narrative.
EOF

log_success "Created MITRE ATT&CK Coverage"

# ============================================
# PHASE 9: Create Cloud Detection
# ============================================
log_step "PHASE 9: Creating Cloud Detection Structure"

cat > "$PORTFOLIO_ROOT/Cloud-Security/Unified-Cloud-Detection/README.md" << 'EOF'
# Unified Cloud Detection & Response

## Purpose

This project unifies the portfolio's existing Azure and GCP security work into a SOC-oriented detection lifecycle.

## Workflow

```
Cloud activity
      |
      v
Audit / security telemetry
      |
      v
Detection
      |
      v
Alert
      |
      v
Triage
      |
      v
Investigation
      |
      v
MITRE ATT&CK
      |
      v
Remediation
      |
      v
Verification
```

## Azure

Existing evidence includes:
- Windows Server 2022
- Active Directory
- Sysmon
- Wazuh
- security event telemetry
- endpoint detection
- Terraform
- hardening
- network security controls

See: `../Azure-Windows-Server-Lab/`

## GCP

Existing security work includes:
- project security
- IAM
- CSPM auditing
- Terraform
- security configuration collection
- cloud detection logic

See: `../GCP-Project-Security-Lab/` and `../GCP-Landing-Zone-Lab/`

## Detection scenarios

### IAM modification
Investigate:
- privileged role changes
- new administrative identities
- policy modifications
- service-account changes

### Public exposure
Investigate:
- publicly accessible resources
- permissive firewall rules
- storage exposure
- unnecessary network paths

### Security-control changes
Investigate:
- logging changes
- monitoring changes
- security policy changes
- IAM policy modifications

### Suspicious administration
Investigate:
- unusual administrative identities
- unusual source locations
- unexpected privileged operations
- service-account activity

## Evidence status

Only existing retained artifacts are described as observed.

New scenarios remain:
**PENDING LIVE VALIDATION**

unless execution evidence is added.
EOF

log_success "Created Cloud Detection README"

# ============================================
# PHASE 10: Create Cloud-specific Docs
# ============================================
log_step "PHASE 10: Creating Cloud-specific Documentation"

cat > "$PORTFOLIO_ROOT/Cloud-Security/Unified-Cloud-Detection/Azure-Detection.md" << 'EOF'
# Azure Detection

## Existing evidence

The Azure Windows Server lab provides a real deployed Windows Server 2022 environment with:
- Active Directory
- Sysmon
- Wazuh
- Windows Security events
- endpoint detection analysis
- hardening evidence
- Azure infrastructure evidence

## SOC workflow

**Azure infrastructure → Windows telemetry → Sysmon → Wazuh → detection → investigation → ATT&CK → response**

## Security controls

The existing Terraform implementation demonstrates:
- restricted RDP source
- default-deny inbound network policy
- no committed secrets
- controlled administrative access
- auto-shutdown
- small lab-oriented VM sizing

## Evidence

See: `../Azure-Windows-Server-Lab/Evidence/`

## Status

Deployment and telemetry evidence are retained.

Additional Azure-native Sentinel/Defender execution is not claimed unless corresponding evidence is added.
EOF

cat > "$PORTFOLIO_ROOT/Cloud-Security/Unified-Cloud-Detection/GCP-Detection.md" << 'EOF'
# GCP Detection

## Existing portfolio evidence

The GCP security portfolio includes:
- project security assessment
- IAM policy analysis
- CSPM auditing
- Terraform infrastructure
- configuration collection
- detection logic

## SOC model

```
GCP activity
    |
    v
Cloud audit/configuration telemetry
    |
    v
Security detection
    |
    v
Analyst triage
    |
    v
IAM / resource investigation
    |
    v
Remediation
    |
    v
Verification
```

## Detection candidates

- privileged IAM modifications
- excessive permissions
- public resource exposure
- service-account changes
- security-control modifications

## Evidence integrity

Only executed and retained GCP artifacts are described as observed.

Unexecuted detection scenarios remain:
**PENDING LIVE VALIDATION**
EOF

cat > "$PORTFOLIO_ROOT/Cloud-Security/Unified-Cloud-Detection/ATT&CK-Mapping.md" << 'EOF'
# Cloud Detection — ATT&CK Mapping

| Scenario | ATT&CK relationship | Status |
|---|---|---|
| Valid account / cloud identity use | T1078 | Evidence-dependent |
| Account manipulation | T1098 | Methodology unless evidenced |
| Additional cloud roles | T1098.003 | Methodology unless evidenced |
| Cloud service discovery | T1526 | Methodology unless evidenced |
| Permission groups/discovery | T1069.003 | Methodology unless evidenced |

## Rule

Cloud configuration evidence can identify security weaknesses without proving attacker activity.

A permissive IAM policy is a security finding.

It is not automatically evidence of compromise.
EOF

log_success "Created Cloud Detection documentation"

# ============================================
# PHASE 11: Upgrade SOC Automation
# ============================================
log_step "PHASE 11: Creating SOC Automation Documentation"

cat > "$PORTFOLIO_ROOT/Automation/SOC-Automation/PLAYBOOK.md" << 'EOF'
# SOC Alert Enrichment & Triage Playbook

## Objective

Demonstrate how repetitive analyst work can be automated while retaining human decision-making for security-sensitive actions.

## Workflow

```
Alert
  |
  v
Parse event
  |
  v
Extract IOCs (IP, Domain, Hash, User, Host)
  |
  v
Normalize
  |
  v
Enrich
  |
  v
Classify
  |
  v
Prioritize
  |
  v
Generate analyst summary
  |
  v
Human review
  |
  ├──→ Close / monitor
  |
  └──→ Escalate / contain / response
```

## Automation candidates

- JSON parsing
- IOC extraction
- event normalization
- duplicate alert detection
- enrichment
- severity classification
- Markdown/HTML case generation
- evidence indexing
- executive summary generation

## Safety boundary

Automation should not silently perform destructive response actions.

Actions such as:
- account disablement
- host isolation
- firewall blocking
- deletion
- credential rotation

should require explicit authorization or a controlled test environment.

## Evidence

Measured time savings, detection rates or response improvements are only reported when experimentally measured.

Otherwise results are classified as:
**METHODOLOGY**
EOF

cat > "$PORTFOLIO_ROOT/Automation/SOC-Automation/README.md" << 'EOF'
# SOC Automation

## Purpose

This project demonstrates practical automation for repetitive SOC analyst work using Python, Bash and PowerShell.

The focus is not automation for its own sake.

The objective is to reduce repetitive processing while keeping security decisions explainable and auditable.

## Workflow

**Alert/log → parse → normalize → IOC extraction → enrichment → classification → prioritization → analyst summary → case/report**

## Architecture

```
              SIEM / Log Source
                     |
                     v
              Event ingestion
                     |
                     v
                Normalizer
                     |
          +----------+----------+
          |          |          |
         IOC       Host        User
       extraction  context     context
          |          |          |
          +----------+----------+
                     |
                     v
                 Enrichment
                     |
                     v
                Classification
                     |
                     v
                 Prioritization
                     |
                     v
              Analyst decision
                     |
             +-------+-------+
             |               |
          Escalate         Close
             |
             v
       Case/report output
```

## Automation outputs

Where appropriate:
- JSON
- CSV
- Markdown
- HTML

## Engineering requirements

Each automation should document:
1. Problem
2. Manual workflow
3. Inputs
4. Processing
5. Outputs
6. Error handling
7. Testing
8. Limitations

## Human-in-the-loop

Automation assists the analyst.

It does not automatically declare an event malicious or perform destructive containment without an explicitly authorized workflow.

## Evidence integrity

Do not claim:
- measured time savings
- accuracy
- detection rates
- false-positive reduction
- automated containment

unless those outcomes have actually been measured and retained as evidence.

See `PLAYBOOK.md` for the analyst workflow.
EOF

log_success "Created SOC Automation documentation"

# ============================================
# PHASE 12: Verification
# ============================================
log_step "PHASE 12: Running Verification Checks"

echo "" | tee -a "$LOG_FILE"
echo "Verification Results:" | tee -a "$LOG_FILE"
echo "===================" | tee -a "$LOG_FILE"

# Check directories
DIRS=(
    "SOC/Microsoft-Sentinel-KQL/KQL"
    "SOC/Microsoft-Sentinel-KQL/Detection-Rules"
    "SOC/Endpoint-Detection"
    "SOC/MITRE-ATT&CK"
    "Cloud-Security/Unified-Cloud-Detection"
    "Automation/SOC-Automation"
)

for dir in "${DIRS[@]}"; do
    if [ -d "$PORTFOLIO_ROOT/$dir" ]; then
        log_success "Directory exists: $dir"
    else
        log_warning "Directory missing: $dir"
    fi
done

# Check files
FILES=(
    "SOC/Microsoft-Sentinel-KQL/README.md"
    "SOC/Microsoft-Sentinel-KQL/KQL/Authentication-Investigation.kql"
    "SOC/Microsoft-Sentinel-KQL/KQL/Suspicious-PowerShell.kql"
    "SOC/Microsoft-Sentinel-KQL/KQL/Suspicious-Process-Activity.kql"
    "SOC/Microsoft-Sentinel-KQL/KQL/Network-Investigation.kql"
    "SOC/Microsoft-Sentinel-KQL/Detection-Rules/README.md"
    "SOC/Microsoft-Sentinel-KQL/ATT&CK-Mapping.md"
    "SOC/Endpoint-Detection/README.md"
    "SOC/Endpoint-Detection/Windows-Sysmon-Investigation.md"
    "SOC/Endpoint-Detection/PowerShell-Investigation.md"
    "SOC/MITRE-ATT&CK/README.md"
    "SOC/MITRE-ATT&CK/COVERAGE-MATRIX.md"
    "Cloud-Security/Unified-Cloud-Detection/README.md"
    "Cloud-Security/Unified-Cloud-Detection/Azure-Detection.md"
    "Cloud-Security/Unified-Cloud-Detection/GCP-Detection.md"
    "Cloud-Security/Unified-Cloud-Detection/ATT&CK-Mapping.md"
    "Automation/SOC-Automation/README.md"
    "Automation/SOC-Automation/PLAYBOOK.md"
)

FILE_COUNT=0
for file in "${FILES[@]}"; do
    if [ -f "$PORTFOLIO_ROOT/$file" ]; then
        log_success "File exists: $file"
        ((FILE_COUNT++))
    else
        log_warning "File missing: $file"
    fi
done

# Final summary
echo "" | tee -a "$LOG_FILE"
echo "========================================" | tee -a "$LOG_FILE"
echo "Setup Complete!" | tee -a "$LOG_FILE"
echo "========================================" | tee -a "$LOG_FILE"
echo "Total files created: $FILE_COUNT" | tee -a "$LOG_FILE"
echo "Log file: $LOG_FILE" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"
echo "Next steps:" | tee -a "$LOG_FILE"
echo "1. Review the created structure" | tee -a "$LOG_FILE"
echo "2. Customize for your environment" | tee -a "$LOG_FILE"
echo "3. Add your own evidence/queries" | tee -a "$LOG_FILE"
echo "4. Commit to git:" | tee -a "$LOG_FILE"
echo "   git add SOC/ Cloud-Security/Unified-Cloud-Detection/ Automation/" | tee -a "$LOG_FILE"
echo "   git commit -m 'Add comprehensive SOC structure with Sentinel/KQL, EDR, and cloud detection'" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

log_success "All phases complete!"
