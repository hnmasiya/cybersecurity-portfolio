#!/usr/bin/env python3
"""Offline detection for synthetic Google Cloud Audit Log IAM policy changes."""
import json,sys
from pathlib import Path
events=json.loads(Path(sys.argv[1]).read_text())
hits=[]
for e in events:
    p=e.get("protoPayload",{})
    if p.get("methodName","").endswith("SetIAMPolicy"):
        hits.append({
            "timestamp":e.get("timestamp"),
            "principal":p.get("authenticationInfo",{}).get("principalEmail"),
            "resource":p.get("resourceName"),
            "detection":"IAM policy modification"
        })
print(json.dumps({"evidence_state":"OFFLINE VALIDATION","matches":hits,"count":len(hits)},indent=2))
