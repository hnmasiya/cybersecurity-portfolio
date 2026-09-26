#!/usr/bin/env bash
set -eo pipefail

SCRIPT_VERSION="2.1.1"
REPO_ROOT="${REPO_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
SPLUNK_HOME="/opt/splunk"
SPLUNK_USER="admin"
SPLUNK_PASSWORD="${SPLUNK_PASSWORD:-}"
RUN_SPLUNK="1"

LAB3="$REPO_ROOT/SIEM/Splunk/Lab-03-Web-Attack-HTTP-Investigation"
LAB4="$REPO_ROOT/SIEM/Splunk/Lab-04-Detection-Engineering-SPL-Alert-Logic"
LAB5="$REPO_ROOT/SIEM/Splunk/Lab-05-Dashboarding-SOC-Monitoring"
LAB6="$REPO_ROOT/SIEM/Splunk/Lab-06-End-to-End-SOC-Investigation"

log(){ printf '[%s] %s\n' "$(date '+%H:%M:%S')" "$*"; }
command -v python3 >/dev/null || { echo "[ERROR] python3 is required" >&2; exit 1; }

for root in "$LAB3" "$LAB4" "$LAB5" "$LAB6"; do
  mkdir -p "$root/data" "$root/spl" "$root/reports" "$root/evidence" "$root/dashboard"
done

log "Splunk SOC Labs 03-06 master build v$SCRIPT_VERSION"

python3 - "$LAB3" "$LAB4" "$LAB5" "$LAB6" <<'PY'
from pathlib import Path
import csv,json,sys
from datetime import datetime,timedelta,timezone
L3,L4,L5,L6=map(Path,sys.argv[1:])
base=datetime(2026,9,25,8,0,0,tzinfo=timezone.utc)

def csvw(p,fields,rows):
    with p.open("w",newline="",encoding="utf-8") as f:
        w=csv.DictWriter(f,fieldnames=fields); w.writeheader(); w.writerows(rows)

ev=[
("10.10.20.25","GET","/index.php?id=1","200","-"),
("10.10.20.25","GET","/index.php?id=1%27%20OR%201%3D1--","500","SQLi"),
("10.10.20.25","GET","/search?q=%3Cscript%3Ealert(1)%3C/script%3E","403","XSS"),
("10.10.20.25","GET","/../../etc/passwd","400","Traversal"),
("10.10.20.25","POST","/login","401","AuthFailure"),
("10.10.20.25","POST","/login","401","AuthFailure"),
("10.10.20.25","POST","/login","200","AuthSuccess"),
("10.10.20.31","GET","/products?id=4","200","-"),
("10.10.20.31","GET","/products?id=5","200","-"),
("10.10.20.44","GET","/admin","404","Recon"),
("10.10.20.44","GET","/api/users","401","Recon"),
("10.10.20.44","GET","/api/users/1","200","-"),
("10.10.20.52","POST","/upload","413","UploadLimit"),
("10.10.20.52","GET","/../../windows/win.ini","400","Traversal"),
("10.10.20.52","GET","/cmd?exec=whoami","403","CommandInjection")]
rows=[{"timestamp":(base+timedelta(seconds=i*23)).strftime("%Y-%m-%dT%H:%M:%SZ"),"client_ip":a,"method":b,"uri":c,"status":d,"attack_type":e,"host":"web01"} for i,(a,b,c,d,e) in enumerate(ev)]
csvw(L3/"data/http_access_events.csv",["timestamp","client_ip","method","uri","status","attack_type","host"],rows)
(L3/"spl/http-investigation.spl").write_text('''index=splunk_lab_web sourcetype="splunk:lab:web"
| stats count as events count(eval(status>=400)) as errors values(attack_type) as attack_types by client_ip
| sort - errors - events

index=splunk_lab_web sourcetype="splunk:lab:web" attack_type!="-"
| stats count by attack_type client_ip
| sort - count

index=splunk_lab_web sourcetype="splunk:lab:web" attack_type IN ("SQLi","XSS","Traversal","CommandInjection")
| table _time client_ip method uri status attack_type
''',encoding="utf-8")
(L3/"reports/SOC-Investigation-Report.md").write_text("""# Lab 03 — Web Attack / HTTP Investigation

Investigates synthetic SQL injection, XSS, traversal, command injection, reconnaissance and authentication activity.

All events are synthetic and locally authorized.
""",encoding="utf-8")

