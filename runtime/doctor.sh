#!/usr/bin/env bash

set -euo pipefail

script_dir="${CLAUDE_WSL_BRIDGE_DIR:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)}"
source "${script_dir}/bridge-common.sh"

case "${1:-}" in
  --help|-h)
    cat <<'HELP'
Usage:
  ccw-doctor
  ccw --doctor
  ccw-doctor --version

Commands:
  --help      Show help
  --version   Show bridge version
HELP
    exit 0
    ;;
  --version|-V)
    bridge_version
    exit 0
    ;;
esac

status_ok=0
status_warn=0
status_fail=0

print_line() {
  printf '%s\n' "${1-}"
}

mark_ok() {
  status_ok=$((status_ok + 1))
  print_line "[OK] $1"
}

mark_warn() {
  status_warn=$((status_warn + 1))
  print_line "[WARN] $1"
}

mark_fail() {
  status_fail=$((status_fail + 1))
  print_line "[FAIL] $1"
}

print_line "Claude WSL Bridge Doctor"
print_line "Version: $(bridge_version)"
print_line "Install root: ${script_dir}"
print_line

if [[ -n "${WSL_DISTRO_NAME:-}" ]]; then
  mark_ok "检测到 WSL 发行版: ${WSL_DISTRO_NAME}"
else
  mark_warn "当前环境看起来不像 WSL，桥接脚本主要为 WSL 设计"
fi

for path in \
  "${script_dir}/claude-wsl" \
  "${script_dir}/bridge-common.sh" \
  "${script_dir}/xclip" \
  "${script_dir}/wl-paste" \
  "${script_dir}/win-clipboard-bridge.ps1"; do
  if [[ -f "${path}" ]]; then
    mark_ok "存在文件: ${path}"
  else
    mark_fail "缺少文件: ${path}"
  fi
done

if command -v claude >/dev/null 2>&1; then
  mark_ok "找到 Claude Code: $(command -v claude)"
else
  mark_fail "未找到 claude 命令"
fi

if command -v powershell.exe >/dev/null 2>&1; then
  mark_ok "找到 powershell.exe: $(command -v powershell.exe)"
else
  mark_fail "未找到 powershell.exe"
fi

if command -v wslpath >/dev/null 2>&1; then
  mark_ok "找到 wslpath: $(command -v wslpath)"
else
  mark_warn "未找到 wslpath，Windows 路径转换会退化"
fi

if [[ -n "${CLAUDE_WSL_REAL_XCLIP:-}" ]]; then
  mark_ok "原始 xclip 已固定: ${CLAUDE_WSL_REAL_XCLIP}"
elif command -v xclip >/dev/null 2>&1; then
  mark_ok "系统 xclip 可用: $(command -v xclip)"
else
  mark_warn "未找到系统 xclip，Linux 原生回退路径不可用"
fi

if [[ -n "${CLAUDE_WSL_REAL_WL_PASTE:-}" ]]; then
  mark_ok "原始 wl-paste 已固定: ${CLAUDE_WSL_REAL_WL_PASTE}"
elif command -v wl-paste >/dev/null 2>&1; then
  mark_ok "系统 wl-paste 可用: $(command -v wl-paste)"
else
  mark_warn "未找到系统 wl-paste，Wayland 原生回退路径不可用"
fi

if bridge_available; then
  mark_ok "bridge_available 检查通过"
else
  mark_fail "bridge_available 检查失败"
fi

if output="$(run_windows_bridge Ping 2>/dev/null)" && [[ "${output}" == "ok" ]]; then
  mark_ok "Windows PowerShell 桥接脚本可执行"
else
  mark_fail "Windows PowerShell 桥接脚本执行失败"
fi

if targets="$(emit_targets_from_bridge 2>/dev/null)"; then
  mark_ok "当前剪贴板包含图片，可报告类型: $(printf '%s' "${targets}" | paste -sd ',' -)"
else
  mark_warn "当前剪贴板没有可桥接的图片；截图后再试一次可进一步验证"
fi

print_line
print_line "Summary: ok=${status_ok} warn=${status_warn} fail=${status_fail}"

if [[ "${status_fail}" -gt 0 ]]; then
  exit 1
fi
