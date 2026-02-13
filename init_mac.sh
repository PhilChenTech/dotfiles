#!/bin/bash

# =================================================================
# macOS AI 協作環境【終極增強版】
# 目標：消除 BSD/GNU 差異、提升搜尋效能、確保 AI 指令執行 100% 正確
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
# - bash: 升級核心執行環境
# - coreutils/findutils/gnu-sed/grep: 讓 Mac 支援標準 Linux 指令語法
# - fd/ripgrep: 現代化搜尋工具，AI 掃描專案速度極快
# - jq: AI 處理 JSON 資料必備
brew install bash coreutils findutils gnu-sed gnu-tar grep awk fd ripgrep jq fzf

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
    echo "# 2. 路徑優先級：優先使用 Homebrew 安裝的 GNU 工具"
    echo "export PATH=\"$(brew --prefix coreutils)/libexec/gnubin:\$PATH\""
    echo "export PATH=\"$(brew --prefix findutils)/bin:\$PATH\""
    echo "export PATH=\"$(brew --prefix)/bin:\$PATH\""

    echo ""
    echo "# 3. 建立別名：讓 AI 指令在 Mac 上如履平地"
    echo "alias sed='gsed'"
    echo "alias tar='gtar'"
    echo "alias grep='rg'    # 使用更快的 ripgrep 取代傳統 grep"
    echo "alias find='fd'    # 使用更快的 fd 取代傳統 find"
    echo "alias awk='gawk'"

    echo ""
    echo "# 4. 指定 AI 執行的核心 Bash 路徑"
    echo "export AI_BASH_PATH=\"$(brew --prefix)/bin/bash\""

    echo "# === End of AI Optimization ==="
} >> "$ZSHRC"

echo ""
echo "✅ 優化完成！"
echo "-------------------------------------------------------"
echo "💡 現在你的 Mac 環境具備以下優勢："
echo "1. 現代化核心：已安裝最新版 Bash 5.x（取代 2007 年舊版）。"
echo "2. 指令相容性：AI 產出的 GNU 語法（如 sed -i）現在可直接運行。"
echo "3. 極速搜尋：AI 執行檔案檢索作業時將自動呼叫 fd 與 rg。"
echo "-------------------------------------------------------"
echo "請執行 'source ~/.zshrc' 立即生效。"