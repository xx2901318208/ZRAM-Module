MODDIR="/data/adb/modules/ZRAM-Module"
CONFIG_FILE="$MODDIR/config.prop"

# 加载配置
if [ -f "$CONFIG_FILE" ]; then
  . "$CONFIG_FILE"
else
  echo "未找到 config.prop，退出" >&2
  exit 1
fi

# 重载 zram
echo "停用当前 zram..."
swapoff /dev/block/zram0

echo "重置 zram 参数..."
echo 1 > /sys/block/zram0/reset
echo 0 > /sys/block/zram0/disksize
echo 8 > /sys/block/zram0/max_comp_streams
echo "$ZRAM_ALGO" > /sys/block/zram0/comp_algorithm
echo "$ZRAM_SIZE" > /sys/block/zram0/disksize

echo "创建 zram 并启用..."
mkswap /dev/block/zram0
swapon /dev/block/zram0

echo "ZRAM 热重载完成。"
