#!/bin/bash
set -euo pipefail

IPS_DIR="ips"

TARGET_IP=""
for ip_path in "$IPS_DIR"/*; do
  ip=$(basename "$ip_path")
  pid_file="$ip_path/pid"

  if [ ! -f "$pid_file" ]; then
    TARGET_IP="$ip"
    break
  fi

  pid=$(cat "$pid_file" 2>/dev/null || echo "")
  if [ -z "$pid" ] || ! kill -0 "$pid" 2>/dev/null; then
    TARGET_IP="$ip"
    break
  fi
done

if [ -z "$TARGET_IP" ]; then
  echo "No available IP"
  exit 1
fi

pid_file="$IPS_DIR/$TARGET_IP/pid"

mkdir -p "$IPS_DIR/$TARGET_IP"
echo $$ > $pid_file
echo "Selected: $TARGET_IP"

env BIND_IP="$TARGET_IP" "${SHELL:-/bin/bash}"

pid_file=$pid_file
if [ -f "$pid_file" ] && [ "$(cat "$pid_file")" = "$$" ]; then
  rm -f "$pid_file"
  echo "Released: $TARGET_IP"
fi
