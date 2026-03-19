# Roadmap

## Done

- 独立项目目录已创建
- 用户级稳定脚本已迁移到 `runtime/`
- npm bin 入口已从占位符升级为 Node 包装器
- 项目 `runtime/` 已去除对 `~/.local/share/claude-wsl-bridge` 的硬编码依赖
- `npm pack --dry-run` 已通过，打包内容已收敛
- `npm link` 冒烟测试已通过
- npm 包名 `claude-wsl-bridge` 当前可用

## Next

- 明确许可证并补充 LICENSE
- 去掉 `private: true` 进入可发布状态
- 执行首次 `npm publish`
