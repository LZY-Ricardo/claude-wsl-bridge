# Release 0.3.0

## 概览

`claude-wsl-bridge` 首次发布到 npm。

这个版本用于解决以下问题：

- 在 WSL 中运行 `Claude Code` 时，无法稳定读取 Windows 剪贴板图片
- `PixPin` 与 `Win + Shift + S` 的截图，在 WSL 环境下体验不一致
- 需要一个可诊断、可迁移、可安装的本地桥接工具

## 已发布包

- npm: `claude-wsl-bridge`
- version: `0.3.0`

## 核心能力

- 在 WSL 中为 `Claude Code` 提供 Windows 剪贴板图片桥接
- 支持通过 `ccw` / `claude-wsl` 启动桥接后的 Claude Code
- 提供诊断命令 `ccw-doctor`
- 提供迁移打包命令 `ccw-pack`
- 提供本地安装命令 `npm run install:local`

## 命令入口

安装后可用：

- `ccw`
- `claude-wsl`
- `ccw-doctor`
- `ccw-pack`

## 运行前提

需要以下环境条件：

- WSL / Linux
- Windows 宿主机
- `claude`
- `powershell.exe`
- `wslpath`
- 已配置好的终端图片粘贴快捷键

## 验证结果

当前版本已完成以下验证：

- `npm run check`
- `npm pack --dry-run`
- `npm link`
- 本地用户目录安装覆盖验证
- `ccw-doctor` 真实环境验证
- `Alt + V` 图片粘贴验证
- npm 发布后 `version` / `bin` / `repository` / `homepage` 校验

## 已知限制

- 这是一个环境敏感型工具，不是纯 Node CLI
- 即使 npm 安装成功，也仍然依赖本机 WSL / Windows / npm / Claude Code 环境
- 图片粘贴体验仍依赖终端快捷键映射是否正确

## 后续方向

- 持续打磨安装与升级路径
- 评估是否增加更自动化的发布流程
- 根据实际使用反馈继续收敛诊断与兼容性逻辑
