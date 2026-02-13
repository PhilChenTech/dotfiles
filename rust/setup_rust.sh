#!/bin/bash

# 顏色設定
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "${BLUE}開始配置 Rust 開發環境 (含自動路徑設定)...${NC}"

# 1. 檢查並安裝 Homebrew
if ! command -v brew &> /dev/null; then
    echo "正在安裝 Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo -e "${GREEN}Homebrew 已安裝${NC}"
fi

# 2. 安裝 Rust (透過 rustup)
if ! command -v rustup &> /dev/null; then
    echo "正在安裝 Rust (rustup)..."
    # 使用 -y 參數進行無人值守安裝
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
else
    echo -e "${GREEN}Rust 已安裝，嘗試更新工具鏈...${NC}"
    rustup update
fi

# 3. 配置環境變數 (自動寫入 .zshrc 或 .bash_profile)
SHELL_CONFIG=""
if [ -n "$ZSH_VERSION" ] || [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -f "$HOME/.bash_profile" ]; then
    SHELL_CONFIG="$HOME/.bash_profile"
fi

if [ -n "$SHELL_CONFIG" ]; then
    if ! grep -q ".cargo/bin" "$SHELL_CONFIG"; then
        echo -e "${YELLOW}正在將 Rust 路徑加入 $SHELL_CONFIG...${NC}"
        echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> "$SHELL_CONFIG"
        echo -e "${GREEN}路徑已成功寫入！${NC}"
    else
        echo -e "${GREEN}路徑設定已存在於 $SHELL_CONFIG${NC}"
    fi
fi

# 4. 立即為當前 Shell 生效
source "$HOME/.cargo/env"

# 5. 驗證
echo -e "${BLUE}驗證安裝結果：${NC}"
if command -v cargo &> /dev/null; then
    echo -e "${GREEN}成功！Cargo 版本: $(cargo --version)${NC}"
else
    echo -e "${YELLOW}警告：cargo 指令仍未讀取，請手動執行 'source \$HOME/.cargo/env' 或重啟終端機。${NC}"
fi

echo -e "\n${BLUE}正在安裝開發插件 (bacon, cargo-edit)...${NC}"
cargo install bacon cargo-edit

echo -e "${GREEN}=== 全部搞定！請重新啟動終端機來享受 Rust 開發 ===${NC}"