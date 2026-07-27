# 🚀 LazyCCInDocker

**Claude Code + Docker 沙盒隔離 + Agnes AI 免費端點**

Ubuntu 24.04 Docker 容器內一鍵啟動 Claude Code 開發環境，透過 `cc-switch` 橋接 Agnes AI 無限免費 Token。

---

## ⚡ 快速啟動

### 我要用…

| 你想 | 就做這個 |
|------|---------|
| 🖥️ **VS Code 開發** | `code .` → Reopen in Container → `claude` |
| 💻 **純終端機開發** | `./start.ps1` |
| 🆕 **開新專案** | `./start.ps1 new my-app` → `cd my-app` → `code .` |
| 🔧 **以後想直接打 ndev** | `./start.ps1 install`（一次性） |

---

## 🖥️ VS Code 一鍵啟動（推薦）

**需要：** Docker Desktop + VS Code + Dev Containers 擴充

```bash
git clone https://github.com/t070001/LazyCCInDocker.git
cd LazyCCInDocker
code .
```

VS Code 右下角跳出 **「Reopen in Container」** → 點下去

等 2 分鐘（背景自動 build Ubuntu 24.04 + Node 22 + Claude Code），完成後在 VS Code 終端機執行：

```bash
claude
```

---

## 💻 終端機一鍵啟動

**只需要：** Docker Desktop

```powershell
git clone https://github.com/t070001/LazyCCInDocker.git
cd LazyCCInDocker
./start.ps1
```

腳本會自動：
1. 啟動 Ubuntu 24.04 容器
2. 安裝 Node 22 + Claude Code
3. 寫入設定檔
4. 進入 Claude Code CLI

---

## 🆕 開新專案

在同一個 repo 就能生出多個專案，不需重複 git clone：

```powershell
# 在你要放專案的地方
cd D:\projects
./路徑/LazyCCInDocker/start.ps1 new my-new-app

# 用 VS Code 開發
cd my-new-app
code .
# → Reopen in Container（2 秒）

# 或用終端機
cd my-new-app
./start.ps1
```

### 裝一次 ndev 指令（以後不用打路徑）

```powershell
./start.ps1 install    # 只做一次
# 重開 PowerShell
ndev my-app            # 在任何目錄直接開新專案
```

> `ndev` 只有你特地叫它的時候才會生出 devcontainer 設定。一般 `mkdir` 開資料夾完全不受影響。

---

## 🛠️ 手動步驟（給想了解細節的人）

### 本機準備
1. 安裝 **Docker Desktop** + **VS Code** + **Dev Containers** 擴充
2. 下載 **cc-switch** 桌面客戶端，設定 Agnes AI 免費 Key
3. 打開 cc-switch 的「本地路由」，確認監聽 `http://127.0.0.1:15721`

### 手動啟動容器
```powershell
docker run -d --name claude_ubuntu_sandbox `
    -v "${PWD}:/workspace" `
    -v "claude-global-node:/usr/local/lib/node_modules" `
    -w /workspace ubuntu:24.04 `
    tail -f /dev/null
```

### VS Code 連線
`F1` → **Dev Containers: Attach to Running Container** → 選 `claude_ubuntu_sandbox` → 開啟 `/workspace`

---

## 📦 內含 Skills

| Skill | 用途 |
|-------|------|
| **grill-me** | 高強度代碼審查與除錯引導 |
| **ponytail** | 優化邏輯與自動化建構腳本 |
| **i-have-adhd** | 高對比、超好讀的溝通格式 |

---

## 💾 中斷管理

- **收工前：** 對 Claude 說「我要下班了，請更新 `.claude-progress.md`」
- **開工時：** 對 Claude 說「讀取 `.claude-progress.md` 並執行 `git diff`」