ev=[
("DE-001","high","win-soc-01","CONTOSO\\alice","powershell.exe","powershell.exe -NoProfile -ExecutionPolicy Bypass -EncodedCommand SYNTHETIC_PAYLOAD_A","T1059.001","alert"),
("DE-002","medium","win-soc-01","CONTOSO\\bob","mshta.exe","mshta.exe https://example.invalid/update.hta","T1218.005","alert"),
("DE-003","high","win-soc-01","CONTOSO\\alice","cmd.exe","cmd.exe /c whoami && ipconfig /all","T1059.003","alert"),
("DE-004","low","win-soc-01","CONTOSO\\svc_backup","robocopy.exe","robocopy C:\\data D:\\backup /E","T1074.001","suppress"),
("DE-005","medium","win-soc-01","CONTOSO\\dave","rundll32.exe","rundll32.exe C:\\Temp\\demo.dll,EntryPoint","T1218.011","alert"),
("DE-006","low","win-soc-01","CONTOSO\\alice","notepad.exe","notepad.exe C:\\Temp\\notes.txt","T1204.002","benign")]
rows=[{"timestamp":(base+timedelta(minutes=i)).strftime("%Y-%m-%dT%H:%M:%SZ"),"rule_id":a,"severity":b,"host":c,"user":d,"process":e,"command_line":f,"technique":g,"disposition":h} for i,(a,b,c,d,e,f,g,h) in enumerate(ev)]
csvw(L4/"data/detection_test_events.csv",["timestamp","rule_id","severity","host","user","process","command_line","technique","disposition"],rows)
(L4/"spl/detection-rules.spl").write_text('''index=splunk_lab_detection sourcetype="splunk:lab:detection" disposition="alert"
| stats count values(technique) as mitre values(command_line) as commands by rule_id severity host user process
| sort - severity - count

index=splunk_lab_detection sourcetype="splunk:lab:detection"
| eval detection_family=case(match(process,"powershell"),"PowerShell",match(process,"mshta"),"LOLBIN/mshta",match(process,"rundll32"),"LOLBIN/rundll32",match(process,"cmd"),"Command Shell",1=1,"Other")
| stats count by detection_family
| sort - count
''',encoding="utf-8")
(L4/"reports/detection-validation.md").write_text("""# Lab 04 — Detection Engineering Validation

DE-001 PowerShell -> T1059.001 -> alert
DE-002 mshta -> T1218.005 -> alert
DE-003 cmd -> T1059.003 -> alert
DE-004 robocopy baseline -> suppress
DE-005 rundll32 -> T1218.011 -> alert
DE-006 notepad baseline -> benign
""",encoding="utf-8")

rows=[{"timestamp":(base+timedelta(minutes=i*2)).strftime("%Y-%m-%dT%H:%M:%SZ"),"host":"soc-monitor-01","events":12+i%5,"alerts":i%4,"critical":1 if i in (7,16) else 0,"failed_auth":i%6,"process_events":8+i%7} for i in range(24)]
csvw(L5/"data/soc_monitoring_metrics.csv",["timestamp","host","events","alerts","critical","failed_auth","process_events"],rows)
(L5/"spl/soc-monitoring.spl").write_text('''index=splunk_lab_monitoring sourcetype="splunk:lab:socmetrics"
| timechart span=5m sum(events) as events sum(alerts) as alerts sum(critical) as critical

index=splunk_lab_monitoring sourcetype="splunk:lab:socmetrics"
| stats sum(events) as total_events sum(alerts) as total_alerts sum(critical) as critical_alerts sum(failed_auth) as failed_auth sum(process_events) as process_events by host
''',encoding="utf-8")
(L5/"reports/SOC-Monitoring-Report.md").write_text("""# Lab 05 — Dashboarding and SOC Monitoring

Required views: event volume, alerts, critical alerts, failed authentication, process activity and alert-rate trend.

All measurements are synthetic.
""",encoding="utf-8")

