#!/bin/bash

# --- 顏色定義 ---
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${BLUE}開始安裝 Raycast...${NC}"

# 1. 檢查並安裝 Homebrew (如果尚未安裝)
if ! command -v brew &> /dev/null; then
    echo "正在安裝 Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 2. 執行 Raycast 安裝
echo -e "${GREEN}正在透過 Homebrew 安裝 Raycast...${NC}"
brew install --cask raycast

echo -e "---------------------------------------"
echo -e "${GREEN}Raycast 安裝完成！${NC}"
echo -e "${BLUE}你現在可以從應用程式資料夾開啟 Raycast，或是按下 Command + Space 啟動它。${NC}"