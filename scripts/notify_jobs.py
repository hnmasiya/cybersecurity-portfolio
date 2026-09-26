#!/usr/bin/env python3
import csv, os, smtplib, ssl
from email.message import EmailMessage
from pathlib import Path

def main():
    rows=list(csv.DictReader(Path(os.environ["JOB_CSV"]).open(encoding="utf-8")))
    state=Path(os.environ.get("ALERT_STATE",".career-alert-state.txt"))
    seen=set(state.read_text(encoding="utf-8").splitlines()) if state.exists() else set()
    threshold=float(os.environ.get("HIGH_RELEVANCE_THRESHOLD","70"))
    matches=[r for r in rows if float(r.get("match_score","0") or 0)>=threshold and r.get("ats_pass")=="true" and r.get("tailored_path") and r.get("url") not in seen]
    if not matches: print("No new high-relevance ATS-passed jobs."); return
    lines=["New high-relevance cybersecurity jobs with ATS-validated tailored applications:",""]
    for r in matches[:10]:
        lines += [f"- {r.get('title')} — {r.get('company')} — {r.get('location')}",f"  Match: {r.get('match_score')}/100 | ATS: {r.get('ats_score')}/100",f"  Apply: {r.get('url')}",""]
    msg=EmailMessage(); msg["Subject"]="Cybersecurity job alert — tailored application ready"; msg["From"]=os.environ["SMTP_USERNAME"]; msg["To"]=os.environ["NOTIFY_EMAIL"]; msg.set_content("\n".join(lines))
    with smtplib.SMTP_SSL(os.environ["SMTP_HOST"],int(os.environ.get("SMTP_PORT","465")),context=ssl.create_default_context()) as s:
        s.login(os.environ["SMTP_USERNAME"],os.environ["SMTP_PASSWORD"]); s.send_message(msg)
    with state.open("a",encoding="utf-8") as f:
        for r in matches: f.write((r.get("url") or "")+"\n")
    print(f"Notification sent for {len(matches)} new job(s).")

if __name__=="__main__": main()
