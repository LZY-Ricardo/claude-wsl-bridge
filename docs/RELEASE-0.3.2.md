# Release 0.3.2

## 概览

`0.3.2` 用于验证修复后的自动发布链路。

## 变更内容

- 修复自动发布 workflow 的运行时配置
- 将自动发布 workflow 的 Node 版本提升到 `24`
- 增加运行时版本输出，便于排查 GitHub Actions 中的 npm / Node 环境
- 更新自动发布说明文档

## 目标

验证以下链路是否正常工作：

1. 推送 `v0.3.2` tag
2. GitHub Actions 触发 `publish.yml`
3. npm Trusted Publishing 成功发布 `claude-wsl-bridge@0.3.2`
4. GitHub Release 自动创建

## 说明

- 本版本是自动发布验证版
- 如果 `0.3.2` 成功自动发布，说明后续版本可以继续沿用当前工作流
