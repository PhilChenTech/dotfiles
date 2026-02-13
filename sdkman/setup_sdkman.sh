#!/bin/bash

# 顏色設定
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'

DOTFILES_PATH="$HOME/IdeaProjects/dotfiles"

echo -e "${BLUE}開始配置 SDKMAN! 開發環境...${NC}"

# ========== 修復與優化區塊 ==========

# 1. 修正 dotfiles 中的拼字錯誤 (--ype -> --type)
echo -e "${BLUE}1. 檢查並修正 dotfiles 拼字錯誤...${NC}"
if [ -d "$DOTFILES_PATH" ]; then
    if grep -rl -- "--ype" "$DOTFILES_PATH" 2>/dev/null | grep -q .; then
        grep -rl -- "--ype" "$DOTFILES_PATH" 2>/dev/null | xargs sed -i '' 's/--ype/--type/g'
        echo -e "${GREEN}✅ 拼字修正完成。${NC}"
    else
        echo -e "${GREEN}✅ 未發現 --ype 拼字錯誤。${NC}"
    fi
fi

# ========== SDKMAN 安裝與配置 ==========

# 2. 檢查並安裝必要的依賴 (zip, unzip)
echo -e "${BLUE}2. 檢查依賴套件...${NC}"
if ! command -v zip &> /dev/null || ! command -v unzip &> /dev/null; then
    echo "正在透過 Homebrew 安裝 zip/unzip 依賴..."
    brew install zip unzip
else
    echo -e "${GREEN}✅ zip/unzip 已安裝${NC}"
fi

# 3. 安裝或重置 SDKMAN! 核心
echo -e "${BLUE}3. 安裝/重置 SDKMAN! 核心...${NC}"
export SDKMAN_DIR="$HOME/.sdkman"

if [ ! -d "$SDKMAN_DIR" ]; then
    echo "正在從官網下載並安裝 SDKMAN!..."
    curl -s "https://get.sdkman.io" | bash
    echo -e "${GREEN}✅ SDKMAN! 安裝完成${NC}"
else
    echo -e "${YELLOW}SDKMAN! 已存在，檢查核心完整性...${NC}"

    # 如果初始化檔案損壞或缺失，重新下載核心
    if [ ! -f "$SDKMAN_DIR/bin/sdkman-init.sh" ]; then
        echo -e "${YELLOW}偵測到核心檔案缺失，正在重置...${NC}"
        rm -f "$SDKMAN_DIR/bin/sdkman-init.sh"
        curl -s "https://get.sdkman.io" | bash
        echo -e "${GREEN}✅ SDKMAN! 核心已重置${NC}"
    else
        echo -e "${GREEN}✅ SDKMAN! 核心完整${NC}"
    fi
fi

# 4. 配置環境變數 (自動寫入 .zshrc)
echo -e "${BLUE}4. 配置環境變數...${NC}"
SHELL_CONFIG="$HOME/.zshrc"

if [ -f "$SHELL_CONFIG" ]; then
    # 檢查是否已經有 SDKMAN 的初始化代碼
    if ! grep -q "sdkman-init.sh" "$SHELL_CONFIG"; then
        echo -e "${YELLOW}正在將 SDKMAN 初始化腳本加入 $SHELL_CONFIG...${NC}"

        # 寫入 SDKMAN 必要的初始化區塊
        cat << 'EOF' >> "$SHELL_CONFIG"

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
EOF
        echo -e "${GREEN}✅ 環境變數已成功寫入${NC}"
    else
        echo -e "${GREEN}✅ SDKMAN 設定已存在於 $SHELL_CONFIG${NC}"
    fi
fi

# 5. 配置快捷鍵別名
echo -e "${BLUE}5. 配置快捷鍵別名...${NC}"
if ! grep -q "alias ac=" "$SHELL_CONFIG"; then
    echo "alias ac='btop'" >> "$SHELL_CONFIG"
    echo -e "${GREEN}✅ 已將 'ac' (btop) 加入快捷鍵${NC}"
else
    echo -e "${GREEN}✅ 'ac' 別名已存在${NC}"
fi

# 6. 立即為當前 Shell 生效
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# 7. 驗證安裝
echo -e "${BLUE}7. 驗證安裝結果：${NC}"
if command -v sdk &> /dev/null; then
    echo -e "${GREEN}✅ 成功！SDKMAN 版本: $(sdk version)${NC}"

    # 範例：自動安裝最新的 Java (LTS)
    # echo "正在預先安裝 Java 21 (LTS)..."
    # sdk install java 21-tem
else
    echo -e "${YELLOW}⚠️  警告：sdk 指令尚未生效，請手動執行 'source ~/.zshrc' 或重啟終端機。${NC}"
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✨ SDKMAN 配置完成！${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "${BLUE}請執行以下指令讓設定生效：${NC}"
echo -e "${YELLOW}source ~/.zshrc${NC}"
