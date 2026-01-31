#!/bin/bash

# Define the source directory (where this script is located)
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    else
        echo "unknown"
    fi
}

OS=$(detect_os)

# List of files to symlink
FILES=(
    ".zshrc"
    ".zprofile"
    ".functions"
    ".aliases"
    ".zprompt"
    ".shared_prompt"
)

echo "🚀 Starting Dotfiles Installation..."
echo "💻 OS Detected: $OS"
echo "📂 Source: $REPO_DIR"
echo "📦 Backup: $BACKUP_DIR"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Install zsh if missing
if ! command -v zsh &> /dev/null; then
    echo "🐚 zsh not found. Installing..."
    if [[ "$OS" == "macos" ]]; then
        if command -v brew &> /dev/null; then
            brew install zsh
        fi
    elif [[ "$OS" == "linux" ]]; then
        if command -v apt-get &> /dev/null; then
            sudo apt-get update && sudo apt-get install -y zsh
        elif command -v yum &> /dev/null; then
            sudo yum install -y zsh
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y zsh
        fi
    fi
fi

# Install fzf if missing
if ! command -v fzf &> /dev/null; then
    echo "🔍 fzf not found. Installing..."
    if [[ "$OS" == "macos" ]]; then
        if command -v brew &> /dev/null; then
            brew install fzf
        else
            echo "⚠️  Homebrew not found. Installing fzf manually..."
            git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
            ~/.fzf/install --all
        fi
    elif [[ "$OS" == "linux" ]]; then
        if command -v apt-get &> /dev/null; then
            sudo apt-get install -y fzf
        elif command -v yum &> /dev/null; then
            sudo yum install -y fzf
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y fzf
        else
            echo "⚠️  Package manager not found. Installing fzf manually..."
            git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
            ~/.fzf/install --all
        fi
    fi
fi

# Loop through files and create symlinks
for file in "${FILES[@]}"; do
    SOURCE_FILE="$REPO_DIR/$file"
    TARGET_FILE="$HOME/$file"

    if [ -f "$TARGET_FILE" ] || [ -L "$TARGET_FILE" ]; then
        echo "   ↪️  Backing up existing $file..."
        mv "$TARGET_FILE" "$BACKUP_DIR/"
    fi

    echo "   🔗 Linking $file..."
    ln -sf "$SOURCE_FILE" "$TARGET_FILE"
done

# Set zsh as default shell if not already
if [[ "$SHELL" != */zsh ]]; then
    echo "🐚 Setting zsh as default shell..."
    if command -v zsh &> /dev/null; then
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
if [[ "$SHELL" == */zsh ]]; then
    source ~/.zshrc 2>/dev/null || echo "   (Please run 'source ~/.zshrc' or restart your terminal)"
else
    echo "   (Please restart your terminal or run 'zsh' to start using zsh)"
fi
