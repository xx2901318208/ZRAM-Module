#!/system/bin/sh

MODDIR=${0%/*}
CONFIG_FILE="$MODDIR/config.prop"

# 如果配置文件不存在则退出
if [ ! -f "$CONFIG_FILE" ]; then
  echo "config.prop not found! Exiting."
  exit 1
fi

# 加载变量
. "$CONFIG_FILE"

# 检查变量是否定义
if [ -z "$ZRAM_ALGO" ] || [ -z "$ZRAM_SIZE" ]; then
  echo "ZRAM_ALGO or ZRAM_SIZE is not set! Exiting."
  exit 1
fi

# 加载zram
sleep 30
su -c insmod $MODDIR/zram/zstdn.ko
su -c swapoff /dev/block/zram0
su -c rmmod zram
sleep 5
su -c insmod $MODDIR/zram/zram.ko
sleep 5
echo '1' > /sys/block/zram0/reset
echo '0' > /sys/block/zram0/disksize
echo '8' > /sys/block/zram0/max_comp_streams
su -c "echo '${ZRAM_ALGO}' > /sys/block/zram0/comp_algorithm"
su -c "echo '${ZRAM_SIZE}' > /sys/block/zram0/disksize"
mkswap /dev/block/zram0 > /dev/null 2>&1
swapon /dev/block/zram0 > /dev/null 2>&1
