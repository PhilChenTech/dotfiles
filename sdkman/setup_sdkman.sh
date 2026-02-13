#!/bin/bash

# 顏色設定
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "${BLUE}開始配置 SDKMAN! 開發環境...${NC}"

# 1. 檢查並安裝必要的依賴 (zip, unzip)
if ! command -v zip &> /dev/null || ! command -v unzip &> /dev/null; then
    echo "正在透過 Homebrew 安裝 zip/unzip 依賴..."
    brew install zip unzip
fi

# 2. 安裝 SDKMAN! (如果尚未安裝)
if [ ! -d "$HOME/.sdkman" ]; then
    echo "正在從官網下載並安裝 SDKMAN!..."
    curl -s "https://get.sdkman.io" | bash
else
    echo -e "${GREEN}SDKMAN! 已經安裝在 $HOME/.sdkman${NC}"
fi

# 3. 配置環境變數 (自動寫入 .zshrc)
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
        echo -e "${GREEN}環境變數已成功寫入！${NC}"
    else
        echo -e "${GREEN}SDKMAN 設定已存在於 $SHELL_CONFIG${NC}"
    fi
fi

# 4. 立即為當前 Shell 生效
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# 5. 驗證並安裝常用的 SDK (可選)
echo -e "${BLUE}驗證安裝結果：${NC}"
if command -v sdk &> /dev/null; then
    echo -e "${GREEN}成功！SDKMAN 版本: $(sdk version)${NC}"

    # 範例：自動安裝最新的 Java (LTS)
    # echo "正在預先安裝 Java 21 (LTS)..."
    # sdk install java 21-tem
else
    echo -e "${YELLOW}警告：sdk 指令尚未生效，請手動執行 'source ~/.zshrc' 或重啟終端機。${NC}"
fi

echo -e "${GREEN}=== SDKMAN 配置完成！ ===${NC}"