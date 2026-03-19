#!/usr/bin/env bash
set -euo pipefail
install_root="${CLAUDE_WSL_BRIDGE_DIR:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)}"

case "${1:-}" in
  --help|-h)
    cat <<'HELP'
Usage:
  ccw-pack [output.tar.gz]
  ccw-pack --version

Commands:
  --help      Show help
  --version   Show bridge version
HELP
    exit 0
    ;;
  --version|-V)
    head -n 1 "${install_root}/VERSION" 2>/dev/null || printf 'claude-wsl-bridge unknown\n'
    exit 0
    ;;
esac

version="$(head -n 1 "$install_root/VERSION" 2>/dev/null | awk '{print $2}' || echo unknown)"
timestamp="$(date +%Y%m%d-%H%M%S)"
default_name="claude-wsl-bridge-${version}-${timestamp}.tar.gz"
output_path="${1:-$PWD/$default_name}"
output_dir="$(dirname "$output_path")"
mkdir -p "$output_dir"
tar -C "$(dirname "$install_root")" -czf "$output_path" "$(basename "$install_root")"
printf 'Created package: %s\n' "$output_path"
