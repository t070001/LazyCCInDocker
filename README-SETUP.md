# 🚀 Claude Code + Docker 沙盒隔離 + Agnes AI 免費端點（母體調適專案指南）

本專案是針對獨立開發者設計的「終極懶人自動化開發環境」。透過將專案與 AI 引擎完全關在 Ubuntu 24.04 Docker 容器內，徹底解決本機大檔案塞爆 32MB 的問題，同時透過跨界網絡直連 Windows 本機的 `cc-switch` 橋接器，白嫖 Agnes AI 的無限免費 Token，實現「開發成本歸零」的完全體。

---

## 🎯 當前母體專案的核心任務 (AI 請立即執行)
親愛的 Claude，當你讀到這個檔案時，請立刻在目前的 Ubuntu 24.04 容器內為我自動配置並啟用以下「3大核心常駐 Skills」與 MCP 服務：

### 1. 預載並啟用 3 大指定核心常駐 Skills
請至 Marketplace 下載、加入並在目前的 Session 中全自動啟動以下三個 Skill（如果找不到，請自動透過網路或 GitHub 倉庫搜尋下載）：
*   **`grill-me`**：高強度程式碼代碼審查與除錯引導。
*   **`ponytail`**：專門優化高階邏輯與自動化建構腳本的核心外掛。
*   **`i-have-adhd`**：極致視覺錨點優化，用高對比、超 Scannable（好讀、短句、重點標記）的格式來與我交談，防止我漏看任何關鍵程式碼。

### 2. MCP 服務（透過 Docker MCP Toolkit）
MCP 服務（SQLite、Fetch、Sentry 等）請透過 **Docker MCP Toolkit** 在容器內設定，無需在本機手動安裝。

---

## 🚀 一鍵啟動（給想直接用的人）

**需要：** Docker Desktop + VS Code + Dev Containers 擴充功能

```bash
git clone <your-repo-url> && cd <project>
code .
# VS Code 右下角彈出 → "Reopen in Container" → 點下去
# 等 2 分鐘，自動裝好 Node 22、Claude Code、設定檔
# 開啟終端機 → 執行：
claude
```

就這麼簡單。容器會自己 build 好，所有依賴一次到位。

---

## 🛠️ 手動三步驟（給想了解細節的人）

如果在其他電腦需要重新部署本環境，請直接依照以下物理步驟操作，100% 免疫 Windows 路徑解析 Bug：

### 步驟 1：Windows 本機環境準備
1. 確保新電腦已安裝 **Docker Desktop** 與 **VS Code**（須安裝 `Dev Containers` 擴充功能）。
2. 下載並打開 **`cc-switch` 桌面客戶端**（<!-- TODO: 補上 cc-switch 下載來源 -->）。
3. 配置 **Agnes AI 的免費 Key**（Base URL: `https://agnes-ai.com`，Model: `agnes-2.0-flash`）。
4. **【關鍵】** 必須打開 cc-switch 的「本地路由（Local Routing）」開關，並確認監聽在 **`15721`** 埠（即 `http://127.0.0.1:15721`）。

### 步驟 2：物理強行啟動 Docker 獨立沙盒
在新電腦的 Windows **PowerShell** 中，直接移動到專案資料夾下，執行以下指令強行開闢 Ubuntu 24.04 沙盒（完全去微軟化，阻斷網址解析 Bug）：
```powershell
docker run -d --name claude_ubuntu_sandbox -v "${PWD}:/workspace" -v "claude-global-node:/usr/local/lib/node_modules" -w /workspace ubuntu:24.04 tail -f /dev/null
```

### 步驟 3：VS Code 連線並一鍵點火
1. 打開 VS Code，按下 `F1` 選擇 **`Dev Containers: Attach to Running Container...`**，點擊 **`claude_ubuntu_sandbox`**。
2. 進入後，點擊「開啟資料夾」，路徑輸入 `/workspace`。
3. 按下 `` Ctrl + ` `` 打開容器終端機，執行：
```bash
# 啟動 Claude Code
claude
```

---

## 💾 專案「不失憶」中斷管理規範
為了防止容器重啟或中斷導致 AI 忘記進度，請遵守以下約定：
1. **每日收工前**：對 Claude 說：「我要下班了，請更新 `.claude-progress.md` 備忘錄。」
2. **隔日開工時**：對 Claude 說：「讀取 `.claude-progress.md` 並執行 `git diff`，繼續把昨天的程式碼寫完。」

