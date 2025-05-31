# ZRAM-Module

[English README](README.md)

## 📦 简介

`ZRAM-Module` 是一个基于 Magisk/KernelSU 的模块，用于为 Android 设备内核添加自定义 ZRAM 压缩算法支持（如 `lz4kd`, `zstdn` 等）。适用于已经自行编译支持的内核环境，能够帮助用户在刷入后自动配置 ZRAM 参数。

---

## ⚙️ 特性

- 支持自定义压缩算法（如 `lz4kd`）
- 支持自定义 ZRAM 大小（单位：Byte）
- 支持开机自动加载内核模块
- 完全通过 `Magisk/KernelSU` 实现，无需修改系统分区

---

## 🚀 使用方式

### 步骤一：准备你的内核模块

1. **自行编译内核源码**
2. 编译出你所需的压缩算法内核模块（如 `crypto_zstdn.ko` 或其他）
3. 将其重命名为 `zram.ko` 并覆盖 `zram/` 目录下的 `zram.ko`

---

### 步骤二：配置压缩算法与容量

在模块根目录下编辑 `config.prop` 文件，修改如下内容：

```ini
ZRAM_ALGO=lz4kd       # 算法名
ZRAM_SIZE=12884901888 # ZRAM字节数
```

- `ZRAM_ALGO`：指定使用的压缩算法名称（必须与你的 `.ko` 文件一致）  
- `ZRAM_SIZE`：ZRAM 空间大小（单位为字节）

⚠️ 未配置 `config.prop` 将导致模块初始化失败。

---

### 步骤三：打包并刷入模块

1. 将整个模块目录打包成 ZIP 文件  
2. 使用 Magisk App 或 TWRP 刷入 ZIP 文件：
`Magisk → 模块 → 安装模块 → 选择 ZIP`
3. 重启设备后，模块会自动生效并配置 ZRAM

---

## 常见问题

**Q: 支持哪些压缩算法？**  
取决于你自行编译并放入的内核模块，常见如 `lz4kd`、`zstdn`、`lzo-rle` 等。

**Q: ZRAM_SIZE 的单位是什么？**  
单位是字节（Byte），例如 `12884901888` 表示 12 GB。  
⚠️ **`ZRAM_SIZE` 最好不要大于设备物理内存，否则可能导致意外错误。**

**Q: 内核是否必须开启 ZRAM？**  
请确保关闭系统设置（如 Scene 等应用）中的 ZRAM 功能，否则模块无法正常工作。

**Q: 如果配置错误会怎样？**  
模块启动时会失败，ZRAM 不会被正确初始化。

---

## 作者

- [ShirkNeko](https://github.com/ShirkNeko)
- [xiaoxiaow](https://github.com/Xiaomichael)
- [FurLC](https://github.com/FurLC)
