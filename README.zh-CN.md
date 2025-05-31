# ZRAM-Module

[English](README.md) | [中文](README.zh-CN.md)

## 📦 模块简介

`ZRAM-Module` 是一个基于 **Magisk / KernelSU** 的模块，适用于已支持 ZRAM 的 Android 内核。它可以自动加载用户自定义的压缩算法模块（如 `lz4kd`、`zstdn` 等），并配置 ZRAM 空间大小。

适用于自定义内核用户，无需修改系统分区，即可实现内核模块加载和自动初始化。

---

## ⚙️ 模块特性

- ✅ 支持加载自定义压缩算法（例如 `lz4kd`, `zstdn`）
- ✅ 支持自定义 ZRAM 大小（单位：字节）
- ✅ 支持开机自动加载 `.ko` 模块
- ✅ 完全基于 Magisk / KernelSU 实现，无需更改系统分区

---

## 🚀 使用指南

### 第一步：准备内核模块

1. 编译你设备对应的内核源码  
2. 编译所需的压缩算法模块（例如：`crypto_zstdn.ko`）
3. 将模块重命名为 `zram.ko`，并放入本模块目录的 `zram/` 子目录中

```bash
# 示例路径结构
ZRAM-Module/
├── config.prop
└── zram/
    └── zram.ko  # 重命名后的模块
```


### 第二步：编辑配置文件

修改模块根目录下的 `config.prop` 文件：

```ini
ZRAM_ALGO=lz4kd         # 使用的压缩算法名称（对应内核模块）
ZRAM_SIZE=12884901888   # ZRAM 大小，单位：字节（12GB）
```

📌 **注意：**

- `ZRAM_ALGO` 必须与模块实现的算法名称一致
- `ZRAM_SIZE` 建议不超过设备实际内存容量

若未配置 `config.prop`，模块将无法正常初始化。


### 第三步：打包并刷入模块

1. 将整个模块目录压缩为 ZIP 文件  
2. 使用 **Magisk/KernelSU** 或 **TWRP** 刷入模块 ZIP：

```text
Magisk/KernelSU → 模块 → 安装模块 → 选择 ZIP 文件
```

3. 重启设备，模块将自动加载并初始化 ZRAM 配置

---

## ❓ 常见问题解答

### Q: 模块支持哪些压缩算法？
A: 支持任何你已自行编译的压缩算法模块，例如：

- `lz4kd`
- `zstdn`
- `lzo-rle`  

前提是对应的 `.ko` 文件已正确放入 `zram/` 目录。


### Q: `ZRAM_SIZE` 的单位是什么？
A: 单位是 **字节（Byte）**，例如：

```ini
ZRAM_SIZE=8589934592  # 表示 8 GB
ZRAM_SIZE=12884901888  # 表示 12 GB
ZRAM_SIZE=17179869184  # 表示 16 GB
```

⚠️ 不建议设置超过设备物理内存的容量，可能导致系统异常。


### Q: 是否必须在内核中启用 ZRAM？
A: 是的。请确保：

- 你的内核已启用 ZRAM 支持
- 关闭系统设置中其他 ZRAM 管理功能（如 Scene 等工具）


### Q: 如果配置错误会发生什么？
A: 模块将无法初始化，ZRAM 设备也不会被正确创建。
你可以查看日志来诊断问题：

```text
./ZRAM-Module/zram_module.log
```
