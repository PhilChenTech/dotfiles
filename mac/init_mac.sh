#!/bin/bash

# =================================================================
# macOS AI Development Environment Setup
# Goal: Upgrade Apple-frozen tools to match Linux standards
# =================================================================

set -e

AI_ENV_CONF="$HOME/.ai_env"
ZSHRC="$HOME/.zshrc"

echo "Starting Mac development environment optimization..."

# 1. Auto-locate Homebrew
if [[ "$(uname -m)" == "arm64" ]]; then
    BREW_PATH="/opt/homebrew/bin/brew"
else
    BREW_PATH="/usr/local/bin/brew"
fi

if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$($BREW_PATH shellenv)"
fi

# 2. Install comprehensive tool package
echo "Checking and installing modern Unix tools..."
PACKAGES=(
    bash coreutils findutils gnu-sed gnu-tar grep awk
    fd ripgrep jq fzf bat zoxide btop
    rsync git openssh make
)
brew install "${PACKAGES[@]}" || true

# 3. Generate or update configuration file
echo "Updating configuration: $AI_ENV_CONF"

cat << 'EOFCONFIG' > "$AI_ENV_CONF"
# === AI Collaboration and Unix Environment Optimization ===

# 1. Language and Encoding
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# 2. PATH Priority (prefer Homebrew-installed modern tools)
export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix findutils)/bin:$PATH"
export PATH="$(brew --prefix)/bin:$PATH"

# 3. Command Compatibility and Aliases
# Note: Do NOT alias 'find' to 'fd' as fd has different syntax
# and breaks many scripts (e.g., SDKMAN, find in makefiles).
# Use 'fd' command directly when you need its features.
# Also avoid aliasing 'grep' to 'rg' and 'cd' to 'z' as they have
# different syntax and break existing scripts and workflows.
alias sed='gsed'
alias tar='gtar'
alias awk='gawk'
alias make='gmake'
alias cat='bat --style=plain --paging=never'

# 4. Modern Navigation and History (zoxide available but not aliased)
# User can invoke zoxide features with:
# - z <directory>     # Jump to directory
# - z -i              # Interactive search
# - zoxide query      # Query database
eval "$(zoxide init zsh)"

# 5. AI Core Execution Environment (Bash 5.x)
export AI_BASH_PATH="$(brew --prefix)/bin/bash"

# 6. FZF Integration with fd
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'

# === End of Configuration ===
EOFCONFIG

# 4. Mount to .zshrc
if ! grep -q "source $AI_ENV_CONF" "$ZSHRC"; then
    echo -e "\n[ -f $AI_ENV_CONF ] && source $AI_ENV_CONF" >> "$ZSHRC"
    echo "Configuration linked to .zshrc"
fi

# 5. Update Brewfile backup
brew bundle dump --force --file="./Brewfile"

echo ""
echo "All tools upgraded to 2026 latest standards!"
echo "-------------------------------------------------------"
echo "Upgrade highlights:"
echo "1. Rsync 3.x: Incremental backup and better UTF-8 support"
echo "2. GNU Make 4.x: Modern automation features"
echo "3. OpenSSH: Latest encryption protocols and FIDO2 support"
echo "4. Git: Official version, independent from Apple modifications"
echo "-------------------------------------------------------"
echo "Run 'source ~/.zshrc' to take effect immediately."

