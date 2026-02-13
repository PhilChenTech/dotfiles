#!/bin/bash

# 確保腳本在出錯時停止
set -e

echo "🐧 開始 macOS 純指令版 Docker 環境建置 (Colima)..."

# 1. 檢查並安裝 Homebrew
if ! command -v brew &> /dev/null; then
    echo "🔍 偵測到未安裝 Homebrew，正在為您安裝..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "✅ Homebrew 已安裝。"
fi

# 2. 安裝 Docker CLI 與 Colima (取代 Docker Desktop)
echo "📦 正在安裝 Docker CLI 與 Colima..."
brew install docker docker-compose colima

# 3. 啟動 Colima 服務
if ! colima status &> /dev/null; then
    echo "🚀 正在啟動 Colima 虛擬環境..."
    colima start
else
    echo "✅ Colima 服務已在執行中。"
fi

echo "------------------------------------------------"
echo "🎉 Docker CLI 環境已建置完成！"
echo "📍 指令確認："
echo "   docker version"
echo "   docker compose version"
echo "------------------------------------------------"
echo "💡 提示：以後重啟電腦後，只需執行 'colima start' 即可。"