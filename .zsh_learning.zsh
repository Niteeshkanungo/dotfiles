# ~/.zsh_learning.zsh - Adaptive learning system (macOS zsh, local only)

# Only run in interactive shells.
[[ -o interactive ]] || return 0

# Learning database paths
export ZSH_LEARN_DB="$HOME/.zsh_learning_db"
export ZSH_CMD_STATS="$HOME/.zsh_command_stats"
export ZSH_CMD_DIR="$HOME/.zsh_command_dir"

# Initialize databases on first run
[[ ! -f "$ZSH_LEARN_DB" ]] && touch "$ZSH_LEARN_DB"
[[ ! -f "$ZSH_CMD_STATS" ]] && touch "$ZSH_CMD_STATS"
[[ ! -f "$ZSH_CMD_DIR" ]] && touch "$ZSH_CMD_DIR"

# Track command usage (called after each command)
track-command() {
    local cmd="$1"
    local dir="$(pwd)"

    # Skip aliases, functions, and builtins for tracking
    [[ "$cmd" =~ ^(alias|export|cd|ll|la|l|cl|clear) ]] && return

    # Update command frequency stats
    if grep -q "^${cmd}|" "$ZSH_CMD_STATS" 2>/dev/null; then
        local count=$(grep "^${cmd}|" "$ZSH_CMD_STATS" | head -1 | cut -d'|' -f2)
        if [[ -n "$count" && "$count" =~ ^[0-9]+$ ]]; then
            local new_count=$((count + 1))
            sed -i '' "s#^${cmd}|${count}\$#${cmd}|${new_count}#" "$ZSH_CMD_STATS"
        else
            # Reset corrupted entry
            sed -i '' "s#^${cmd}|.*#${cmd}|1#" "$ZSH_CMD_STATS"
        fi
    else
        echo "$cmd|1" >> "$ZSH_CMD_STATS"
    fi

    # Track directory context
    echo "$cmd|$dir" >> "$ZSH_CMD_DIR"
}

# Add precmd hook to track commands
precmd_learning() {
    local last_cmd="${history[$((HISTCMD-1))]}"
    local cmd_name="${last_cmd%% *}"
    track-command "$cmd_name"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd precmd_learning

# Context-aware command suggestions based on directory
suggest-for-dir() {
    local current_dir="$(pwd)"
    grep "|${current_dir}" "$ZSH_CMD_DIR" 2>/dev/null | \
        awk -F'|' '{print $2}' | sort | uniq -c | sort -rn | head -5 | \
        awk '{print $2}' | tr '\n' ' '
}

# Learn from history patterns
learn-from-history() {
    local threshold=5
    local min_length=15

    while IFS='|' read -r cmd count; do
        grep -q "^alias ${cmd%% *}" ~/.aliases 2>/dev/null && continue
        [[ ${#cmd} -lt $min_length ]] && continue
        if [[ $count -ge $threshold ]]; then
            local short="${cmd:0:3}"
            echo "Tip: '$cmd' used frequently. Create alias: learn $short '$cmd'"
        fi
    done < <(tail -100 "$ZSH_CMD_DIR" | awk -F'|' '{print $2}' | sort | uniq -c | sort -rn | head -20)
}

# Show alias suggestions once per day
alias-suggestion-run() {
    local last_check=$(cat "$HOME/.zsh_alias_suggestion_shown" 2>/dev/null || echo 0)
    local now=$(date +%s)
    [[ $((now - last_check)) -lt 86400 ]] && return
    echo "$now" > "$HOME/.zsh_alias_suggestion_shown"
    learn-from-history
}

alias-suggestion-run
