#!/usr/bin/env bash

set -euo pipefail

bridge_dir="${CLAUDE_WSL_BRIDGE_DIR:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)}"
ps_script_path="${bridge_dir}/win-clipboard-bridge.ps1"
version_file="${bridge_dir}/VERSION"

if [[ ! -f "${version_file}" && -f "${bridge_dir}/../docs/VERSION" ]]; then
  version_file="${bridge_dir}/../docs/VERSION"
fi

bridge_version() {
  if [[ -f "${version_file}" ]]; then
    head -n 1 "${version_file}"
    return 0
  fi

  printf 'claude-wsl-bridge unknown\n'
}

get_ps_script_win_path() {
  wslpath -w "${ps_script_path}" 2>/dev/null || printf '%s\n' "${ps_script_path}"
}

run_windows_bridge() {
  local action="$1"
  local ps_script_win

  ps_script_win="$(get_ps_script_win_path)"
  powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -File "${ps_script_win}" -Action "${action}" 2>/dev/null | tr -d '\r'
}

bridge_available() {
  command -v powershell.exe >/dev/null 2>&1 && [[ -f "${ps_script_path}" ]]
}

windows_to_wsl_path_if_needed() {
  local input="$1"

  if [[ "${input}" =~ ^[A-Za-z]:\\ ]] || [[ "${input}" =~ ^\\\\wsl(\.localhost|\$)\\ ]]; then
    wslpath -u "${input}" 2>/dev/null || printf '%s\n' "${input}"
    return 0
  fi

  printf '%s\n' "${input}"
}

emit_targets_from_bridge() {
  if run_windows_bridge HasImage >/dev/null; then
    printf 'image/png\nimage/bmp\ntext/plain\n'
    return 0
  fi

  return 1
}

emit_png_bytes_from_bridge() {
  local encoded

  encoded="$(run_windows_bridge DumpPngBase64)" || return 1
  [[ -n "${encoded}" ]] || return 1
  printf '%s' "${encoded}" | base64 -d
}

emit_text_from_bridge() {
  local text

  text="$(run_windows_bridge GetText)" || return 1
  [[ -n "${text}" ]] || return 1
  windows_to_wsl_path_if_needed "${text}"
}