ev=[
("email","phishing_link","medium","https://example.invalid/login","initial-access"),
("process","powershell_encoded","high","SYNTHETIC_PAYLOAD_A","execution"),
("process","mshta_execution","high","example.invalid/update.hta","execution"),
("network","outbound_connection","high","198.51.100.25:443","command-and-control"),
("auth","new_admin_group_member","critical","SYNTHETIC_ACCOUNT","persistence"),
("response","account_disabled","info","CASE-0006","containment")]
rows=[{"timestamp":(base+timedelta(minutes=i*3)).strftime("%Y-%m-%dT%H:%M:%SZ"),"host":"win-soc-02","user":"CONTOSO\\alice","source":a,"event_type":b,"severity":c,"indicator":d,"stage":e} for i,(a,b,c,d,e) in enumerate(ev)]
csvw(L6/"data/end_to_end_case_events.csv",["timestamp","host","user","source","event_type","severity","indicator","stage"],rows)
(L6/"spl/end-to-end-investigation.spl").write_text('''index=splunk_lab_case sourcetype="splunk:lab:case"
| sort 0 _time
| table _time host user source event_type severity indicator stage

index=splunk_lab_case sourcetype="splunk:lab:case"
| stats count values(stage) as stages values(indicator) as indicators by host user

index=splunk_lab_case sourcetype="splunk:lab:case" severity IN ("high","critical")
| stats count by event_type severity stage
''',encoding="utf-8")
(L6/"reports/Incident-Report.md").write_text("""# Lab 06 — End-to-End SOC Investigation

CASE-0006 is a synthetic chain covering initial access, execution, command-and-control, persistence and containment.

Analyst workflow: triage -> scope -> timeline -> containment -> evidence preservation -> remediation.
""",encoding="utf-8")

for root,num,title,index,stype,count in [
(L3,"03","Web Attack / HTTP Investigation","splunk_lab_web","splunk:lab:web",15),
(L4,"04","Detection Engineering and SPL Alert Logic","splunk_lab_detection","splunk:lab:detection",6),
(L5,"05","Dashboarding and SOC Monitoring","splunk_lab_monitoring","splunk:lab:socmetrics",24),
(L6,"06","End-to-End SOC Investigation and Incident Report","splunk_lab_case","splunk:lab:case",6)]:
    (root/"README.md").write_text(f"""# Lab {num} — {title}

Objective: evidence-backed Splunk SOC practice using synthetic telemetry.

Execution state: prepared for local execution. Do not mark complete until searches/dashboards are executed and evidence is retained.

Index: {index}
Sourcetype: {stype}
Synthetic events: {count}

Workflow:
1. Import data.
2. Execute SPL.
3. Validate expected observations.
4. Render the dashboard/investigation view.
5. Export full dashboard PNG/PDF into evidence/.
6. Review report and limitations.

All telemetry is synthetic and locally authorized.
""",encoding="utf-8")
    (root/"evidence/README.md").write_text("""# Evidence

- [ ] Searches executed in Splunk
- [ ] Dashboard/investigation rendered
- [ ] Full dashboard PNG exported
- [ ] Validation completed
- [ ] Evidence reviewed for secrets/private data
""",encoding="utf-8")

manifest={"script_version":"1.0.0","labs":[
{"lab":"03","index":"splunk_lab_web","sourcetype":"splunk:lab:web","events":15},
{"lab":"04","index":"splunk_lab_detection","sourcetype":"splunk:lab:detection","events":6},
{"lab":"05","index":"splunk_lab_monitoring","sourcetype":"splunk:lab:socmetrics","events":24},
{"lab":"06","index":"splunk_lab_case","sourcetype":"splunk:lab:case","events":6}]}
repo = Path.cwd()
(repo/"SIEM/Splunk/labs-03-06-manifest.json").write_text(
    json.dumps(manifest, indent=2) + "\n",
    encoding="utf-8"
)
PY

