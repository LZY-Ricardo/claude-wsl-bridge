# Publishing Guide

## 目标

把 `claude-wsl-bridge` 从当前的本地可用项目，推进到可通过 npm 安装的 CLI。

## 当前状态

已完成：

- 项目内 `bin/` 到 `runtime/` 的调用链校验
- `npm pack --dry-run` 校验
- `npm link` 冒烟测试
- npm 包名可用性确认
- 关键命令名收敛：
  - `ccw`
  - `claude-wsl`
  - `ccw-doctor`
  - `ccw-pack`

尚未完成：

- 首次 `npm publish` 实际发布

## 本地发布前检查

在项目目录执行：

```bash
npm run check
npm run pack
npm pack --dry-run
```

建议补做：

```bash
npm pack
```

然后在一个干净的 WSL shell 中测试打出来的包是否能正确提供命令入口。

## 建议的首次发布路径

1. 确认版本号  
   当前版本：
   - `package.json`: `0.3.0`
   - `runtime/VERSION`: `0.3.0`

2. 登录 npm

```bash
npm login
```

3. 发布

```bash
npm publish
```

如果后续使用 scope 包名，再根据需要补 `--access public`。

## 发布后的验证

建议在另一台机器或新的 WSL 环境中验证：

```bash
npm install -g claude-wsl-bridge
ccw --help
ccw-doctor
```

然后再做一次真实图片粘贴验证。

## 风险点

- 这是 WSL + Windows PowerShell + Claude Code 的环境敏感工具，不是纯 Node CLI
- npm 包即使安装成功，也仍然依赖：
  - `claude`
  - `powershell.exe`
  - `wslpath`
  - 终端快捷键映射
- 首次发布前，最好先完成一次 `npm link` 或本地 tarball 安装测试

## 后续建议

优先顺序建议如下：

1. 执行一次 `install:local` 覆盖现有用户安装，确认项目源码就是唯一维护入口
2. 再决定是否正式发布
