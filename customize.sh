MODPATH=$MODPATH
ZRAM_DIR="$MODPATH/zram"

ui_print ">> 检查 zram 文件夹是否存在..."

if [ -d "$ZRAM_DIR" ]; then
  ui_print ">> 检测到已有 zram 文件夹，保留原内容，跳过覆盖"
else
  ui_print ">> 未检测到 zram 文件夹，创建并复制新文件"
  mkdir -p "$ZRAM_DIR"
  cp -af "$TMPDIR/zram/." "$ZRAM_DIR/"
fi
