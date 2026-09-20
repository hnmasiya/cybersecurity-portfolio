#!/usr/bin/env python3
import csv, os, smtplib, ssl
from email.message import EmailMessage
from pathlib import Path

def main():
    csv_path=Path(os.environ["JOB_CSV"])
    rows=list(csv.DictReader(csv_path.open(encoding="utf-8")))
    threshold=float(os.environ.get("HIGH_RELEVANCE_THRESHOLD","70"))
    matches=[r for r in rows if float(r.get("score","0") or 0) >= threshold and r.get("tailored_path")]
    if not matches:
        print("No high-relevance new jobs to notify.")
        return
    host=os.environ["SMTP_HOST"]; port=int(os.environ.get("SMTP_PORT","465"))
    user=os.environ["SMTP_USERNAME"]; password=os.environ["SMTP_PASSWORD"]
    to=os.environ["NOTIFY_EMAIL"]
    lines=["High-relevance cybersecurity jobs detected and tailored packages generated:",""]
    for r in matches[:10]:
        lines += [f"- {r.get('title')} — {r.get('company')} — {r.get('location')}",
                  f"  Match score: {r.get('score')}; ATS gate: {r.get('ats_score','PASS')}",
                  f"  Apply: {r.get('url') or r.get('job_url')}",
                  f"  Package: {r.get('tailored_path')}",""]
    msg=EmailMessage()
    msg["Subject"]="Cybersecurity job alert — tailored application ready"
    msg["From"]=user; msg["To"]=to
    msg.set_content("\\n".join(lines))
    with smtplib.SMTP_SSL(host,port,context=ssl.create_default_context()) as s:
        s.login(user,password); s.send_message(msg)
    print(f"Notification sent for {len(matches)} job(s).")
if __name__=="__main__": main()
