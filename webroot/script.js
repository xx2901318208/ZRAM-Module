let refreshing = false;
let lastData = {
  algorithm: "未知",
  size: "未知",
  used: "未知",
  ratio: "未知"
};
let fetchFailCount = 0; // 连续失败计数

async function refreshZram() {
  if (refreshing) return;
  refreshing = true;

  try {
    const res = await fetch("tmp/status.json?ts=" + Date.now());
    if (!res.ok) throw new Error("状态文件不存在或服务器错误");
    const json = await res.json();

    // 如果数据异常/缺失，则也认为是失败
    if (!json || !json.algorithm || !json.size || !json.used || !json.ratio) throw new Error("状态数据不完整");

    // 显示数据、清除错误提示
    setStatus(json.algorithm, autoUnit(json.size), autoUnit(json.used), json.ratio, false, "");
    lastData = {
      algorithm: json.algorithm,
      size: autoUnit(json.size),
      used: autoUnit(json.used),
      ratio: json.ratio
    };
    fetchFailCount = 0;
  } catch (e) {
    fetchFailCount++;
    // 只在第一次加载时才全部置为错误
    if (fetchFailCount === 1 && !lastData.hasOwnProperty("loadedOnce")) {
      setStatus("错误", "错误", "错误", "错误", false, "无法获取状态：" + e.message);
    } else if (fetchFailCount >= 3) {
      // 连续3次失败才全部置为错误
      setStatus("错误", "错误", "错误", "错误", false, "连续多次无法读取状态：" + e.message);
    } else {
      // 失败时保持现有数据，仅显示顶部小红提示
      setStatus(lastData.algorithm, lastData.size, lastData.used, lastData.ratio, false, "读取状态失败（网络或写入延迟），已自动重试…");
    }
  }
  lastData.loadedOnce = true;
  refreshing = false;
}

function autoUnit(str) {
  if (!str) return "";
  let n = parseInt(str, 10);
  if (isNaN(n)) return str;
  if (n > 1024 * 1024) return (n / 1024 / 1024).toFixed(2) + " GB";
  if (n > 1024) return (n / 1024).toFixed(2) + " MB";
  return n + " KB";
}

function setStatus(algo, size, used, ratio, skeleton, tip) {
  ["algo", "size", "used", "ratio"].forEach((id, i) => {
    const el = document.getElementById(id);
    el.classList.remove("skeleton");
    if (skeleton) el.classList.add("skeleton");
    if ([algo, size, used, ratio][i] !== null)
      el.innerText = [algo, size, used, ratio][i];
  });
  // 错误提示
  let tipEl = document.getElementById("errtip");
  if (!tipEl) {
    tipEl = document.createElement("div");
    tipEl.id = "errtip";
    tipEl.style = "color:#d00;text-align:center;margin-top:8px;";
    document.getElementById("zram-status").appendChild(tipEl);
  }
  tipEl.innerText = tip || "";
}

window.addEventListener("DOMContentLoaded", () => {
  // 初始时显示骨架屏
  setStatus("加载中...", "加载中...", "加载中...", "加载中...", true, "");
  refreshZram();
  setInterval(refreshZram, 1000);
  document.getElementById("refresh-btn")?.addEventListener("click", (e) => {
    if (refreshing) e.preventDefault();
    else refreshZram();
  });
});