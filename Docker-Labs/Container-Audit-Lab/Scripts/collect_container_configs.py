#!/usr/bin/env python3
"""Collects real running-container configuration via `docker inspect`,
transformed into the JSON schema container_config_auditor.py expects.

Env var VALUES are never written to the output - only key names, with
every value replaced by a fixed, non-placeholder sentinel. The auditor
only uses env values to tell "a real value is set" apart from a known
placeholder (empty/changeme/redacted/example/...); it never needs the
actual value for anything, so a real secret's value is never collected,
let alone written to disk or committed.

Usage: python3 collect_container_configs.py > containers.json
"""
import json
import subprocess
import sys

# Deliberately not in container_config_auditor.py's PLACEHOLDER_VALUES set
# (which includes the bare word "redacted") - this must look like a real,
# present value to the auditor's secret-detection logic, while never being
# the actual secret.
REDACTED_ENV_VALUE = "<value-not-collected>"


def get_running_container_ids():
    out = subprocess.run(
        ["docker", "ps", "-q"], capture_output=True, text=True, check=True
    ).stdout.strip()
    return out.splitlines() if out else []


def inspect(container_ids):
    if not container_ids:
        return []
    out = subprocess.run(
        ["docker", "inspect", *container_ids], capture_output=True, text=True, check=True
    ).stdout
    return json.loads(out)


def env_list_to_dict(env_list):
    result = {}
    for entry in env_list or []:
        if "=" in entry:
            key, _, value = entry.partition("=")
            result[key] = REDACTED_ENV_VALUE if value else ""
    return result


def collect_volumes(raw):
    volumes = list(raw.get("HostConfig", {}).get("Binds") or [])
    for mount in raw.get("Mounts", []) or []:
        source = mount.get("Source")
        destination = mount.get("Destination")
        if source and destination:
            entry = f"{source}:{destination}"
            if entry not in volumes:
                volumes.append(entry)
    return volumes


def transform(raw):
    name = raw.get("Name", "unknown").lstrip("/")
    config = raw.get("Config", {})
    host_config = raw.get("HostConfig", {})
    return {
        "name": name,
        "image": config.get("Image", ""),
        "user": config.get("User", ""),
        "env": env_list_to_dict(config.get("Env")),
        "privileged": bool(host_config.get("Privileged")),
        "volumes": collect_volumes(raw),
        "network_mode": host_config.get("NetworkMode", ""),
    }


def main():
    container_ids = get_running_container_ids()
    if not container_ids:
        print("[]")
        return
    raw_containers = inspect(container_ids)
    containers = [transform(c) for c in raw_containers]
    print(json.dumps(containers, indent=2))


if __name__ == "__main__":
    main()
