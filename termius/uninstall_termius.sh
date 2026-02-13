#!/bin/bash

# --- 顏色設定 ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}==> 開始徹底移除 Termius...${NC}"

# 1. 檢查並關閉正在執行的 Termius
if pgrep -x "Termius" > /dev/null; then
    echo -e "${YELLOW}正在關閉執行中的 Termius...${NC}"
    killall "Termius" &> /dev/null
    sleep 2
fi

# 2. 使用 Homebrew 移除 (如果是透過 Brew 安裝)
if brew list --cask termius &> /dev/null; then
    echo -e "${YELLOW}偵測到 Homebrew 安裝紀錄，執行 brew uninstall...${NC}"
    brew uninstall --cask termius
else
    # 如果不是用 brew 安裝，手動刪除應用程式
    if [ -d "/Applications/Termius.app" ]; then
        echo -e "${YELLOW}正在手動刪除 /Applications/Termius.app...${NC}"
        sudo rm -rf "/Applications/Termius.app"
    fi
fi

# 3. 清理殘留的設定檔與快取 (這部分最重要)
echo -e "${YELLOW}正在清理殘留的設定檔與快取資料...${NC}"

FILES=(
    "$HOME/Library/Application Support/Termius"
    "$HOME/Library/Caches/com.termius-desktop"
    "$HOME/Library/Caches/com.termius-desktop.ShipIt"
    "$HOME/Library/Logs/Termius"
    "$HOME/Library/Preferences/com.termius-desktop.plist"
    "$HOME/Library/Saved Application State/com.termius-desktop.savedState"
    "/Library/Logs/DiagnosticReports/Termius*"
)

for file in "${FILES[@]}"; do
    if [ -e "$file" ] || [ -d "$file" ]; then
        rm -rf "$file"
        echo -e "已刪除: $file"
    fi
done

echo -e "${GREEN}==> Termius 已完全移除！${NC}"