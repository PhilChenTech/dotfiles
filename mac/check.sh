#!/bin/bash

echo "📋 環境診斷中..."
echo "---"
printf "Bash 版本: "; bash --version | head -n 1
printf "Sed 版本:  "; sed --version | head -n 1
printf "Rsync 版本: "; rsync --version | head -n 1
printf "Zoxide:    "; command -v z >/dev/null && echo "✅ OK" || echo "❌ 失敗"
printf "Ripgrep:   "; rg --version | head -n 1
printf "Fd:        "; fd --version | head -n 1
echo "---"
echo "✅ 如果以上都顯示 GNU 或現代版本，你的 AI 開發環境已達 120 分！"