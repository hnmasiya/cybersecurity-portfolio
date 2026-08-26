#!/usr/bin/env python3
"""Collects real running-container configuration via `docker inspect`,
transformed into the JSON schema container_config_auditor.py expects.

Only reads container metadata (image, user, env var *names*, privileged
flag, mounts, network mode) - the auditor's own findings only ever
reference env var key names, never values, so no secret material from
env vars is written to the output.

Usage: python3 collect_container_configs.py > containers.json
"""
import json
import subprocess
import sys


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
            result[key] = value
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
