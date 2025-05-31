echo "[ZRAM 当前状态]"
echo "--------------------------"

ZRAM="/sys/block/zram0"
if [ -d "$ZRAM" ]; then
  echo "压缩算法: $(cat $ZRAM/comp_algorithm 2>/dev/null)"
  echo "磁盘大小: $(cat $ZRAM/disksize 2>/dev/null)"
  echo "已用内存: $(cat $ZRAM/mem_used_total 2>/dev/null)"
  echo "压缩后大小: $(cat $ZRAM/compr_data_size 2>/dev/null)"
  echo "原始大小: $(cat $ZRAM/orig_data_size 2>/dev/null)"
  echo
  echo "Swap 表:"
  cat /proc/swaps | grep zram
else
  echo "未检测到 zram0 设备。"
fi