python3 - "$LAB3" "$LAB4" "$LAB5" "$LAB6" <<'PY'
from pathlib import Path
import csv,sys
for root in map(Path,sys.argv[1:]):
    for p in root.rglob("*.csv"):
        with p.open(encoding="utf-8",newline="") as f: assert list(csv.DictReader(f)), p
    for p in root.rglob("*.spl"):
        t=p.read_text(encoding="utf-8"); assert "index=" in t and "sourcetype=" in t, p
print("Artifact validation: PASS")
PY

if [[ "$RUN_SPLUNK" == "1" && -x "$SPLUNK_HOME/bin/splunk" && -n "$SPLUNK_PASSWORD" ]]; then
  SPLUNK_AUTH="$SPLUNK_USER:$SPLUNK_PASSWORD"

  splunk_cli() {
    "$SPLUNK_HOME/bin/splunk" "$@" -auth "$SPLUNK_AUTH"
  }

  search_count() {
    local index="$1" sourcetype="$2"
    splunk_cli search "search index=$index sourcetype=\"$sourcetype\" | stats count AS event_count" \
      -earliest -15m -output csv 2>/dev/null \
      | awk -F',' 'NR==2 {gsub(/"/,"",$1); print $1}'
  }

  wait_for_splunk() {
    local i
    for i in {1..30}; do
      if splunk_cli status >/dev/null 2>&1; then return 0; fi
      sleep 2
    done
    return 1
  }

  ensure_index() {
    local index="$1"
    splunk_cli add index "$index" >/dev/null 2>&1 || true
  }

  repair_index_storage() {
    local index="$1"
    local db_root="$SPLUNK_HOME/var/lib/splunk"
    local path="$db_root/$index"
    local stamp backup

    if [[ ! -d "$path" ]]; then
      log "Index storage $path does not exist; no filesystem repair required."
      return 0
    fi

    stamp="$(date '+%Y%m%d-%H%M%S')"
    backup="$db_root/$index.backup-$stamp"

    log "Backing up broken index storage: $path -> $backup"
    "$SPLUNK_HOME/bin/splunk" stop >/dev/null 2>&1 || true
    sleep 3
    sudo mv "$path" "$backup"
    sudo chown -R splunk:splunk "$backup"
    sudo -u splunk "$SPLUNK_HOME/bin/splunk" start >/dev/null 2>&1
    wait_for_splunk || { log "ERROR: Splunk did not return after index repair."; return 1; }
    sleep 5
    log "Index storage recreated from indexes.conf: $index"
  }

  probe_index() {
    local index="$1" sourcetype="$2" token="$3"
    local probe_dir="/tmp/splunk-lab-probe-$index"
    local probe_file="$probe_dir/probe-$token.txt"
    mkdir -p "$probe_dir"
    printf '%s\n' "SPLUNK_LAB_PROBE token=$token" | sudo tee "$probe_file" >/dev/null
    sudo chown splunk:splunk "$probe_file"
    sudo chmod 644 "$probe_file"

    splunk_cli add oneshot "$probe_file" \
      -index "$index" \
      -sourcetype "$sourcetype" \
      -rename-source "$probe_file" >/dev/null 2>&1 || true

    for _ in {1..15}; do
      if splunk_cli search "search index=$index sourcetype=\"$sourcetype\" \"SPLUNK_LAB_PROBE\" token=$token | stats count AS event_count" \
          -earliest -5m -output csv 2>/dev/null | awk -F',' 'NR==2 {gsub(/"/,"",$1); if ($1+0 >= 1) found=1} END {exit(found?0:1)}'; then
        rm -rf "$probe_dir"
        return 0
      fi
      sleep 2
    done

    rm -rf "$probe_dir"
    return 1
  }

  ensure_index splunk_lab_web
  ensure_index splunk_lab_detection
  ensure_index splunk_lab_monitoring
  ensure_index splunk_lab_case

  log "Running Splunk ingestion preflight."

  if ! probe_index splunk_lab_web splunk:lab:web "$(date +%s)-web"; then
    log "WARNING: splunk_lab_web failed ingestion preflight."
    log "Repairing only the synthetic Splunk lab index storage."
    repair_index_storage splunk_lab_web
    ensure_index splunk_lab_web
    if ! probe_index splunk_lab_web splunk:lab:web "$(date +%s)-web-repaired"; then
      log "ERROR: splunk_lab_web still fails ingestion after repair."
      exit 1
    fi
    log "splunk_lab_web ingestion preflight: PASS after repair."
  else
    log "splunk_lab_web ingestion preflight: PASS."
  fi

  log "Importing synthetic datasets into local Splunk."

  ingest_csv_rows() {
    local csv_file="$1" index="$2" sourcetype="$3" expected="$4" lab_tag="$5"
    local stage="/tmp/splunk-lab-$lab_tag-rows"
    rm -rf "$stage"
    mkdir -p "$stage"

    python3 - "$csv_file" "$stage" <<'PY'
import csv, pathlib, sys
src, out = map(pathlib.Path, sys.argv[1:])
with src.open(encoding="utf-8", newline="") as f:
    rows = list(csv.reader(f))
if len(rows) < 2:
    raise SystemExit(f"CSV has no data rows: {src}")
for i, row in enumerate(rows[1:], 1):
    (out / f"event-{i:03d}.txt").write_text(",".join(row) + "\n", encoding="utf-8")
print(len(rows)-1)
PY

    local submitted=0
    local file
    while IFS= read -r -d '' file; do
      sudo chown splunk:splunk "$file"
      sudo chmod 644 "$file"
      splunk_cli add oneshot "$file" \
        -index "$index" \
        -sourcetype "$sourcetype" \
        -rename-source "$file" >/dev/null 2>&1
      submitted=$((submitted + 1))
    done < <(find "$stage" -type f -name 'event-*.txt' -print0 | sort -z)

    [[ "$submitted" -eq "$expected" ]] || {
      log "ERROR: $lab_tag submitted $submitted rows; expected $expected."
      return 1
    }

    local found=0
    for _ in {1..20}; do
      found="$(search_count "$index" "$sourcetype" || echo 0)"
      [[ "$found" =~ ^[0-9]+$ ]] || found=0
      if (( found == expected )); then
        log "$lab_tag ingestion validation: PASS ($found/$expected events)"
        rm -rf "$stage"
        return 0
      fi
      sleep 2
    done

    log "ERROR: $lab_tag ingestion validation failed: expected $expected, found $found."
    rm -rf "$stage"
    return 1
  }

  ingest_csv_rows "$LAB3/data/http_access_events.csv" splunk_lab_web splunk:lab:web 15 lab03
  ingest_csv_rows "$LAB4/data/detection_test_events.csv" splunk_lab_detection splunk:lab:detection 6 lab04
  ingest_csv_rows "$LAB5/data/soc_monitoring_metrics.csv" splunk_lab_monitoring splunk:lab:socmetrics 24 lab05
  ingest_csv_rows "$LAB6/data/end_to_end_case_events.csv" splunk_lab_case splunk:lab:case 6 lab06

  log "All Splunk ingestion validations: PASS."
else
  log "Splunk import skipped. Export SPLUNK_PASSWORD before running the script."
fi

printf '\n============================================================\n'
printf 'Splunk SOC Labs 03-06 master build complete\n'
printf '============================================================\n'
printf 'Lab 03: 15 synthetic HTTP events\n'
printf 'Lab 04: 6 synthetic detection events\n'
printf 'Lab 05: 24 synthetic monitoring events\n'
printf 'Lab 06: 6 synthetic case events\n'
printf 'Next: execute and export dashboard evidence for each lab.\n'
