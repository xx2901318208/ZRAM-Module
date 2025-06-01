import { exec, toast } from 'kernelsu';

export async function refreshZram() {
  try {
    // 获取压缩算法
    const algoRes = await exec("cat /sys/block/zram0/comp_algorithm");
    const algo = algoRes.stdout.replace(/\[|\]/g, '').trim().split(' ').pop();

    // 获取原始数据大小（MB）
    const origRes = await exec("cat /sys/block/zram0/orig_data_size");
    const origMB = (parseInt(origRes.stdout.trim()) / 1048576).toFixed(2);

    // 获取已用内存（MB）
    const usedRes = await exec("cat /sys/block/zram0/mem_used_total");
    const usedMB = (parseInt(usedRes.stdout.trim()) / 1048576).toFixed(2);

    // 计算压缩率
    const ratio = (origMB / usedMB).toFixed(2);

    // 显示到页面
    document.getElementById("algo").innerText = algo || "未知";
    document.getElementById("size").innerText = isNaN(origMB) ? "NaN" : `${origMB} MB`;
    document.getElementById("used").innerText = isNaN(usedMB) ? "NaN" : `${usedMB} MB`;
    document.getElementById("ratio").innerText = isFinite(ratio) ? `${ratio} : 1` : "NaN";

  } catch (err) {
    toast("ZRAM 状态加载失败");
    console.error("读取失败：", err);
  }
}

document.addEventListener("DOMContentLoaded", refreshZram);
