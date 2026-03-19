# Publishing Guide

## 目标

把 `claude-wsl-bridge` 从当前的本地可用项目，推进到可通过 npm 安装的 CLI。

## 当前状态

已完成：

- 项目内 `bin/` 到 `runtime/` 的调用链校验
- `npm pack --dry-run` 校验
- `npm link` 冒烟测试
- npm 包名可用性确认
- npm 包 `claude-wsl-bridge@0.3.0` 已首次发布
- 关键命令名收敛：
  - `ccw`
  - `claude-wsl`
  - `ccw-doctor`
  - `ccw-pack`

尚未完成：

- 配置 npm Trusted Publisher
- 验证 GitHub Actions 自动发布链路

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

## 手动发布路径（已验证）

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

## 自动发布工作流

项目已新增：

- `.github/workflows/publish.yml`

设计目标：

- 仅在推送 `v*` tag 时触发
- 先校验 tag 与 `package.json` 版本一致
- 运行 `npm run check`
- 运行 `npm pack --dry-run`
- 使用 npm Trusted Publishing 发布到 npm
- 自动创建对应的 GitHub Release

### 为什么用 Trusted Publishing

按 npm 官方文档，GitHub Actions 可以通过 OIDC 做 trusted publishing。这样不需要长期有效的 `NPM_TOKEN`，风险更低，且在公共仓库/公共包场景下会自动生成 provenance。

### 你还需要做的仓库外配置

在 npm 包页面为 `claude-wsl-bridge` 配置 Trusted Publisher：

1. 打开 npm 包设置
2. 找到 `Trusted Publisher`
3. 选择 `GitHub Actions`
4. 填写：
   - GitHub user/org: `LZY-Ricardo`
   - Repository: `claude-wsl-bridge`
   - Workflow filename: `publish.yml`

注意：

- workflow filename 必须和 `.github/workflows/publish.yml` 精确一致
- 大小写必须完全匹配
- Trusted publishing 只对 `npm publish` 生效，不影响 `npm view` / `npm access`

### 触发方式

以后发布新版本时，推荐流程：

1. 更新 `package.json` 版本
2. 提交并推送 `main`
3. 创建对应 tag，例如：

```bash
git tag -a v0.3.1 -m "v0.3.1"
git push origin v0.3.1
```

4. GitHub Actions 自动完成：
   - 检查
   - npm 发布
   - GitHub Release

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

1. 在 npm 包设置中配置 Trusted Publisher
2. 推送包含 `.github/workflows/publish.yml` 的变更到 GitHub
3. 使用新版本 tag 验证自动发布链路
