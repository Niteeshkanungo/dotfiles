# History options
HISTSIZE=10000
SAVEHIST=100000
HISTFILE="$XDG_CACHE_HOME/zsh_history"
setopt histignorealldups
setopt sharehistory
setopt histappend        # Append to history file
setopt inc_append_history # Append immediately
setopt histexpiredupsfirst # Remove oldest duplicates first
setopt histignorespace   # Don't save commands starting with a space