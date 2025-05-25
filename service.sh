#!/system/bin/sh

MODDIR=${0%/*}

# 延迟启动，等待系统稳定
sleep 30

# 模块路径
ZSTDN_KO="$MODDIR/zram/zstdn.ko"
ZRAM_KO="$MODDIR/zram/zram.ko"

# 使用 KernelSU 权限执行
su -c "insmod $ZSTDN_KO"
su -c "swapoff /dev/block/zram0"
su -c "rmmod zram"
sleep 5
su -c "insmod $ZRAM_KO"
sleep 5

# 配置 zram 参数
su -c "echo '1' > /sys/block/zram0/reset"
su -c "echo '0' > /sys/block/zram0/disksize"
su -c "echo '8' > /sys/block/zram0/max_comp_streams"
su -c "echo 'lz4kd' > /sys/block/zram0/comp_algorithm"
su -c "echo '17179869184' > /sys/block/zram0/disksize"

# 启用 swap
su -c "mkswap /dev/block/zram0 > /dev/null 2>&1"
su -c "swapon /dev/block/zram0 > /dev/null 2>&1"
