import { readFileSync } from 'node:fs';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(__dirname, '..');
const pkg = JSON.parse(readFileSync(path.join(root, 'package.json')));
const versionFile = readFileSync(path.join(root, 'runtime', 'VERSION'), 'utf8').trim();

console.log(`package ${pkg.name}@${pkg.version} OK`);
console.log(`runtime version: ${versionFile}`);

if (!versionFile.includes(pkg.version)) {
  console.error(`version mismatch: package.json=${pkg.version}, runtime=${versionFile}`);
  process.exit(1);
}

for (const script of ['bin/ccw.js', 'bin/ccw-doctor.js', 'bin/ccw-pack.js']) {
  const fullPath = path.join(root, script);
  const result = spawnSync('node', [fullPath, '--help'], { stdio: 'pipe', encoding: 'utf-8' });
  console.log(`${script}: exit=${result.status ?? 0}`);
  if (result.status !== 0) {
    process.stderr.write(result.stderr ?? '');
    process.exit(result.status ?? 1);
  }
}
