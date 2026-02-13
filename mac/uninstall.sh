#!/bin/bash

# =================================================================
# macOS AI 環境【還原腳本】
# 功能：移除 AI 優化設定，恢復 .zshrc 原貌
# =================================================================

AI_ENV_CONF="$HOME/.ai_env"
ZSHRC="$HOME/.zshrc"

echo "🧹 開始清理 AI 優化環境..."

# 1. 移除 .zshrc 中的載入指令
if [ -f "$ZSHRC" ]; then
    # 使用 BSD sed 移除特定行
    sed -i '' "/source.*\.ai_env/d" "$ZSHRC"
    sed -i '' "/\.ai_env/d" "$ZSHRC"
    echo "✅ 已從 .zshrc 移除連結"
fi

# 2. 刪除獨立設定檔
if [ -f "$AI_ENV_CONF" ]; then
    rm "$AI_ENV_CONF"
    echo "✅ 已刪除 $AI_ENV_CONF"
fi

# 3. 提示 Homebrew 工具處理
echo "-------------------------------------------------------"
echo "💡 設定已移除，但透過 Homebrew 安裝的工具 (bash, fd, rg 等) 仍保留。"
echo "若要徹底移除工具，請執行: brew uninstall bash coreutils findutils gnu-sed gnu-tar grep awk fd ripgrep jq fzf bat zoxide btop"
echo "-------------------------------------------------------"
echo "請執行 'source ~/.zshrc' 使變更生效。"