#!/bin/bash

# --- 顏色設定 ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}==> 開始安裝 FileZilla 流程...${NC}"

# 1. 檢查 Homebrew 是否已安裝
if ! command -v brew &> /dev/null; then
    echo -e "${BLUE}==> 未偵測到 Homebrew，正在安裝...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # 設定環境變數 (自動判斷 M 系列晶片或 Intel)
    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo -e "${GREEN}==> Homebrew 已存在。${NC}"
fi

# 2. 更新 Homebrew 數據庫
echo -e "${BLUE}==> 正在更新 Homebrew...${NC}"
brew update

# 3. 安裝 FileZilla
echo -e "${BLUE}==> 正在安裝 FileZilla...${NC}"
if brew list --cask filezilla &> /dev/null; then
    echo -e "${GREEN}==> FileZilla 已經安裝過了。${NC}"
else
    brew install --cask filezilla
    echo -e "${GREEN}==> FileZilla 安裝完成！${NC}"
fi

echo -e "${BLUE}==> 您可以在「應用程式」中啟動 FileZilla。${NC}"