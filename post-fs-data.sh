MODDIR=${0%/*}

# 清理除 zram0 以外的所有 zram 实例
for zdev in /dev/block/zram*; do
  zname=$(basename "$zdev")
  if [ "$zname" != "zram0" ]; then
    swapoff "/dev/block/$zname" 2>/dev/null
    echo 1 > "/sys/block/$zname/reset" 2>/dev/null
    echo 1 > /sys/class/zram-control/hot_remove 2>/dev/null
    ui_print ">> 已清理多余设备：$zname"
  fi
done
