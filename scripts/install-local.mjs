import { cpSync, mkdirSync, chmodSync } from 'node:fs';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import path from 'node:path';
import os from 'node:os';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(__dirname, '..');
const sourceRuntime = path.join(root, 'runtime');
const installRoot = path.join(os.homedir(), '.local', 'share', 'claude-wsl-bridge');
const installScript = path.join(installRoot, 'install.sh');

mkdirSync(path.dirname(installRoot), { recursive: true });
cpSync(sourceRuntime, installRoot, { recursive: true });
chmodSync(path.join(installRoot, 'claude-wsl'), 0o755);
chmodSync(path.join(installRoot, 'doctor.sh'), 0o755);
chmodSync(path.join(installRoot, 'install.sh'), 0o755);
chmodSync(path.join(installRoot, 'pack.sh'), 0o755);
chmodSync(path.join(installRoot, 'xclip'), 0o755);
chmodSync(path.join(installRoot, 'wl-paste'), 0o755);

const result = spawnSync(installScript, { stdio: 'inherit' });
if (result.status !== 0) {
  process.exit(result.status ?? 1);
}

console.log(`Installed claude-wsl-bridge runtime into ${installRoot}`);
