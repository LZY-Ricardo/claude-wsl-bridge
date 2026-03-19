# Release 0.3.1

## 概览

`0.3.1` 是在 `0.3.0` 首次发布后的补充版本，目标是把仓库配套和自动发布链路补齐。

## 变更内容

- 增加 `.gitignore`
- 增加基础 GitHub Actions CI
- 增加基于 tag 的自动发布 workflow
- 补充 Trusted Publisher 配置说明

## 自动发布目标

从这个版本开始，项目准备支持以下发布路径：

1. 更新 `package.json` 版本
2. 推送 `main`
3. 推送 `v*` tag
4. 由 GitHub Actions 自动完成：
   - `npm run check`
   - `npm pack --dry-run`
   - `npm publish`
   - GitHub Release 创建

## 说明

- 自动发布依赖 npm Trusted Publisher 正确配置
- 自动发布 workflow 文件为 `.github/workflows/publish.yml`
- Trusted Publisher 配置说明见 `docs/PUBLISHING.md`
