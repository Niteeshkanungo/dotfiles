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

# --- Zsh completion system (needs: brew install zsh-completions) ---
if [ -d "$HOMEBREW_PREFIX/share/zsh-completions" ]; then
  # Add zsh-completions to fpath
  FPATH="$HOMEBREW_PREFIX/share/zsh-completions:$FPATH"

  autoload -Uz compinit
  # -u suppresses "insecure directories" warnings (common on macOS)
  compinit -u
fi

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
bindkey -e '^[[Z' reverse-menu-complete
bindkey "^I" complete-word
bindkey "^[[Z" complete-word

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

# yt_init project_name # create ./project_name, set it up, but stay where you are
yt_init() {
  local template="$HOME/dotfiles/prompts/AGENTS.md"
  local template_dir="$HOME/My_Drive/YouTube/Youtube-Tutorial-Template"
  local gitignore_stack="${GITIGNORE_STACK:-python,macos,visualstudiocode,dotenv}"
  local gitignore_url="https://www.toptal.com/developers/gitignore/api/${gitignore_stack}"
  local orig="$PWD"
  local target="."
  local dir

  if [[ $# -eq 1 ]]; then
    target="$1"

    # Check if target directory exists and is not empty
    if [[ -d "$target" ]] && [[ -n "$(ls -A "$target" 2>/dev/null)" ]]; then
      echo "❌ Error: Directory '$target' already exists and is not empty."
      echo "   Please use an empty directory or remove existing contents."
      return 1
    fi

    uv init "$target" || return     # keep uv's error behavior
  elif [[ $# -eq 0 ]]; then

    # Check if current directory is not empty
    if [[ -n "$(ls -A . 2>/dev/null)" ]]; then
      echo "❌ Error: Current directory is not empty."
      echo "   Please run yt_init from an empty directory or specify a new directory name."
      return 1
    fi

    uv init || return
  else
    echo "Usage: yt_init [project_name]"
    return 1
  fi

  dir="$orig"; [[ "$target" == "." ]] || dir="$orig/$target"

  # .gitignore (overwrite with your preferred stack)
  if command -v curl >/dev/null; then
    curl -fsSL "$gitignore_url" -o "$dir/.gitignore" \
      || echo "⚠️  Could not fetch .gitignore; keeping uv's default."
  else
    echo "⚠️  curl not found; keeping uv's default .gitignore."
  fi

  # Copilot instructions + empty sandbox files
  mkdir -p "$dir/.github"
  mkdir -p "$dir/.claude/commands"
  mkdir -p "$dir/reference-examples"
  : > "$dir/s.txt"
  : > "$dir/sandbox.txt"
  : > "$dir/sandbox.py"
  : > "$dir/snippets.txt"

  # Create virtual environment (run from project root)
  ( cd "$dir" && uv venv ) || return

  # Initial commit (assumes brand-new repo with no commits)
  if command -v git >/dev/null; then
    git -C "$dir" add -A
    if git -C "$dir" commit -m "Initial Commit"; then
      echo "✅ Created initial Git commit."
    else
      echo "ℹ️  Git commit skipped/failed (possibly re-ran yt_init or git not configured)."
    fi
  else
    echo "⚠️  git not found; skipping initial commit."
  fi

  echo "✅ Project ready at $dir"
}

# Modified to exclude forward slash for better path component deletion
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
