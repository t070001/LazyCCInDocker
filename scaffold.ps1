function New-DevProject {
    param([string]$Name)
    if (-not $Name) { $Name = Read-Host "專案名稱" }
    $path = Join-Path (Get-Location) $Name
    if (Test-Path $path) { Write-Warning "資料夾已存在: $path"; return }

    New-Item -ItemType Directory -Path $path -Force | Out-Null

    # 從 LazyCCInDocker 複製檔案（改成你的實際路徑）
    $src = "$env:USERPROFILE\projects\LazyCCInDocker"
    if (Test-Path "$src\.devcontainer") {
        Copy-Item -Recurse "$src\.devcontainer" "$path\" -Force
        Copy-Item "$src\setup-claude.sh" "$path\" -Force
        Write-Host "✅ 已複製 devcontainer 設定到 $path" -ForegroundColor Green
        Write-Host "   → code . 然後 Reopen in Container" -ForegroundColor Cyan
    } else {
        Write-Warning "找不到來源: $src"
    }
}

# 簡短別名
Set-Alias ndev New-DevProject
