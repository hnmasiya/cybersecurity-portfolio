# DVWA — File Upload

## Objective

Assess the DVWA File Upload module to determine whether uploaded content is sufficiently validated and safely stored.

## Skills & Tools

- DVWA
- Browser
- Burp Suite Community Edition
- HTTP multipart/form-data analysis
- Linux
- Git
- Security evidence collection

## Architecture

The assessment was performed in a controlled local cybersecurity laboratory on Zorin OS.

| Component | Details |
|---|---|
| Application | DVWA |
| Vulnerability | File Upload |
| Security Level | Low |
| Operating System | Zorin OS |
| Web Server | Apache 2.4.58 (Ubuntu) |
| Database | MariaDB 10.11.14 |
| PHP | 8.3.6 |
| Testing Tools | Browser, Burp Suite Community Edition |

## Topology

Testing was performed against the local DVWA File Upload module.

## Execution

The upload functionality was reviewed and a controlled test file was submitted. The application's response and resulting upload behaviour were observed.

## Walkthrough

1. Accessed the File Upload module.
2. Reviewed the upload form.
3. Submitted a controlled test file.
4. Observed the application response.
5. Determined how the uploaded file was handled.
6. Assessed the validation controls.
7. Collected evidence.

## Attack Simulation

The simulation represented an attacker attempting to bypass weak upload validation and place unauthorized content on the web server.

Testing was confined to the local DVWA laboratory.

## Detection

Monitor:

- Unexpected file extensions
- Executable content in upload directories
- Script files placed in web-accessible directories
- Unusual upload volume
- Requests to newly uploaded files

## Triage

File-upload weaknesses should receive high priority where uploaded files can be executed by the web server.

## Investigation

Review:

- Upload directory contents
- Web-server access logs
- File creation timestamps
- File ownership and permissions
- Requests targeting newly uploaded files

## Evidence

The following repository evidence files match this assessment:

- `Web-Security/DVWA/Screenshots/file-upload-page.png`
- `Web-Security/DVWA/Screenshots/file-upload-success.png`

## Findings

The DVWA File Upload module intentionally contains weak file-validation controls.

The assessment demonstrated that a test file could be successfully uploaded without robust validation controls.

**Finding:** File upload validation is insufficient.

**Risk Rating:** High

## Impact

Depending on server configuration, insecure uploads may allow:

- Unauthorized file storage
- Malicious content placement
- Server-side script execution
- Web-shell deployment
- Further server compromise

## Root Cause

Uploaded content is not sufficiently validated by type and content before being stored, and insecure storage locations may expose uploaded files to direct web access.

## MITRE ATT&CK

**T1505.003 — Server Software Component: Web Shell**

If an attacker can upload and execute server-side code, the weakness may provide a path to web-shell persistence.

## Remediation

- Validate file content, not only extensions.
- Restrict permitted MIME types.
- Rename uploaded files.
- Store uploads outside the web root.
- Disable script execution in upload directories.
- Enforce file-size limits.
- Apply least-privilege permissions.

## Validation

Verify that:

1. Approved file types upload successfully.
2. Disallowed extensions are rejected.
3. Content/type mismatches are rejected.
4. Uploaded files cannot execute as server-side scripts.
5. Upload directories cannot be used as execution locations.

## Lessons Learned

The exercise demonstrated that file extension checks alone are insufficient and that secure storage location and server execution permissions are equally important.

## Recommendations

Use layered upload controls including content inspection, extension allow-lists, safe renaming, isolated storage, execution restrictions, size limits, and malware scanning where appropriate.
