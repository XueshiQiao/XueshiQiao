#!/bin/bash
# 重新生成主页 README 用的图片，以及 X 头图。
# 用法：在仓库根目录跑 ./design/build.sh
#   产物：assets/banner.png、assets/icons/*.png（README 直接引用）
#         design/out/x-header-*.png（X 头图，不进 git）
set -euo pipefail
cd "$(dirname "$0")"
CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
shot() { # 宽 高 倍率 输出文件 网址 [额外参数]
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars --allow-file-access-from-files \
    --force-device-scale-factor="$3" --window-size="$1,$2" --virtual-time-budget=2000 \
    ${6:-} --screenshot="$4" "$5" 2>/dev/null
}
HERE="file://$PWD"

# 1. 图标：统一成 macOS 图标的大小和圆角，透明背景，256×256
#    满版方形的原图（没有留边和圆角）用 bleed，自带留边偏少的用 tight
for spec in pastepaw:bleed qduo: anydrag:tight hypercapslock: ccswitcher: netstat-cat:bleed flowy:bleed; do
  n="${spec%%:*}"; c="${spec#*:}"
  shot 256 256 1 "../assets/icons/$n.png" "$HERE/normalize-icon.html?n=$n&c=$c" --default-background-color=00000000
done

# 2. README 顶部横幅：1280×340，按 2 倍导出
shot 1280 340 2 ../assets/banner.png "$HERE/github-banner.html"

# 3. X 头图：1500×500，每个版本导出 1 倍和 2 倍
mkdir -p out
for v in v2b v2c v4b v4c; do
  shot 1500 500 1 "out/x-header-$v.png"    "$HERE/x-header.html?solo=$v"
  shot 1500 500 2 "out/x-header-$v@2x.png" "$HERE/x-header.html?solo=$v"
done
echo "done: assets/banner.png, assets/icons/, design/out/"
