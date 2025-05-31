function readSys(path) {
  return fetch("/exec?cmd=cat " + encodeURIComponent(path))
    .then(res => res.text())
    .then(text => text.trim())
    .catch(err => "读取失败");
}

async function refreshZram() {
  const algo = await readSys("/sys/block/zram0/comp_algorithm");
  const size = await readSys("/sys/block/zram0/disksize");
  const used = await readSys("/sys/block/zram0/mem_used_total");
  const orig = await readSys("/sys/block/zram0/orig_data_size");

  const sizeMB = (parseInt(size) / 1024 / 1024).toFixed(2);
  const usedMB = (parseInt(used) / 1024 / 1024).toFixed(2);
  const origMB = (parseInt(orig) / 1024 / 1024).toFixed(2);
  const ratio = (origMB && usedMB) ? (origMB / usedMB).toFixed(2) : "N/A";

  document.getElementById("algo").innerText = algo;
  document.getElementById("size").innerText = `${sizeMB} MB`;
  document.getElementById("used").innerText = `${usedMB} MB`;
  document.getElementById("ratio").innerText = `${ratio} 倍`;
}

window.onload = refreshZram;
