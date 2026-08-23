# Active Directory Security Lab Report

## Lab Overview

Platform: Microsoft Active Directory

## Objectives

- Deploy Active Directory environment
- Create users and groups
- Configure permissions
- Apply security policies
- Perform security assessment

## Planned Activities

- Domain Controller deployment
- User management
- Group Policy configuration
- Password policies
- Privilege review
- Security auditing

## Evidence

Screenshots:

Active-Directory/Screenshots/

## Current Status

**Live Domain Controller deployment: pending** (requires a Windows Server
environment).

**Detection engineering: complete (offline/synthetic).** The
[Active Directory Detection Lab](../Detection-Lab/README.md) analyzes
synthetic Windows Security event data for brute force authentication,
Kerberoasting, privileged group membership changes, account creation, and
audit log clearing, with MITRE ATT&CK mapping and an automated pytest
suite. See `Active-Directory/Detection-Lab/`.
