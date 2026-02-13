#!/bin/bash

# =================================================================
# macOS AI 開發環境設置
# 目標: 升級 Apple 內置工具，與 Linux 標準保持一致
# =================================================================

set -e

AI_ENV_CONF="$HOME/.ai_env"
ZSHRC="$HOME/.zshrc"

echo "開始 Mac 開發環境優化..."

# 1. 自動檢測 Homebrew 位置
if [[ "$(uname -m)" == "arm64" ]]; then
    BREW_PATH="/opt/homebrew/bin/brew"
else
    BREW_PATH="/usr/local/bin/brew"
fi

if ! command -v brew &> /dev/null; then
    echo "安裝 Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$($BREW_PATH shellenv)"
fi

# 2. 安裝全面的工具套件
echo "檢查並安裝現代化的 Unix 工具..."
PACKAGES=(
    bash coreutils findutils gnu-sed gnu-tar grep awk
    fd ripgrep jq fzf bat zoxide btop
    rsync git openssh make
)
brew install "${PACKAGES[@]}" || true

# 3. 生成或更新配置文件
echo "更新配置: $AI_ENV_CONF"

cat << 'EOFCONFIG' > "$AI_ENV_CONF"
# === AI 協作與 Unix 環境優化 ===

# 1. 語言和編碼設置
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# 2. PATH 優先級 (優先使用 Homebrew 安裝的現代工具)
# 使用 PATH 優先級優於 alias 的原因:
# - 在腳本、cron job、遠程執行中都能工作
# - 對所有工具完全透明
# - 沒有除錯混亂
export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix findutils)/bin:$PATH"
export PATH="$(brew --prefix gnu-sed)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix gnu-tar)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix gawk)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix make)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix)/bin:$PATH"

# 3. 命令增強 (僅用於功能增強，不用於工具替換)
# 注意: 不要使用 alias 進行工具替換 (grep->rg, cd->z, sed->gsed)
# 改為使用 PATH 優先級 - 它在任何地方都能工作 (腳本, cron, 遠程等)
# 只在不破壞腳本的情況下使用 alias 進行功能增強
alias cat='bat --style=plain --paging=never'
alias ac='btop'  # 系統監控別名

# 4. 現代化導航和歷史 (zoxide 可用但不作為別名)
# 用戶可以通過以下方式調用 zoxide 功能:
# - z <目錄>         # 跳轉到目錄
# - z -i             # 互動搜索
# - zoxide query     # 查詢數據庫
eval "$(zoxide init zsh)"

# 5. AI 核心執行環境 (Bash 5.x)
export AI_BASH_PATH="$(brew --prefix)/bin/bash"

# 6. FZF 與 fd 集成
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'

# === 配置結束 ===
EOFCONFIG

# 4. 掛載到 .zshrc
if ! grep -q "source $AI_ENV_CONF" "$ZSHRC"; then
    echo -e "\n[ -f $AI_ENV_CONF ] && source $AI_ENV_CONF" >> "$ZSHRC"
    echo "配置已連結到 .zshrc"
fi

# 5. 更新 Brewfile 備份
brew bundle dump --force --file="./Brewfile"

echo ""
echo "所有工具已升級到 2026 最新標準!"
echo "-------------------------------------------------------"
echo "升級亮點:"
echo "1. Rsync 3.x: 增量備份和更好的 UTF-8 支援"
echo "2. GNU Make 4.x: 現代化的自動化功能"
echo "3. OpenSSH: 最新的加密協議和 FIDO2 支援"
echo "4. Git: 官方版本，獨立於 Apple 修改"
echo "-------------------------------------------------------"
echo "執行 'source ~/.zshrc' 立即生效。"

