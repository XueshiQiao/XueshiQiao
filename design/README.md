# design —— 主页图片的源文件

GitHub 主页 README 里的横幅、图标，以及 X（Twitter）头图，都是从这里的 HTML 用无头 Chrome 截图生成的。
要改图，改这里的 HTML，然后在仓库根目录跑：

```bash
./design/build.sh
```

需要本机装了 Google Chrome（路径不同的话用 `CHROME=/path/to/chrome ./design/build.sh`）。

| 文件 | 是什么 | 生成到 |
|---|---|---|
| `github-banner.html` | README 顶部横幅：「Hi, I'm Xueshi」、副标题、右边的 app 图标 | `assets/banner.png` |
| `normalize-icon.html` | 把 `icon-src/` 里大小、留边不统一的原始图标，统一成 macOS 图标的样子 | `assets/icons/*.png` |
| `x-header.html` | X 头图的所有方案。直接用浏览器打开就是对比预览页 | `design/out/x-header-*.png` |
| `icon-src/` | 各个 app 的原始图标 | — |
| `build.sh` | 一键重新生成上面所有图片 | — |

## 常改的地方

- **横幅副标题**：`github-banner.html` 里 `id="tg"` 那一行。
- **横幅上的图标**：`github-banner.html` 底部那几个 `<img>`。
- **加一个新 app**：
  1. 原始图标放进 `icon-src/<名字>.png`；
  2. 在 `build.sh` 第 1 步的列表里加上它（满版方形的图标写 `<名字>:bleed`）；
  3. README 卡片表格里照着别的格子加一格。
- **X 头图**：`x-header.html` 顶部的 `APPS`（名字和说明）、`SHORT`（短说明）、`TITLES`（V2 标题），
  命令行文字搜 `open xueshi.dev`。要导出哪几个版本，改 `build.sh` 第 3 步的列表。

## X 头图的布局约束

1500×500。左边 0–445px 只放背景，不放任何图标和文字 —— X 的头像会压在左下角。
