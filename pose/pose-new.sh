#!/bin/bash
set -euo pipefail

ips_dir="ips"

iface="eth0"

addr=$(ip -4 addr show dev "$iface" | grep -oP 'inet \K[\d\./]+' | head -n1)

if [[ -z "$addr" || ! $addr =~ /24 ]]; then
  echo "IP addr is either empty or not in /24 subnet: $addr"
  exit 1
fi

base="${addr%.*}"

# look from 200 to 254
for i in {200..254}; do
  new_ip="$base.$i"

  # check if IP is already assigned
  if ip addr show dev "$iface" | grep -q "$new_ip"; then
    continue
  fi

  # check if ips/$new_ip/pid alive
  pid_file="$ips_dir/$new_ip/pid"
  if [ -f "$pid_file" ]; then
    pid=$(cat "$pid_file" 2>/dev/null || echo "")
    if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
      continue
    fi
  fi

  break
done

if [[ -z "$new_ip" ]]; then
  echo "No available IP"
  exit 1
fi

echo "Assigning $new_ip to $iface"

sudo ip addr add "$new_ip/24" dev "$iface"

echo "Added $new_ip/24 to $iface"

mkdir -p "$ips_dir/$new_ip"
