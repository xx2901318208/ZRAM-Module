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

# 延迟启动（防止系统未完成初始化）
sleep 30

# 关闭并重置所有现有 zram 设备
for dev in /dev/block/zram*; do
  if [ -e "$dev" ]; then
    echo "Disabling $dev"
    swapoff "$dev" 2>/dev/null
    echo 1 > "/sys/block/$(basename "$dev")/reset"
  fi
done

# 尝试卸载模块，确保干净状态
if lsmod | grep -q "^zram"; then
  echo "Removing existing zram module"
  rmmod zram
  sleep 1
fi

# 加载自定义 zstdn 模块（如果存在）
if [ -f "$MODDIR/zram/zstdn.ko" ]; then
  su -c insmod "$MODDIR/zram/zstdn.ko"
fi

# 加载 zram 模块（仅一次）
if ! lsmod | grep -q "^zram"; then
  su -c insmod "$MODDIR/zram/zram.ko"
else
  echo "zram module already loaded, skipping"
fi

# 配置 zram0（确保只有一个）
if [ -e /dev/block/zram0 ]; then
  sleep 5
  echo '1' > /sys/block/zram0/reset
  echo '0' > /sys/block/zram0/disksize
  echo '8' > /sys/block/zram0/max_comp_streams
  echo "${ZRAM_ALGO}" > /sys/block/zram0/comp_algorithm
  echo "${ZRAM_SIZE}" > /sys/block/zram0/disksize
  mkswap /dev/block/zram0 > /dev/null 2>&1
  swapon /dev/block/zram0 > /dev/null 2>&1
  echo "zram0 is now active with ${ZRAM_ALGO} and size ${ZRAM_SIZE}"
else
  echo "zram0 not found, failed to initialize swap"
  exit 1
fi

# 检查是否还有多余 zram 设备
zram_count=$(ls /sys/block/ | grep -c '^zram')
if [ "$zram_count" -gt 1 ]; then
  echo "Warning: More than one zram device present!"
  ls /sys/block/ | grep '^zram'
fi
