async function refreshZram() {
  try {
    const res = await fetch("tmp/status.json");
    const json = await res.json();

    document.getElementById("algo").innerText = json.algorithm || "未知";
    document.getElementById("size").innerText = json.size || "未知";
    document.getElementById("used").innerText = json.used || "未知";
    document.getElementById("ratio").innerText = json.ratio || "未知";
  } catch (e) {
    console.error("加载失败:", e);
    document.getElementById("algo").innerText = "错误";
    document.getElementById("size").innerText = "错误";
    document.getElementById("used").innerText = "错误";
    document.getElementById("ratio").innerText = "错误";
  }
}