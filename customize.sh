MODDIR=${0%/*}
TMPDIR=$MODDIR
ZRAM_DIR="$MODPATH/ZRAM"

ui_print ">> 检查 ZRAM 文件夹是否存在..."

if [ -d "$ZRAM_DIR" ]; then
  ui_print ">> 检测到已有 ZRAM 文件夹，保留原内容，跳过覆盖"
else
  ui_print ">> 未检测到 ZRAM 文件夹，创建 ZRAM 文件夹"
  mkdir -p "$ZRAM_DIR"
fi
