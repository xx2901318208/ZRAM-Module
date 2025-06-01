async function execShell(cmd) {
  try {
    const res = await fetch(`/exec?cmd=${encodeURIComponent(cmd)}`);
    return await res.text();
  } catch (e) {
    console.error('执行失败:', e);
    return '错误';
  }
}

async function refreshZram() {
  // 获取压缩算法
  let algoRaw = await execShell("cat /sys/block/zram0/comp_algorithm");
  let algo = algoRaw.replace(/\[|\]/g, '').split(' ').pop();

  // 获取总空间（字节 -> MB）
  let orig_data_size = await execShell("cat /sys/block/zram0/orig_data_size");
  let origMB = (parseInt(orig_data_size.trim()) / 1048576).toFixed(2);

  // 获取使用空间
  let mem_used_total = await execShell("cat /sys/block/zram0/mem_used_total");
  let usedMB = (parseInt(mem_used_total.trim()) / 1048576).toFixed(2);

  // 压缩率
  let ratio = (origMB / usedMB).toFixed(2);

  document.getElementById("algo").innerText = algo || "未知";
  document.getElementById("size").innerText = isNaN(origMB) ? "NaN" : `${origMB} MB`;
  document.getElementById("used").innerText = isNaN(usedMB) ? "NaN" : `${usedMB} MB`;
  document.getElementById("ratio").innerText = isFinite(ratio) ? ratio + " : 1" : "NaN";
}

// 页面加载完成时自动刷新一次
document.addEventListener("DOMContentLoaded", refreshZram);
