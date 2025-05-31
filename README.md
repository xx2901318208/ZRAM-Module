# ZRAM-Module

[English](README.md) | [中文](README.zh-CN.md)

## 📦 Module Overview

`ZRAM-Module` is a **Magisk / KernelSU** based module designed for Android kernels with ZRAM support. It allows automatic loading of user-defined compression algorithm modules (such as `lz4kd`, `zstdn`, etc.) and configures the ZRAM size at boot.

Ideal for custom kernel users, it enables kernel module loading and initialization without modifying the system partition.

---

## ⚙️ Module Features

- ✅ Supports loading custom compression algorithms (e.g. `lz4kd`, `zstdn`)
- ✅ Supports custom ZRAM size (in bytes)
- ✅ Automatically loads `.ko` modules at boot
- ✅ Fully implemented via Magisk / KernelSU, no system partition modification required

---

## 🚀 Usage Guide

### Step 1: Prepare Your Kernel Module

1. Compile the kernel source code for your device  
2. Build the desired compression algorithm module (e.g., `crypto_zstdn.ko`)
3. Rename the compiled module to `zram.ko` and place it in the `zram/` subdirectory of this module

```bash
# Example directory structure
ZRAM-Module/
├── config.prop
└── zram/
    └── zram.ko  # Renamed kernel module
```


### Step 2: Edit Configuration File

Edit the `config.prop` file in the module's root directory:

```ini
ZRAM_ALGO=lz4kd         # Compression algorithm name (matches kernel module)
ZRAM_SIZE=12884901888   # ZRAM size in bytes (e.g., 12 GB)
```

📌 **Note:**

- `ZRAM_ALGO` must match the algorithm implemented by your  `.ko` module
- `ZRAM_SIZE` should not exceed your device’s physical RAM

If `config.prop` is not configured, the module will fail to initialize.


### Step 3: Package and Flash the Module

1. Compress the entire module directory into a ZIP file
2. Flash the ZIP using **Magisk/KernelSU** or **TWRP**：

```text
Magisk/KernelSU → Modules → Install from storage → Select ZIP file
```

3. Reboot your device. The module will automatically load and initialize ZRAM.

---

## ❓ FAQ

### Q: What compression algorithms are supported?
A: Any compression algorithm module that you compile yourself, such as:

- `lz4kd`
- `zstdn`
- `lzo-rle`  

As long as the corresponding `.ko` file is correctly placed in the `zram/` directory.


### Q: What is the unit for `ZRAM_SIZE`?
A: The unit is **bytes**. For example:

```ini
ZRAM_SIZE=8589934592    # 8 GB
ZRAM_SIZE=12884901888   # 12 GB
ZRAM_SIZE=17179869184   # 16 GB
```

⚠️ It is **not recommended** to set `ZRAM_SIZE` larger than your device’s physical RAM, as it may cause system instability.


### Q: Does the kernel need to have ZRAM support enabled?
A: Yes. Please ensure that:

- Your kernel is compiled with ZRAM support
- Other system-level ZRAM features or tools (like Scene, etc.) are disabled to avoid conflicts


### Q: What happens if the configuration is incorrect?
A: The module will fail to initialize, and the ZRAM device will not be set up.
You can check the log to diagnose the issue:

```text
./ZRAM-Module/zram_module.log
```
