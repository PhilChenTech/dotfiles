#!/bin/bash

# --- 顏色設定 ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # 無顏色

echo -e "${BLUE}==> 開始安裝 Termius 流程...${NC}"

# 1. 檢查是否安裝了 Homebrew
if ! command -v brew &> /dev/null; then
    echo -e "${BLUE}==> 未偵測到 Homebrew，正在為您安裝...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # 針對 Apple Silicon (M1/M2/M3) 或 Intel Mac 設定環境變數
    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo -e "${GREEN}==> Homebrew 已存在，跳過安裝。${NC}"
fi

# 2. 更新 Brew 數據庫
echo -e "${BLUE}==> 正在更新 Homebrew...${NC}"
brew update

# 3. 安裝 Termius (使用 Cask 安裝 GUI 軟體)
echo -e "${BLUE}==> 正在安裝 Termius...${NC}"
if brew list --cask termius &> /dev/null; then
    echo -e "${GREEN}==> Termius 已經安裝過了。${NC}"
else
    brew install --cask termius
    echo -e "${GREEN}==> Termius 安裝完成！${NC}"
fi

echo -e "${BLUE}==> 您可以在「應用程式」資料夾中找到 Termius，或直接在 Spotlight 搜尋。${NC}"