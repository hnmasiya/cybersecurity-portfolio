#!/usr/bin/env python3
"""Offline IOC normalization for synthetic indicators only."""
import json,sys,ipaddress
from pathlib import Path
data=json.loads(Path(sys.argv[1]).read_text())
out=[]
for i in data["indicators"]:
    value=i["value"]
    valid=True
    if i["type"]=="ipv4":
        try: ipaddress.ip_address(value)
        except ValueError: valid=False
    elif i["type"]=="sha256":
        valid=len(value)==64 and all(c in "0123456789abcdefABCDEF" for c in value)
    elif i["type"]=="domain":
        valid=value.endswith(".invalid")
    out.append({**i,"normalized":value.lower(),"format_valid":valid,"routable_check":"not performed"})
print(json.dumps({"case_id":data["case_id"],"evidence_state":data["evidence_state"],"results":out},indent=2))
