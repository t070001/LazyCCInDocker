#!/bin/bash
# 在設定檔中，加入常駐的系統提示（System Prompt 擴充）
# 告訴 Claude 每次重啟時，優先讀取專案內的進度錨點檔案
mkdir -p ~/.claude

# 1. 自動寫入帶有 Agnes AI 路由、你原本所有常駐 Plugins 的核心設定檔
cat << 'EOF' > ~/.claude/settings.json
{
  "$schema": "https://schemastore.org",
  "env": {
    "ANTHROPIC_BASE_URL": "http://host.docker.internal:15721",
    "ANTHROPIC_API_KEY": "sk-dummy-key-for-claude-code"
  },
  "model": "agnes-2.0-flash",
  "enabledPlugins": {
    "ponytail@ponytail": true,
    "i-have-adhd@i-have-adhd": true,
    "sentry-mcp@sentry-mcp": true
  },
  "extraKnownMarketplaces": {
    "ponytail": { "source": { "source": "github", "repo": "DietrichGebert/ponytail" } },
    "i-have-adhd": { "source": { "source": "github", "repo": "ayghri/i-have-adhd" } },
    "sentry-mcp": { "source": { "source": "github", "repo": "getsentry/sentry-mcp" } }
  },
  "theme": "dark"
}
EOF

echo "✅ Ubuntu 24.04 基礎環境與外掛庫預載成功！MCP 請透過 Docker MCP Toolkit 設定。"
