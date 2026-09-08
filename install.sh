#!/bin/bash
# Dotfiles installer for macOS.
set -u

# Define the source directory (where this script is located)
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d_%H%M%S)"

if [[ "${OSTYPE:-}" != "darwin"* ]]; then
    echo "Error: this dotfiles setup supports macOS only (OSTYPE=${OSTYPE:-unknown})." >&2
    exit 1
fi

# Files to symlink into $HOME
FILES=(
    ".zshrc"
    ".zprofile"
    ".functions"
    ".aliases"
    ".zprompt"
    ".shared_prompt"
    ".zsh_learning.zsh"
)

# Homebrew packages required by .zshrc (completion, suggestions, highlighting, fzf)
BREW_PACKAGES=(
    "zsh"
    "zsh-completions"
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
    "fzf"
)

echo "🚀 Starting Dotfiles Installation (macOS)..."
echo "📂 Source: $REPO_DIR"
echo "📦 Backup: $BACKUP_DIR"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Xcode Command Line Tools are required for Homebrew and git
if ! xcode-select -p >/dev/null 2>&1; then
    echo "❌ Xcode Command Line Tools not found." >&2
    echo "   Install with: xcode-select --install" >&2
    echo "   Then re-run this script." >&2
    exit 1
fi

# Homebrew is required
if ! command -v brew >/dev/null 2>&1; then
    echo "❌ Homebrew not found." >&2
    echo "   Install from https://brew.sh then re-run this script." >&2
    exit 1
fi

# zsh should already exist on macOS; prefer Homebrew zsh when available
if ! command -v zsh >/dev/null 2>&1; then
    echo "🐚 zsh not found. Installing..."
    brew install zsh
fi

# Install missing Homebrew dependencies (skip what is already present)
for pkg in "${BREW_PACKAGES[@]}"; do
    if brew list --formula "$pkg" >/dev/null 2>&1; then
        echo "   ✅ $pkg already installed, skipping."
    else
        echo "   📦 Installing $pkg..."
        brew install "$pkg"
    fi
done

# Loop through files and create symlinks
for file in "${FILES[@]}"; do
    SOURCE_FILE="$REPO_DIR/$file"
    TARGET_FILE="$HOME/$file"

    if [ ! -e "$SOURCE_FILE" ]; then
        echo "   ⚠️  Skipping $file (not found in repo)."
        continue
    fi

    if [ -f "$TARGET_FILE" ] || [ -L "$TARGET_FILE" ]; then
        echo "   ↪️  Backing up existing $file..."
        mv "$TARGET_FILE" "$BACKUP_DIR/"
    fi

    echo "   🔗 Linking $file..."
    ln -sf "$SOURCE_FILE" "$TARGET_FILE"
done

# Secrets template
if [ ! -f "$HOME/.private" ]; then
    echo ""
    echo "   ℹ️  No ~/.private found. To store secrets (API keys, tokens):"
    echo "      cp \"$REPO_DIR/.private.example\" ~/.private && chmod 600 ~/.private"
fi

# Set zsh as default shell if not already
if [[ "${SHELL:-}" != */zsh ]]; then
    echo "🐚 Setting zsh as default shell..."
    if command -v zsh >/dev/null 2>&1; then
        ZSH_PATH=$(command -v zsh)
        # Add zsh to /etc/shells if not present
        if ! grep -q "$ZSH_PATH" /etc/shells 2>/dev/null; then
            echo "$ZSH_PATH" | sudo tee -a /etc/shells > /dev/null
        fi
        chsh -s "$ZSH_PATH" 2>/dev/null || echo "   ⚠️  Could not change shell automatically. Run: chsh -s $(command -v zsh)"
    fi
fi

echo ""
echo "✅ Installation Complete!"
echo "🔄 Reloading zsh configuration..."
# Try to source if running interactively, otherwise just tell user
if [[ "${SHELL:-}" == */zsh ]]; then
    # shellcheck disable=SC1090
    source ~/.zshrc 2>/dev/null || echo "   (Please run 'source ~/.zshrc' or restart your terminal)"
else
    echo "   (Please restart your terminal or run 'zsh' to start using zsh)"
fi
