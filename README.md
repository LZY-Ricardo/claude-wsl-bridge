# claude-wsl-bridge

WSL 下为 Claude Code 提供 Windows 剪贴板图片桥接的独立项目。

## 适用范围

- 运行环境：WSL / Linux
- 宿主环境：Windows
- 目标工具：`Claude Code`
- 典型场景：在 WSL 中启动 `Claude Code`，通过 Windows 剪贴板桥接实现图片粘贴

## 当前状态

- 已从用户级安装目录迁移运行时脚本到 `runtime/`
- 已保留用户当前稳定可用的 Bash / PowerShell 方案
- `bin/` 入口现在直接调用项目内 `runtime/`，源码目录可独立校验
- 当前项目目标是把现有可用工具逐步整理成适合 npm 发布的工程结构

## 目录结构

- `runtime/`: 当前稳定运行的 Bash / PowerShell 脚本
- `bin/`: npm `bin` 入口的 Node 包装器
- `docs/`: 项目文档和教程
- `scripts/`: 开发辅助脚本
- `src/`: 后续如需迁移到 Node 实现时的源码目录

## 常用开发命令

```bash
npm run check
npm run install:local
npm run pack
npm pack --dry-run
node ./bin/ccw.js --help
node ./bin/ccw-doctor.js
node ./bin/ccw-pack.js /tmp/claude-wsl-bridge-dev.tar.gz
```

## 安装方式

### 本地开发安装

```bash
npm run install:local
```

### 未来 npm 全局安装目标

```bash
npm install -g claude-wsl-bridge
```

安装后预期提供的命令：

- `ccw`
- `claude-wsl`
- `ccw-doctor`
- `ccw-pack`

## 运行前提

以下依赖不由本包自动提供：

- `claude`
- `powershell.exe`
- `wslpath`
- 终端里的图片粘贴快捷键映射

如果缺少其中任何一项，CLI 能安装成功，但桥接能力不会完整可用。

## 发布准备

- 发布说明见 `docs/PUBLISHING.md`
- 当前 npm 包已具备以下命令入口：
  - `ccw`
  - `claude-wsl`
  - `ccw-doctor`
  - `ccw-pack`
- 当前尚未执行真正的 `npm publish`，但已经完成项目内校验和 `npm pack --dry-run`
- 当前许可证为 `MIT`
- 当前已去掉 `private: true`，包已进入可发布状态

## 下一阶段

1. 打磨 `install:local`，把项目内 `runtime/` 同步到用户目录
2. 设计 `npm pack` / `npm publish` 发布路径
3. 评估是否增加 `npm link` / `postinstall` 支持
