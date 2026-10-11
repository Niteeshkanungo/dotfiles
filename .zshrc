# ~/.zshrc — interactive shell setup for macOS (zsh).
# Env/PATH canonical home is ~/.zprofile; this file covers interactive shells
# (including non-login ones like tmux panes and editor terminals).

# --- Homebrew prefix (Apple Silicon: /opt/homebrew, Intel: /usr/local) ---
if [ -x /opt/homebrew/bin/brew ]; then
    HOMEBREW_PREFIX="/opt/homebrew"
elif [ -x /usr/local/bin/brew ]; then
    HOMEBREW_PREFIX="/usr/local"
else
    HOMEBREW_PREFIX="/opt/homebrew"
fi

# --- Zsh completion system ---
# Always enable built-in completion; use brew zsh-completions if present.
if [ -d "$HOMEBREW_PREFIX/share/zsh-completions" ]; then
  FPATH="$HOMEBREW_PREFIX/share/zsh-completions:$FPATH"
fi
autoload -Uz compinit
# -u suppresses "insecure directories" warnings (common on macOS)
compinit -u
mkdir -p "$HOME/.zcompcache" 2>/dev/null

# --- Completion tuning (menu, grouping, typo tolerance) ---
unset LISTMAX 2>/dev/null; export LISTMAX=0
setopt AUTO_MENU MENU_COMPLETE
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:options' format ' options'
zstyle ':completion:*' menu select
zstyle ':completion:*' verbose yes
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zcompcache"
zstyle ':completion:*' special-dirs true
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*' group-order commands aliases functions builtins parameters options arguments files
zstyle ':completion:*:approximate:*' max-errors 2
bindkey '^[[Z' reverse-menu-complete

# --- Zsh autosuggestions (needs: brew install zsh-autosuggestions) ---
if [ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    # Config to make it visible and robust
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=cyan"
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi

# --- Zsh syntax highlighting, last of the plugins (needs: brew install zsh-syntax-highlighting) ---
if [ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# --- Prompt / aliases / functions / secrets ---
autoload -Uz colors && colors
setopt PROMPT_SUBST

# Fallback for non-login shells (login shells get these from ~/.zprofile)
: "${LANG:=en_US.UTF-8}"
: "${EDITOR:=nano}"
export LANG EDITOR
export VISUAL="$EDITOR"
export CLICOLOR=1

# Don't ask if user is sure when running rm with wildcards (like bash)
setopt rmstarsilent

# If a wildcard pattern has no matches, return an empty string (like bash)
setopt no_nomatch

# Gentle spelling correction for commands (not correctall: too aggressive)
setopt correct

# Specify the history file and its sizes
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

# These options improve history behavior across sessions
setopt SHARE_HISTORY          # Share command history across all open sessions
setopt APPEND_HISTORY         # Append history rather than overwriting it
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks from each command line being added to the history list
setopt HIST_IGNORE_SPACE      # Ignore commands that start with a space (for secret or experimental commands)
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicates first when trimming history

# Load dotfiles (prompt, aliases, functions, secrets):
for file in ~/.{zprompt,aliases,functions,private}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Adaptive command learning (optional, local only)
[ -f ~/.zsh_learning.zsh ] && source ~/.zsh_learning.zsh

# PATH mirror of ~/.zprofile for non-login shells (idempotent: skips dups)
for _p in "/Library/Developer/CommandLineTools/usr/bin" \
          "$HOME/.local/bin" \
          "$HOME/.opencode/bin" \
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

# Modified to exclude forward slash for better path component deletion
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
