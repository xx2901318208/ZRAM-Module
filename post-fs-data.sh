MODDIR=${0%/*}
LOGFILE="$MODDIR/zram_module.log"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOGFILE"
}

# 清理 zram1, zram2 等除 zram0 以外的 zram 实例
for zdev in /dev/block/zram*; do
  zname=$(basename "$zdev")
  if [ "$zname" != "zram0" ]; then
    idx="${zname#zram}"
    log "清理 $zname"
    swapoff "/dev/block/$zname" 2>/dev/null
    echo 1 > "/sys/block/$zname/reset" 2>/dev/null
    echo "$idx" > /sys/class/zram-control/hot_remove 2>/dev/null
    log "已移除 zram$idx"
  fi
done
