MODDIR=${0%/*}

# 清理除 zram0 以外的所有 zram 实例
for zdev in /dev/block/zram*; do
  zname=$(basename "$zdev")
  if [ "$zname" != "zram0" ]; then
    idx="${zname#zram}"  # 提取编号
    echo "ZRAM Module: 清理 $zname" >> /dev/kmsg
    swapoff "/dev/block/$zname" 2>/dev/null
    echo 1 > "/sys/block/$zname/reset" 2>/dev/null
    echo "$idx" > /sys/class/zram-control/hot_remove 2>/dev/null
    echo "ZRAM Module: 已移除 zram$idx" >> /dev/kmsg
  fi
done
