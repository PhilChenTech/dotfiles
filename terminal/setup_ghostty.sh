#!/bin/bash

# --- 顏色定義 ---
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${BLUE}正在執行 Ghostty 環境重置與安裝...${NC}"

# 1. 移除舊有的報錯設定檔
if [ -d "$HOME/.config/ghostty" ]; then
    echo -e "${RED}偵測到舊設定目錄，正在移除 ~/.config/ghostty...${NC}"
    rm -rf "$HOME/.config/ghostty"
    echo -e "${GREEN}舊設定已清除。${NC}"
else
    echo -e "${GREEN}未發現舊設定目錄，跳過清除步驟。${NC}"
fi

# 2. 檢查並安裝 Homebrew
if ! command -v brew &> /dev/null; then
    echo -e "${BLUE}正在安裝 Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 3. 安裝 Ghostty 軟體
echo -e "${BLUE}正在透過 Homebrew 安裝 Ghostty...${NC}"
brew update
brew install --cask ghostty

echo -e "---------------------------------------"
echo -e "${GREEN}Ghostty 安裝完成！${NC}"
echo -e "${BLUE}提示：現在開啟 Ghostty 將會使用系統預設配置，不再有紅字報錯。${NC}"