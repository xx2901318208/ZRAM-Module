# 自动获取模块名称与路径
MODNAME="$(basename "$MODPATH")"
OLD_MODPATH="/data/adb/modules/$MODNAME"

# 当前与旧模块 ZRAM 路径
ZRAM_DIR="$MODPATH/ZRAM"
OLD_ZRAM_DIR="$OLD_MODPATH/ZRAM"

ui_print "-------------"
ui_print "  _____           _     ____ "
ui_print " |  ___|   _ _ __| |   / ___|"
ui_print " | |_ | | | | '__| |  | |    "
ui_print " |  _|| |_| | |  | |__| |___ "
ui_print " |_|   \__,_|_|  |_____\____|"
ui_print "         FurLC ZRAM Module   "
ui_print "-------------"

ui_print ">> 检查已安装模块的 ZRAM 文件夹是否存在..."

if [ -d "$OLD_ZRAM_DIR" ]; then
  ui_print ">> 已检测到旧模块 ZRAM 文件夹，复制保留文件中..."
  mkdir -p "$ZRAM_DIR"
  cp -af "$OLD_ZRAM_DIR/." "$ZRAM_DIR/"
  ui_print ">> 文件复制完成 ✅"
else
  ui_print ">> 未检测到旧模块 ZRAM 文件夹，跳过复制"
fi
