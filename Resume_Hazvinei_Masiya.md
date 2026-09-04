<!-- Resume maintained as the current September 2026 version. -->

<style>
  @page { size: letter; margin: 0.35in; }
  body { font-family: 'Helvetica Neue', Arial, sans-serif; font-size: 8.8pt; line-height: 1.22; color: #0f172a; margin: 0; }
  .header { text-align: center; border-bottom: 1.5px solid #0f172a; padding-bottom: 3px; margin-bottom: 4px; }
  h1 { font-size: 15pt; margin: 0; text-transform: uppercase; letter-spacing: 0.5px; color: #0f172a; }
  .subtitle { font-size: 9.5pt; font-weight: bold; color: #2563eb; margin-top: 1px; }
  .contact { font-size: 8pt; color: #334155; margin-top: 2px; }
  h2 { font-size: 9pt; text-transform: uppercase; color: #0f172a; border-bottom: 1px solid #cbd5e1; margin: 5px 0 2px 0; padding-bottom: 1px; letter-spacing: 0.5px; }
  p, ul { margin: 0 0 2px 0; }
  ul { padding-left: 12px; }
  li { margin-bottom: 1px; }
  .job-header { margin-top: 2px; font-size: 9pt; }
  .job-title { font-weight: bold; color: #0f172a; }
  .company { font-style: italic; color: #334155; }
  .date { float: right; font-weight: bold; color: #2563eb; }
  .project-title { font-weight: bold; color: #1e293b; font-size: 8.8pt; margin-top: 2px; }
</style>

<div class="header">
  <h1>HAZVINEI NOMATTER MASIYA</h1>
  <div class="subtitle">Cybersecurity Analyst · Security Operations · Detection & Automation</div>
  <div class="contact">
    Harare, Zimbabwe &nbsp;|&nbsp; norman.masiya@gmail.com &nbsp;|&nbsp; +263 77 521 6823 / +263 71 866 2162<br>
    <b>GitHub:</b> https://github.com/hnmasiya &nbsp;|&nbsp; <b>Portfolio:</b> https://masiya-hub.org &nbsp;|&nbsp; <b>LinkedIn:</b> https://www.linkedin.com/in/hazvinei-masiya/
  </div>
</div>

<h2>Professional Summary</h2>
CompTIA Security+ certified enterprise IT professional with 12+ years of experience across enterprise IT infrastructure, systems administration, network engineering, and security-conscious technical support. I am deliberately transitioning that enterprise foundation into cybersecurity, with independent hands-on work in SIEM detection engineering, threat hunting, incident investigation, DFIR, Windows/Sysmon telemetry, and security automation using Wazuh, Sysmon, Python, Bash, and PowerShell. Professional employment experience and independent security-lab work are clearly distinguished throughout the portfolio.

<h2>Core Competencies & Technical Stack</h2>
<ul>
  <li><b>SIEM & Detection Engineering:</b> Wazuh SIEM, Sysmon XML Rules, Custom Alert Pipelines, FIM (File Integrity Monitoring), MITRE ATT&CK mapping</li>
  <li><b>DFIR & Threat Hunting:</b> Linux Auth/Syslog Forensics, PCAP Packet Analysis (Tshark/Wireshark), Hash Verification, evidence preservation and investigation workflows</li>
  <li><b>Security Automation & Scripting:</b> Python (IOC and log parsers), Bash, PowerShell, YAML, deterministic validation workflows</li>
  <li><b>Network & Systems Security:</b> Active Directory (GPO, Event Log Analysis), Dell Versa SD-WAN, Sophos XG, Aruba/Cisco infrastructure, access control and hardening</li>
  <li><b>Cloud & DevSecOps:</b> Azure Windows security lab, GCP Terraform architecture, GitHub Actions CI/CD, cloud security controls</li>
</ul>

<h2>Security Engineering Projects & Artifacts</h2>

<div class="project-title">Windows Sysmon / Wazuh LSASS Detection Validation</div>
<ul>
  <li>Captured and validated Sysmon Event ID 10 telemetry from a self-owned Windows Server lab through Wazuh Agent 003 (dc01-lab).</li>
  <li>Correlated process access to <code>lsass.exe</code> with custom Wazuh detection logic, including observed event records and <code>GrantedAccess</code> values.</li>
  <li>Mapped the investigation to MITRE ATT&amp;CK T1003.001 and T1059.001 while explicitly distinguishing observed LSASS access from proof of successful credential dumping.</li>
</ul>

<div class="project-title">Wazuh SIEM Rules & FIM Lab</div>
<ul>
  <li>Authored custom XML detection rules for authentication and privilege-related activity and validated rule behavior against controlled test events.</li>
  <li>Configured File Integrity Monitoring across critical Linux system binaries and configuration files and documented validation methodology.</li>
</ul>

<div class="project-title">Linux Incident Response & DFIR</div>
<ul>
  <li>Analyzed Linux authentication and system logs to reconstruct post-incident attack timelines.</li>
  <li>Verified SHA-256 evidence integrity and mapped unauthorized SSH activity to MITRE ATT&amp;CK.</li>
</ul>

<div class="project-title">Active Directory Security Event Automation</div>
<ul>
  <li>Developed Python tooling to parse Windows Security XML event logs (4624, 4625, 4728).</li>
  <li>Automated identification of suspicious authentication and privileged group-membership activity for investigation.</li>
</ul>

<div class="project-title">PCAP Traffic & Triage Automation</div>
<ul>
  <li>Processed captured network traffic using Tshark and custom Python parsing scripts to identify suspicious HTTP requests, hosts, protocols, and indicators of compromise.</li>
  <li>Automated triage of web-application scanning and SQL-injection patterns in controlled laboratory traffic.</li>
</ul>

<h2>Professional Experience</h2>

<div class="job-header">
  <span class="date">Jan 2025 – Present</span>
  <span class="job-title">Information Technology Support Specialist</span> | <span class="company">Netvantage Partners</span>
</div>
<ul>
  <li>Investigate and resolve security-relevant incidents, including malware alerts, unauthorized access attempts, and connectivity disruptions.</li>
  <li>Support vulnerability mitigation through structured patch management and secure endpoint deployment across client environments.</li>
  <li>Deliver 1st and 2nd line IT support across multiple client environments, including desktop/laptop diagnostics and hardened onboarding processes.</li>
  <li>Develop IT support documentation and incident-handling procedures to standardize response consistency.</li>
</ul>

<div class="job-header">
  <span class="date">Jan 2021 – Present</span>
  <span class="job-title">IT Support Specialist (Contract & Consulting)</span> | <span class="company">Zuetech Technology Solutions</span>
</div>
<ul>
  <li>Provide enterprise IT support, infrastructure administration, and network operations across client environments, including Active Directory administration, RBAC, and least-privilege access control.</li>
  <li>Monitor endpoint, network, and system activity for anomalies, applying security-aware triage principles to identify and escalate security-relevant incidents.</li>
  <li>Deploy and configure enterprise Dell Versa SD-WAN appliances, including Versa Operating System (VOS) upgrades, IP configuration, migration support, and connectivity validation.</li>
  <li>Deliver endpoint protection, patch deployment, and vulnerability mitigation across client networks; troubleshoot Microsoft 365 and application issues.</li>
  <li>Maintain technical documentation and SOP development to standardize client support delivery.</li>
  <li>Client project — Network Infrastructure Upgrade, Mastercard Zimbabwe (Mar–Apr 2022): installed sensor LAN cabling, decommissioned legacy Cisco switches/controllers/APs, and racked/installed new Aruba controllers, switches, and access points.</li>
  <li>Client project — SD-WAN Circuit Deployment, SITA AERO (Jul 2026): configured two Dell Versa VEP1485 appliances via console CLI, connected each to a dedicated internet circuit, and verified connectivity.</li>
  <li>Client project — Qatar Airways VOS Upgrade &amp; SD-WAN Migration, Harare Airport Back Office &amp; City Office (Aug 2026): performed VOS upgrading, device onboarding, and SD-WAN migration on Dell VEP1425 appliances.</li>
</ul>

<div class="job-header">
  <span class="date">Jan 2019 – Dec 2020</span>
  <span class="job-title">Desktop Support Technician</span> | <span class="company">Raising Dawn Investment</span>
</div>
<ul>
  <li>Administered user accounts, permissions, and security groups for 120+ users; supported access-control administration.</li>
  <li>Monitored Sophos Endpoint Protection and firewall telemetry, escalating security anomalies and endpoint issues.</li>
  <li>Supported backup, recovery, and business continuity operations, maintaining technical and operational documentation.</li>
</ul>

<div class="job-header">
  <span class="date">Jan 2016 – Dec 2018</span>
  <span class="job-title">Information Technology Support Technician</span> | <span class="company">Compusys Technology</span>
</div>
<ul>
  <li>Delivered desktop, network, and infrastructure support across multiple client environments; managed user access controls and permissions.</li>
  <li>Applied security patches, supported vulnerability remediation, and investigated authentication/access-control issues.</li>
  <li>Client project — IT Equipment Deployment and Configuration, Ericsson Zimbabwe (Nov 2016–Dec 2018): re-imaged laptop fleets, joined devices to the domain, configured email access, and installed network switches/access points.</li>
</ul>

<div class="job-header">
  <span class="date">Mar 2014 – Dec 2015</span>
  <span class="job-title">Help Desk Support Technician</span> | <span class="company">shermanit</span>
</div>
<ul>
  <li>Supported 200+ users across multiple business locations, providing remote and onsite technical support within defined SLA requirements.</li>
  <li>Troubleshot hardware, software, networking, and authentication issues; supported software deployments and infrastructure updates.</li>
  <li>Client project — IT Infrastructure Upgrade, AJP Group (May–Aug 2015): retired outdated systems, onboarded new devices to the domain, implemented VoIP phone systems, and migrated data to new systems.</li>
</ul>

<div class="job-header">
  <span class="date">Jul 2012</span>
  <span class="job-title">IT System Migration and Setup (Contract)</span> | <span class="company">Abbeydale Group</span>
</div>
<ul>
  <li>Engaged as outside technical support prior to formally joining shermanit: migrated servers, installed HP switches, re-imaged PCs, joined computers to the domain, connected VoIP phones, decommissioned outdated computers with secure data disposal, and reconnected IP cameras to new PoE switches.</li>
</ul>

<h2>Certifications & Education</h2>
<ul>
  <li><b>CompTIA Security+ (SY0-701)</b> — CompTIA</li>
  <li><b>Google Cybersecurity Professional Certificate</b> — Google</li>
  <li><b>Google IT Support Professional Certificate</b> — Google</li>
  <li><b>BSc in Computer Science</b> — Unicaf University (In Progress)</li>
</ul>
