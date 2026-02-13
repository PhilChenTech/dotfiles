#!/bin/bash

# 1. 初始化 SDKMAN! 環境
export SDKMAN_DIR="$HOME/.sdkman"
if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
    source "$SDKMAN_DIR/bin/sdkman-init.sh"
else
    echo "❌ 找不到 SDKMAN!，請先執行 SDKMAN 安裝腳本。"
    exit 1
fi

echo "🔍 正在搜尋最新的 Gradle 穩定版本..."

# 2. 改良版抓取邏輯：過濾掉橫線、空白，並取第一筆純數字版本號
LATEST_GRADLE=$(sdk list gradle | grep -E '[0-9]+\.[0-9]+' | awk '{print $1}' | grep -E '^[0-9]' | head -n 1)

# 如果還是抓不到，就直接執行預設安裝 (SDKMAN 會自動選最新穩定版)
if [ -z "$LATEST_GRADLE" ]; then
    echo "⚠️ 無法解析版本號，執行 sdk install gradle (預設最新版)..."
    sdk install gradle
else
    echo "✅ 偵測到最新版本: $LATEST_GRADLE"
    if [[ ! -d "$SDKMAN_DIR/candidates/gradle/$LATEST_GRADLE" ]]; then
        sdk install gradle "$LATEST_GRADLE"
    else
        echo "😊 Gradle $LATEST_GRADLE 已經安裝過了。"
    fi
    sdk default gradle "$LATEST_GRADLE"
fi

# 3. 優化 Gradle 全域配置
GRADLE_USER_HOME="$HOME/.gradle"
mkdir -p "$GRADLE_USER_HOME"

echo "🛠 正在設定 Gradle 全域優化配置..."
cat << 'EOF' > "$GRADLE_USER_HOME/gradle.properties"
org.gradle.daemon=true
org.gradle.parallel=true
org.gradle.caching=true
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
EOF

echo "🚀 Gradle 配置完成！"
gradle --version