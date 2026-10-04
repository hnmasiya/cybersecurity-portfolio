#!/usr/bin/env python3
"""Analyze a synthetic email header set without sending or contacting any host."""
import re, sys, pathlib, json
text=pathlib.Path(sys.argv[1]).read_text()
auth=re.search(r"spf=(\w+).*?dkim=(\w+).*?dmarc=(\w+)", text, re.S)
reply=re.search(r"^Reply-To:\s*(.+)$", text, re.M)
result={
 "synthetic": "X-Synthetic-Training: true" in text,
 "spf": auth.group(1) if auth else "not_observed",
 "dkim": auth.group(2) if auth else "not_observed",
 "dmarc": auth.group(3) if auth else "not_observed",
 "reply_to": reply.group(1).strip() if reply else "not_observed",
 "risk_flags": []
}
if result["spf"] != "pass": result["risk_flags"].append("SPF not passing")
if result["dkim"] != "pass": result["risk_flags"].append("DKIM not passing")
if result["dmarc"] != "pass": result["risk_flags"].append("DMARC not passing")
if result["reply_to"] != "not_observed": result["risk_flags"].append("Reply-To header present")
print(json.dumps(result, indent=2))
