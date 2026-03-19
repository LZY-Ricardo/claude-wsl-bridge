# Claude WSL Clipboard Bridge Tutorial

## 1. 这套工具解决什么问题

`Claude Code` 在 WSL 下默认只会通过 Linux 侧的 `xclip` / `wl-paste` 读取剪贴板。
这会导致：

- Windows 原生剪贴板图片在 WSL 中经常读不到
- `PixPin` 截图可能只会粘贴出 Windows 文件路径
- `Win + Shift + S` 的截图在 WSL 中可能完全无法被识别为图片

这套桥接工具的作用，就是把 `Claude Code` 在 WSL 中的图片读取，转发到 Windows 原生剪贴板，再把图片结果回送给 Claude。

## 2. 前置条件

建议新电脑至少满足以下条件：

- 已安装 WSL
- 已安装 `Claude Code`，并且 `claude` 命令可用
- WSL 中可以调用 `powershell.exe`
- WSL 中有 `wslpath`
- 最好安装：
  - `xclip`
  - `wl-paste`

## 3. 日常使用

启动 Claude：

```bash
ccw
```

查看帮助：

```bash
ccw --help
```

查看版本：

```bash
ccw --version
```

自检环境：

```bash
ccw-doctor
```

打包迁移：

```bash
ccw-pack
```

## 4. 图片粘贴使用方式

进入通过 `ccw` 启动的 `Claude Code` 后，使用你配置好的图片粘贴快捷键，例如：

- `Alt + V`

如果你的终端已经做了快捷键分离，那么通常可以实现：

- `Ctrl + V` 粘贴文本
- `Alt + V` 粘贴图片

## 5. 常见截图来源

### PixPin

如果你已经开启了“复制图像为文件”等兼容选项，那么通常可以直接通过桥接层把图片送给 Claude。

### Win + Shift + S

这是 Windows 原生截图，桥接层会优先尝试把原始剪贴板图片转成 PNG 再交给 Claude。

## 6. 排障

### 先跑自检

```bash
ccw-doctor
```

重点关注：

- `找到 Claude Code`
- `找到 powershell.exe`
- `找到 wslpath`
- `bridge_available 检查通过`
- `Windows PowerShell 桥接脚本可执行`

### 如果 doctor 报桥接失败

优先检查：

```bash
powershell.exe -NoProfile -Command "Write-Output hello"
```

如果这条都失败，说明问题不在桥接脚本，而在你的 WSL 到 Windows PowerShell 调用链。

### 如果能启动但图片仍贴不进 Claude

按这个顺序排查：

1. 确认你是用 `ccw` 启动的 Claude，而不是裸 `claude`
2. 确认终端快捷键确实把图片粘贴动作发给了 Claude
3. 截一张新图后再跑一次：

```bash
ccw-doctor
```

## 7. 迁移到新电脑

### 旧电脑上打包

```bash
ccw-pack
```

默认会在当前目录生成一个类似这样的文件：

```text
claude-wsl-bridge-0.3.0-20260319-120000.tar.gz
```

### 新电脑上安装

1. 把压缩包复制到新电脑的 WSL
2. 解压到用户目录：

```bash
mkdir -p "$HOME/.local/share"
tar -C "$HOME/.local/share" -xzf claude-wsl-bridge-*.tar.gz
```

3. 执行安装脚本：

```bash
~/.local/share/claude-wsl-bridge/install.sh
```

4. 自检：

```bash
ccw-doctor
```

5. 启动 Claude：

```bash
ccw
```

## 8. 升级

如果你后续修改了桥接脚本，建议：

1. 更新 `VERSION`
2. 重新运行：

```bash
~/.local/share/claude-wsl-bridge/install.sh
```

3. 再执行：

```bash
ccw-doctor
```

## 9. 卸载

删除用户级安装目录和命令包装器：

```bash
rm -rf "$HOME/.local/share/claude-wsl-bridge"
rm -f "$HOME/.local/bin/ccw" "$HOME/.local/bin/claude-wsl" "$HOME/.local/bin/ccw-doctor" "$HOME/.local/bin/ccw-pack"
```

## 10. 关于 npm 发布

从“跨电脑安装便捷性”角度，做成 npm 包确实更方便，因为可以做到：

```bash
npm install -g xxx
```

但当前这套工具强依赖：

- WSL
- Windows `powershell.exe`
- 本机 `Claude Code`
- 用户本地终端快捷键配置

所以它更像一个“环境敏感型本地工具”，而不是纯 Node CLI。

### 我建议的顺序

1. 先把当前本地版长期稳定使用
2. 等脚本接口稳定后，再考虑 npm 化
3. 如果以后要发 npm，推荐让 npm 包只负责：
   - 安装脚本
   - 复制桥接文件
   - 创建 `ccw` / `ccw-doctor` / `ccw-pack`

而不是把所有逻辑都强塞进 Node 里重写
