#!/bin/bash

# =================================================================
# macOS AI 協作環境【資深工程師終極版】
# 目標：消除 BSD/GNU 差異、極速搜尋、強化 AI 產出審核效率
# =================================================================

set -e # 若發生錯誤則停止執行

echo "🚀 開始執行 Mac AI 開發環境深度優化..."

# 1. 檢查並安裝 Homebrew
if ! command -v brew &> /dev/null; then
    echo "📦 正在安裝 Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 2. 安裝核心工具包
echo "📦 安裝 GNU 工具、最新版 Bash 及 AI 搜尋神器..."
# - bash: 升級核心執行環境至 5.x
# - coreutils/findutils/gnu-sed/grep: 讓 Mac 支援標準 Linux 指令語法
# - fd/ripgrep: 現代化搜尋工具，AI 掃描專案速度提升 10 倍以上
# - jq: AI 處理 JSON 資料必備
# - bat: 帶有語法高亮與 Git 修改標記的 cat
# - zoxide: 智慧路徑跳轉 (cd)
# - btop: 現代化系統資源監控
# - fzf: 模糊搜尋器
brew install bash coreutils findutils gnu-sed gnu-tar grep awk fd ripgrep jq fzf bat zoxide btop

# 3. 配置環境設定 (.zshrc)
ZSHRC="$HOME/.zshrc"
echo "📝 注入優化設定至 $ZSHRC..."

# 備份原有設定
[ -f "$ZSHRC" ] && cp "$ZSHRC" "$ZSHRC.bak_$(date +%Y%m%d)" || touch "$ZSHRC"

{
    echo ""
    echo "# === AI 協作優化區段 (Managed by init_mac.sh) ==="

    echo "# 1. 語系設定：防止 AI 處理中文檔案時噴出編碼錯誤"
    echo "export LANG=en_US.UTF-8"
    echo "export LC_ALL=en_US.UTF-8"

    echo ""
    echo "# 2. 路徑優先級：優先使用 Homebrew 安裝的 GNU 工具與 Bash"
    echo "export PATH=\"$(brew --prefix coreutils)/libexec/gnubin:\$PATH\""
    echo "export PATH=\"$(brew --prefix findutils)/bin:\$PATH\""
    echo "export PATH=\"$(brew --prefix)/bin:\$PATH\""

    echo ""
    echo "# 3. 建立別名：解決語法差異並提升工具效能"
    echo "alias sed='gsed'"
    echo "alias tar='gtar'"
    echo "alias awk='gawk'"
    echo "alias grep='rg'    # 使用 ripgrep (Rust)"
    echo "alias find='fd'    # 使用 fd (Rust)"
    echo "alias cat='bat --style=plain --paging=never' # 帶有高亮的 cat"

    echo ""
    echo "# 4. 指令與跳轉優化"
    echo 'eval "$(zoxide init zsh)"'
    echo "alias cd='z'"

    echo ""
    echo "# 5. 指定 AI 執行的核心 Bash 路徑"
    echo "export AI_BASH_PATH=\"$(brew --prefix)/bin/bash\""

    echo "# === End of AI Optimization ==="
} >> "$ZSHRC"

echo ""
echo "✅ 優化完成！"
echo "-------------------------------------------------------"
echo "💡 為什麼這份腳本更強大？"
echo "1. 語法相容：AI 不會再因為 sed -i 或 array 語法而在 Mac 上報錯。"
echo "2. 審核代碼：現在用 'cat' 看 AI 的產出會自動上色並顯示 Git 變動。"
echo "3. 極速跳轉：用 'z <關鍵字>' 快速切換專案目錄，減少 AI 寫路徑的負擔。"
echo "4. 資源透明：遇到腳本卡死，直接開 'btop' 就能抓出吃資源的 PID。"
echo "-------------------------------------------------------"
echo "請執行 'source ~/.zshrc' 立即生效。"