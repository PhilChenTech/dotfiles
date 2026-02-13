#!/bin/bash

# =================================================================
# macOS AI 協作環境【120 分終極增強版】
# 目標：全面升級被 Apple 凍結的工具，打造與 Linux 高度一致的開發環境
# =================================================================

set -e

AI_ENV_CONF="$HOME/.ai_env"
ZSHRC="$HOME/.zshrc"

echo "🚀 開始執行 Mac 開發環境深度優化 (全工具升級版)..."

# 1. 自動定位 Homebrew
if [[ "$(uname -m)" == "arm64" ]]; then
    BREW_PATH="/opt/homebrew/bin/brew"
else
    BREW_PATH="/usr/local/bin/brew"
fi

if ! command -v brew &> /dev/null; then
    echo "📦 正在安裝 Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$($BREW_PATH shellenv)"
fi

# 2. 安裝全面升級工具包
echo "📦 檢查並安裝現代化 Unix 工具..."
# 加入了 rsync, git, openssh, make
PACKAGES=(
    bash coreutils findutils gnu-sed gnu-tar grep awk
    fd ripgrep jq fzf bat zoxide btop
    rsync git openssh make
)
brew install "${PACKAGES[@]}"

# 3. 生成或更新獨立設定檔
echo "📝 更新設定檔: $AI_ENV_CONF"

cat << EOF > "$AI_ENV_CONF"
# === AI 協作與 Unix 環境優化 (由 init_mac.sh 自動產生) ===

# 1. 語系與編碼
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# 2. 路徑優先序 (優先使用 Homebrew 安裝的現代工具)
export PATH="$(brew --prefix coreutils)/libexec/gnubin:\$PATH"
export PATH="$(brew --prefix findutils)/bin:\$PATH"
export PATH="$(brew --prefix)/bin:\$PATH"

# 3. 指令兼容性與別名 (Alias)
alias sed='gsed'
alias tar='gtar'
alias awk='gawk'
alias make='gmake'  # 使用現代 GNU Make (4.x+)
alias grep='rg'
alias find='fd'
alias cat='bat --style=plain --paging=never'
alias rsync='$(brew --prefix)/bin/rsync' # 強制使用 3.x 版本

# 4. 現代化跳轉與歷史
eval "\$(zoxide init zsh)"
alias cd='z'

# 5. 指定 AI 核心執行環境 (Bash 5.x)
export AI_BASH_PATH="$(brew --prefix)/bin/bash"

# 6. fzf 整合 fd
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="\$FZF_DEFAULT_COMMAND"

# === End of Configuration ===
EOF

# 4. 掛載到 .zshrc
if ! grep -q "source $AI_ENV_CONF" "$ZSHRC"; then
    echo -e "\n[ -f $AI_ENV_CONF ] && source $AI_ENV_CONF" >> "$ZSHRC"
    echo "🔗 已連結設定至 .zshrc"
fi

# 5. 更新 Brewfile 備份
brew bundle dump --force --file="./Brewfile"

echo ""
echo "✅ 全部工具已升級至 2026 年最新標準！"
echo "-------------------------------------------------------"
echo "🌟 本次額外升級亮點："
echo "1. Rsync 3.x: 支援增量備份與更好的中文檔名處理。"
echo "2. GNU Make 4.x: 支援更多現代自動化編譯特性。"
echo "3. OpenSSH: 獲取最新的加密協議與 FIDO2 支援。"
echo "4. Git: 使用官方原版，脫離 Apple 修改版的延遲更新。"
echo "-------------------------------------------------------"
echo "請執行 'source ~/.zshrc' 立即生效。"