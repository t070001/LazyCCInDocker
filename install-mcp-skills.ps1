# =====================================================
# MCP & Skill 批量安裝腳本（修正版）
# =====================================================
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# 定義路徑
$skillDir = "C:\Users\FunChang\.claude\skills"
$configPath = "C:\Users\FunChang\.claude\settings.json"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

# 創建必要目錄
mkdir $skillDir -Force | Out-Null

# =====================================================
# 安裝 MCP 服務
# =====================================================
Write-Host "📦 安裝 MCP 服務..." -ForegroundColor Cyan
$mcpServices = @("@modelcontextprotocol/server-sentry", "@modelcontextprotocol/server-dockerhub", "@modelcontextprotocol/server-brave-search")
foreach ($service in $mcpServices) {
    Write-Host "  installing $service..." -ForegroundColor Yellow
    npm install -g $service 2>&1 | ForEach-Object { Write-Host $_ }
}
# kubernetes is CLI tool, not an npm package - skip npm install for it

# =====================================================
# 配置 MCP
# =====================================================
$mcpConfig = @{
    mcpServers = @{
        sentry = @{ command = "npx"; args = @("@modelcontextprotocol/server-sentry") }
        dockerhub = @{ command = "npx"; args = @("@modelcontextprotocol/server-dockerhub") }
        kubernetes = @{ command = "kubectl"; args = @() }
        "brave-search" = @{ command = "npx"; args = @("@modelcontextprotocol/server-brave-search") }
    }
}

$mcpConfig | ConvertTo-Json -Depth 10 | Out-File $configPath -Encoding UTF8
Write-Host "✅ MCP 配置已寫入：$configPath" -ForegroundColor Green

# =====================================================
# 克隆 Skill（使用 PowerShell 下載 GitHub ZIP 替代 git）
# =====================================================
Write-Host "🎯 克隆 Skill..." -ForegroundColor Cyan

$skills = @{
    "i-have-adhd" = "https://github.com/ayghri/i-have-adhd.git"
    "ponytail"    = "https://github.com/DietrichGebert/ponytail.git"
}

foreach ($name in $skills.Keys) {
    $url = $skills[$name]
    $path = Join-Path $skillDir $name

    if (Test-Path $path) {
        Write-Host "  ⚠️ $name already exists, skipping" -ForegroundColor Yellow
        continue
    }

    Write-Host "  downloading $name from $url..." -ForegroundColor Yellow

    # 從 GitHub 下載 ZIP（使用 main 分支）
    $repoPart = $url -replace "https://github.com/|\.git$", ""
    $zipUrl = "https://github.com/$repoPart/archive/refs/heads/main.zip"
    $tempZip = Join-Path $Temp "$name.zip"

    try {
        Invoke-WebRequest -Uri $zipUrl -OutFile $tempZip -UseBasicParsing
        Write-Host "  Extracting archive..." -ForegroundColor Yellow
        Expand-Archive -Path $tempZip -DestinationPath $path -Force

        # 清理：重命名提取的資料夾（通常是 repo-name-main）
        $extractedFolder = Get-ChildItem $path | Where-Object {$_.PsIsContainer -and $_.Name -like "*-*"} | Select-Object -First 1
        if ($extractedFolder) {
            $newPath = Join-Path $skillDir $name
            if (-not (Test-Path $newPath)) {
                Move-Item $extractedFolder.Path $newPath
                Remove-Item $extractedFolder.Path -Recurse
            }
        }

        Remove-Item $tempZip
        Write-Host "  ✅ $name downloaded and extracted successfully" -ForegroundColor Green
    } catch {
        Write-Host "  ⚠️ Download failed: $($_.Exception.Message)" -ForegroundColor Yellow
        Write-Host "  Please install Git and run: git clone $url $path" -ForegroundColor Yellow
    }
}

Write-Host "=========================================" -ForegroundColor Green
Write-Host "安裝完成！" -ForegroundColor Green
Write-Host "MCP: sentry, dockerhub, kubernetes, brave-search" -ForegroundColor Cyan
Write-Host "Skills: i-have-adhd, ponytail" -ForegroundColor Green
