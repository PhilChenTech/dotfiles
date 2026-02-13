#!/bin/bash

# 1. 初始化 SDKMAN! 環境
export SDKMAN_DIR="$HOME/.sdkman"
if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
else
    echo "❌ 找不到 SDKMAN!，請確認安裝路徑。"
    exit 1
fi

echo "🔍 正在搜尋 Amazon Corretto 的最新 LTS 版本..."

# 2. 篩選邏輯：
# sdk list java 輸出會包含版本號與廠商
# 我們過濾出 amzn，且版本號開頭為目前公認的 LTS (25, 21, 17, 11, 8)
# 取其中最新的那一筆
LATEST_LTS_AWS=$(sdk list java | grep "amzn" | grep -E "^\s+(25|21|17|11|8)\." | head -n 1 | awk '{print $NF}')

if [ -z "$LATEST_LTS_AWS" ]; then
    echo "⚠️ 無法自動偵測 LTS 版本，改為嘗試抓取最新版 amzn..."
    LATEST_LTS_AWS=$(sdk list java | grep "amzn" | head -n 1 | awk '{print $NF}')
fi

echo "✅ 偵測到最新 AWS LTS 版本: $LATEST_LTS_AWS"

# 3. 檢查本地是否已安裝
if [[ ! -d "$SDKMAN_DIR/candidates/java/$LATEST_LTS_AWS" ]]; then
    echo "📥 尚未安裝，正在安裝 $LATEST_LTS_AWS..."
    sdk install java "$LATEST_LTS_AWS"
fi

# 4. 執行切換並設為預設
sdk use java "$LATEST_LTS_AWS"
sdk default java "$LATEST_LTS_AWS"

echo "-------------------------------------------"
echo "🚀 Java 環境已就緒！"
java -version