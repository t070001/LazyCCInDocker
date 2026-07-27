#!/usr/bin/env pwsh
# =====================================================
# LazyCCInDocker — 一鍵啟動腳本
# 用法: ./start.ps1
# 任何人拿到 repo，執行這支就全部搞定
# =====================================================

$ErrorActionPreference = "Stop"
$CONTAINER = "lazycc-workspace"

# ── 1. 檢查 Docker ──
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "❌ 請先安裝 Docker Desktop" -ForegroundColor Red; exit 1
}

# ── 2. 確保容器在跑 ──
$existing = docker ps -a --filter "name=$CONTAINER" --format "{{.Status}}" 2>$null
if ($existing -match "^Up") {
    Write-Host "✅ 容器已在運行" -ForegroundColor Green
} else {
    if ($existing) { docker rm $CONTAINER -f | Out-Null }
    Write-Host "📦 啟動容器..." -ForegroundColor Yellow
    docker run -d --name $CONTAINER `
        -v "${PWD}:/workspace" `
        -v "claude-global-node:/usr/local/lib/node_modules" `
        -w /workspace `
        ubuntu:24.04 `
        tail -f /dev/null 2>$null
}

# ── 3. 確認 claude-code 已安裝 ──
$hasClaude = docker exec $CONTAINER claude --version 2>$null
if (-not $hasClaude) {
    Write-Host "📦 安裝 Claude Code..." -ForegroundColor Yellow
    docker exec $CONTAINER bash -c @'
        apt-get update -qq && apt-get install -y -qq curl ca-certificates > /dev/null 2>&1
        curl -fsSL https://deb.nodesource.com/setup_22.x | bash - > /dev/null 2>&1
        apt-get install -y -qq nodejs > /dev/null 2>&1
        npm install -g @anthropic-ai/claude-code > /dev/null 2>&1
'@
}

# ── 4. 執行設定腳本 ──
docker exec $CONTAINER bash ./setup-claude.sh

# ── 5. 啟動 Claude Code ──
Write-Host "`n🚀 進入開發環境..." -ForegroundColor Green
Write-Host "   輸入 exit 可離開`n" -ForegroundColor Cyan
docker exec -it $CONTAINER claude
