# ~/.zprofile — login-shell environment for macOS (zsh).
#
# Standard layout:
#   .zprofile   → environment variables + PATH (this file, login shells)
#   .zshrc      → interactive shell setup (sources .aliases / .functions / .zprompt)
#   .aliases    → aliases (loaded for every interactive shell)
#   .functions  → shell functions (loaded for every interactive shell)
#
# Keep this file to environment only. Aliases/functions live in ~/.aliases
# and ~/.functions so they also work in non-login shells (tmux, editors).

# --- Homebrew (Apple Silicon: /opt/homebrew, Intel: /usr/local) ---
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# --- Standard environment ---
export LANG="${LANG:-en_US.UTF-8}"
export EDITOR="${EDITOR:-nano}"
export VISUAL="$EDITOR"
export CLICOLOR=1
export BLOCKSIZE=1k

# --- PATH additions (guarded against duplicates; safe to source twice) ---
for _p in "$HOME/.local/bin" \
          "/Applications/Ollama.app/Contents/Resources" \
          "$HOME/.antigravity/antigravity/bin" \
          "$HOME/.antigravity-ide/antigravity-ide/bin"; do
    if [ -d "$_p" ]; then
        case ":$PATH:" in
            *":$_p:"*) ;;
            *) PATH="$_p:$PATH" ;;
        esac
    fi
done
unset _p
export PATH
