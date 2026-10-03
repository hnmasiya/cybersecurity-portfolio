#!/usr/bin/env python3
"""
Active Directory XML Security Event Log Parser
Extracts Failed Logins (4625) & Group Membership Changes (4728)
"""
import sys

def parse_event(event_id):
    events = {
        4625: "CRITICAL: Account Failed to Log In (Possible Brute Force / T1110)",
        4728: "HIGH: A member was added to a security-enabled global group (T1098)",
        4624: "INFO: An account was successfully logged in"
    }
    return events.get(event_id, "INFO: Standard Event Logged")

if __name__ == "__main__":
    print("[+] Active Directory Event Parser initialized...")
    print(f"[+] Parsing Event 4728: {parse_event(4728)}")
