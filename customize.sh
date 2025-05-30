MODPATH=${0%/*}
MODNAME="$(basename "$MODPATH")"
OLD_MODPATH="/data/adb/modules/$MODNAME"
ZRAM_DIR="$MODPATH/ZRAM"
OLD_ZRAM_DIR="$OLD_MODPATH/ZRAM"

ui_print ">> 检查已安装模块的 ZRAM 文件夹是否存在..."
mkdir "$ZRAM_DIR"

if [ -d "$OLD_ZRAM_DIR" ]; then
  ui_print ">> 检测到已有 ZRAM 文件夹，复制原文件"
  cp -af "$OLD_MODPATH/ZRAM/." "$ZRAM_DIR"
else
  ui_print ">> 未检测到 ZRAM 文件夹，跳过复制"
fi
