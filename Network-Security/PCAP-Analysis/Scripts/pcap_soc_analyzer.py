#!/usr/bin/env python3
import argparse,csv,subprocess,sys
from pathlib import Path
from urllib.parse import unquote

FIELDS=["frame.number","ip.src","ip.dst","http.host","http.request.uri","http.user_agent"]

def score_request(r):
    """Score a single parsed HTTP request row for suspicious indicators.
    Returns (score, reasons) without mutating r."""
    uri=unquote(r["http.request.uri"]).lower(); host=r["http.host"].lower(); ua=r["http.user_agent"].lower()
    score=0; reasons=[]
    if host=="malicious.example.test": score+=3; reasons.append("synthetic suspicious host")
    if "cmd=" in uri or "/bin/sh" in uri or "/payload" in uri: score+=3; reasons.append("command-execution pattern")
    if "or '1'='1" in uri or "or%20" in uri: score+=3; reasons.append("SQL-injection-like pattern")
    if "/etc/passwd" in uri: score+=3; reasons.append("sensitive-file pattern")
    if "scanner" in ua: score+=2; reasons.append("scanner-like user agent")
    return score, reasons

def find_suspicious(rows):
    suspicious=[]
    for r in rows:
        score,reasons=score_request(r)
        if score>=3:
            x=dict(r); x["score"]=score; x["reasons"]="; ".join(reasons); suspicious.append(x)
    return suspicious

def main():
    ap=argparse.ArgumentParser(description="SOC PCAP HTTP analyzer")
    ap.add_argument("pcap",type=Path)
    ap.add_argument("--output",type=Path,default=Path("Evidence"))
    a=ap.parse_args()
    if not a.pcap.is_file():
        print(f"ERROR: PCAP not found: {a.pcap}",file=sys.stderr); return 1
    a.output.mkdir(parents=True,exist_ok=True)
    fields=FIELDS
    cmd=["tshark","-r",str(a.pcap),"-Y","http.request","-T","fields","-E","header=y","-E","separator=|"]
    for f in fields: cmd += ["-e",f]
    out=subprocess.run(cmd,capture_output=True,text=True,check=True).stdout.splitlines()
    rows=[]
    for line in out[1:]:
        v=line.split("|"); v += [""]*(len(fields)-len(v)); rows.append(dict(zip(fields,v)))
    suspicious=find_suspicious(rows)
    outcsv=a.output/"automated-analysis.csv"
    with outcsv.open("w",newline="\n") as fh:
        w=csv.DictWriter(fh,fieldnames=fields+["score","reasons"],lineterminator="\n"); w.writeheader(); w.writerows(suspicious)
    print("PCAP SOC ANALYZER")
    print("="*50)
    print(f"HTTP requests analyzed : {len(rows)}")
    print(f"Suspicious requests    : {len(suspicious)}")
    print(f"Evidence output        : {outcsv}")
    for r in suspicious: print(f"HIGH frame={r['frame.number']} host={r['http.host']} uri={r['http.request.uri']} score={r['score']}")
    return 0
if __name__=="__main__": raise SystemExit(main())
