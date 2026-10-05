#!/usr/bin/env python3
import argparse,json,xml.etree.ElementTree as ET
from pathlib import Path

def load_rule(path):
    r=ET.parse(path).find(".//rule")
    return {"id":r.get("id"),"level":r.get("level"),"match":r.findtext("match"),"if_sid":r.findtext("if_sid")}

def matching_rules(rules, event):
    """Return the ids of rules whose if_sid/match criteria are satisfied by event."""
    matched=[]
    for r in rules:
        ok=True
        if r["if_sid"] and r["if_sid"] != event["base_sid"]:
            ok=False
        if r["match"] and r["match"] not in event["message"]:
            ok=False
        if ok:
            matched.append(r["id"])
    return matched

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--rules",nargs="+",required=True)
    ap.add_argument("--events",required=True)
    args=ap.parse_args()
    rules=[load_rule(Path(x)) for x in args.rules]
    events=json.loads(Path(args.events).read_text())
    failures=0
    print("WAZUH OFFLINE RULE VALIDATOR")
    print("="*60)
    for e in events:
        matched=matching_rules(rules, e)
        status="PASS" if matched==e["expected"] else "FAIL"
        if status=="FAIL":
            failures+=1
        print(f"{status}: {e['id']} matched={matched} expected={e['expected']}")
    print("="*60)
    print("RESULT:", "PASS" if failures==0 else "FAIL")
    return 0 if failures==0 else 1

if __name__=="__main__":
    raise SystemExit(main())
