#!/usr/bin/env bash
set -euo pipefail
install_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
bin_root="$HOME/.local/bin"
mkdir -p "$bin_root"
cat > "$bin_root/claude-wsl" <<WRAP
#!/usr/bin/env bash
exec "$install_root/claude-wsl" "\$@"
WRAP
cat > "$bin_root/ccw" <<WRAP
#!/usr/bin/env bash
exec "$install_root/claude-wsl" "\$@"
WRAP
cat > "$bin_root/ccw-doctor" <<WRAP
#!/usr/bin/env bash
exec "$install_root/doctor.sh" "\$@"
WRAP
cat > "$bin_root/ccw-pack" <<WRAP
#!/usr/bin/env bash
exec "$install_root/pack.sh" "\$@"
WRAP
chmod 755 "$bin_root/claude-wsl" "$bin_root/ccw" "$bin_root/ccw-doctor" "$bin_root/ccw-pack"
printf 'Installed wrappers into %s\n' "$bin_root"
