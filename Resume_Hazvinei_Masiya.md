<!-- Single cybersecurity-first resume source. Enterprise IT/infrastructure experience is integrated into the cybersecurity profile. -->

<style>
  @page { size: letter; margin: 0.28in 0.32in; }
  body { font-family: 'Times New Roman', Times, serif; font-size: 8.4pt; line-height: 1.14; color: #0f172a; margin: 0; }
  .header { text-align: center; border-bottom: 1.5px solid #0f172a; padding-bottom: 2px; margin-bottom: 3px; }
  h1 { font-size: 14pt; margin: 0; text-transform: uppercase; letter-spacing: 0.5px; color: #0f172a; }
  .subtitle { font-size: 9pt; font-weight: bold; color: #2563eb; margin-top: 1px; }
  .contact { font-size: 7.6pt; color: #334155; margin-top: 2px; }
  h2 { font-size: 8.5pt; text-transform: uppercase; color: #0f172a; border-bottom: 1px solid #cbd5e1; margin: 4px 0 1px 0; padding-bottom: 1px; letter-spacing: 0.5px; }
  p, ul { margin: 0 0 1px 0; }
  ul { padding-left: 11px; }
  li { margin-bottom: 0.5px; }
  .job-header { margin-top: 1.5px; font-size: 8.6pt; }
  .job-title { font-weight: bold; color: #0f172a; }
  .company { font-style: italic; color: #334155; }
  .date { float: right; font-weight: bold; color: #2563eb; }
  .project-title { font-weight: bold; color: #1e293b; font-size: 8.4pt; margin-top: 1.5px; }
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
CompTIA Security+ certified enterprise IT professional with 12+ years of experience across enterprise IT support, infrastructure, systems administration, network engineering, access control, endpoint security, and security-conscious technical operations. I am deliberately applying that enterprise foundation to cybersecurity, with independent hands-on work in SIEM detection engineering, threat hunting, incident investigation, DFIR, Windows/Sysmon telemetry, and security automation using Wazuh, Sysmon, Python, Bash, and PowerShell. Professional employment experience and independent security-lab work are clearly distinguished throughout the portfolio.

<h2>Core Competencies & Technical Stack</h2>
<ul>
  <li><b>SIEM & Detection Engineering:</b> Wazuh SIEM, Sysmon XML Rules, Custom Alert Pipelines, FIM (File Integrity Monitoring), MITRE ATT&CK mapping</li>
  <li><b>DFIR & Threat Hunting:</b> Linux Auth/Syslog Forensics, PCAP Packet Analysis (Tshark/Wireshark), Hash Verification, evidence preservation and investigation workflows</li>
  <li><b>Security Automation & Scripting:</b> Python (IOC and log parsers), Bash, PowerShell, YAML, deterministic validation workflows</li>
  <li><b>Enterprise IT & Systems Security:</b> Windows 10/11, Windows Server, Active Directory, Group Policy, Microsoft 365, RBAC, least privilege, endpoint hardening, patch management, authentication and access control</li>
  <li><b>Network & Infrastructure Security:</b> LAN/WAN, Dell Versa SD-WAN (VEP1425/VEP1485), VOS, Cisco, Aruba, Sophos XG, network deployment, connectivity validation and infrastructure migration</li>
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

<div style="page-break-before: always;"></div>
<h2>Professional Experience</h2>

<div class="job-header">
  <span class="date">Jan 2025 – Present</span>
  <span class="job-title">Information Technology Support Specialist</span> | <span class="company">Netvantage Partners</span>
</div>
<ul>
  <li>Deliver 1st and 2nd line technical support across client environments, resolving hardware, software, Windows endpoint, authentication, and connectivity issues.</li>
  <li>Support Active Directory accounts, user access, secure onboarding, structured patch management, and vulnerability mitigation across client systems.</li>
  <li>Investigate and escalate security-relevant incidents, including malware alerts and unauthorized access attempts, using security-aware triage.</li>
  <li>Develop IT support documentation and incident-handling procedures to standardize response consistency.</li>
</ul>

<div class="job-header">
  <span class="date">Jan 2021 – Present</span>
  <span class="job-title">IT Support Specialist (Contract & Consulting)</span> | <span class="company">Zuetech Technology Solutions</span>
</div>
<ul>
  <li>Provide enterprise IT support, infrastructure administration, network operations, and onsite client deployment services across multiple environments.</li>
  <li>Administer Active Directory, RBAC, least-privilege access, Group Policy and Microsoft 365; troubleshoot authentication, endpoint and application issues.</li>
  <li>Monitor endpoint, network, and system activity for anomalies, applying security-aware triage principles to identify and escalate security-relevant incidents.</li>
  <li>Deploy and configure Dell Versa SD-WAN appliances, including VOS upgrades, IP configuration, migration support, and connectivity validation.</li>
  <li>Deliver endpoint protection, patch deployment, vulnerability mitigation, and technical documentation across client networks.</li>
  <li>Install and configure Yeastar P-Series PBX/UCaaS solutions for reseller clients as part of enterprise communications and infrastructure deployments.</li>
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

<h2>Cybersecurity Virtual Experience</h2>

<div class="project-title">Mastercard Cybersecurity Job Simulation — Forage | Completed September 20, 2026</div>
<ul>
  <li>Designed a phishing email simulation and analyzed supplied phishing-campaign results to support security-awareness training.</li>
  <li>Created a phishing-awareness presentation covering phishing tactics, red flags, reporting and prevention.</li>
  <li><b>Skills:</b> cybersecurity, security awareness, phishing analysis, security training, data analysis, data visualization, communication, problem solving and strategy.</li>
</ul>

<div class="project-title">Datacom Cyber Security Operations Job Simulation — Forage | Completed September 20, 2026</div>
<ul>
  <li>Investigated a simulated cyberattack and documented findings, indicators, response priorities and security recommendations.</li>
  <li>Conducted a comprehensive cybersecurity risk assessment using a 5×5 likelihood/consequence approach across phishing, ransomware, third-party exposure, e-commerce/AWS and remote-access risks.</li>
  <li><b>Skills:</b> information security, OSINT, research, risk assessment, risk management, security analysis, analytical skills and communication.</li>
</ul>

<blockquote>Forage virtual job simulations; not employment with Mastercard or Datacom.</blockquote>

<h2>Certifications & Education</h2>
<ul>
  <li><b>CompTIA Security+ (SY0-701)</b> — CompTIA</li>
  <li><b>Google Cybersecurity Professional Certificate</b> — Google</li>
  <li><b>Google IT Support Professional Certificate</b> — Google</li>
  <li><b>BSc in Computer Science</b> — Unicaf University (In Progress)</li>
  <li><b>Diploma in Information Technology</b> — Macmaine School of Computing</li>
  <li><b>Diploma in PC Maintenance and Networking</b> — Macmaine School of Computing</li>
</ul>
