
PROMPT="
# $fg[black]$fg[black]┌─[$fg[black]%D{%Y-%m-%d} $fg[white]%T$fg[black]]──[$fg[green]%~$fg[black]]──[$fg[yellow]%n$fg[black]]\n$fg[black]$fg[white]└─[$fg[blue]%# $fg[white]]$fg[black]${(r:$SHLVL*2::%#:)}
#$ : " 
RPROMPT='${vcs_info_msg_0_}' # git branch
if [[ ! -z "$SSH_CLIENT" ]]; then
    RPROMPT="$RPROMPT ⇄" # ssh icon
fi


# History options
HISTSIZE=10000 # 10k lines loaded in memory
SAVEHIST=100000 # 100k lines saved on disk
HISTFILE="$XDG_CACHE_HOME/zsh_history"
setopt histignorealldups # Substitute commands in the prompt
setopt sharehistory # Share the same history between all shells

# Other shell options
setopt autocd # assume "cd" when a command is a directory
setopt promptsubst # required for git plugin
# setopt extendedglob
# Extended glob syntax, eg ^ to negate, <x-y> for range, (foo|bar) etc.
# Backwards-incompatible with bash, so disabled by default.

# Colors!

# 256 color mode
export TERM="xterm-256color"

# Color aliases
if command -V dircolors >/dev/null 2>&1; then
	eval "$(dircolors -b)"
	# Only alias ls colors if dircolors is installed
	alias ls="ls -F --color=auto --group-directories-first"
fi

alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"
# make less accept color codes and re-output them
alias less="less -R"


##
# Completion system
#

autoload -Uz compinit
compinit

zstyle ":completion:*" auto-description "specify: %d"
zstyle ":completion:*" completer _complete _correct _approximate
zstyle ":completion:*" format "Completing %d"
zstyle ":completion:*" group-name ""
zstyle ":completion:*" menu select=2
zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}
zstyle ":completion:*" list-colors ""
zstyle ":completion:*" list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ":completion:*" matcher-list "" "m:{a-z}={A-Z}" "m:{a-zA-Z}={A-Za-z}" "r:|[._-]=* r:|=* l:|=*"
zstyle ":completion:*" menu select=long
zstyle ":completion:*" select-prompt %SScrolling active: current selection at %p%s
zstyle ":completion:*" verbose true

zstyle ":completion:*:*:kill:*:processes" list-colors "=(#b) #([0-9]#)*=0=01;31"
zstyle ":completion:*:kill:*" command "ps -u $USER -o pid,%cpu,tty,cputime,cmd"


# Make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
	function zle-line-init {
		printf "%s" ${terminfo[smkx]}
	}
	function zle-line-finish {
		printf "%s" ${terminfo[rmkx]}
	}
	zle -N zle-line-init
	zle -N zle-line-finish
fi

# typing ... expands to ../.., .... to ../../.., etc.
rationalise-dot() {
	if [[ $LBUFFER = *.. ]]; then
		LBUFFER+=/..
	else
		LBUFFER+=.
	fi
}
zle -N rationalise-dot
bindkey . rationalise-dot
bindkey -M isearch . self-insert # history search fix


##
# Aliases
#

# some more ls aliases
alias gupdate="gcloud auth application-default login"
alias ls="ls -lh"
alias la="ls -A"
alias sl="ls"
alias c="clear"
alias source="source ~/.zshrc"
alias update="gcloud auth application-default login"
alias auth="gcloud auth login --force --brief --update-adc && gcloud auth configure-docker && gcloud auth configure-docker us-docker.pkg.dev"

# Make unified diff syntax the default
alias diff="diff -u"

# octal+text permissions for files
alias perms="stat -c '%A %a %n'"

# expand sudo aliases
alias sudo="sudo "

# Default
alias hexdump="hexdump --canonical"

# Default
alias xclip="xclip -selection clipboard"

# display a list of supported colors
function lscolors {
	((cols = $COLUMNS - 4))
	s=$(printf %${cols}s)
	for i in {000..$(tput colors)}; do
		echo -e $i $(tput setaf $i; tput setab $i)${s// /=}$(tput op);
	done
}

# launch an app
function launch {
	type $1 >/dev/null || { print "$1 not found" && return 1 }
	$@ &>/dev/null &|
}
alias launch="launch " # expand aliases

# Useful python aliases/functions

function urlencode {
	python -c "import sys; from urllib.parse import quote_plus; print(quote_plus(sys.stdin.read()))"
}

# Decode URLencoded string
function urldecode {
	python -c "import sys; from urllib.parse import unquote; print(unquote(sys.stdin.read()), end='')"
}

# Convert a querystring into pretty JSON
function urlarray {
	python -c "import sys, json; from urllib.parse import parse_qs; print(json.dumps({k: q[0] if len(q) == 1 else q for k, q in parse_qs(sys.stdin.read()).items()}), end='')" | json
}

# get public ip
function myip {
	local api
	case "$1" in
		"-4")
			api="http://v4.ipv6-test.com/api/myip.php"
			;;
		"-6")
			api="http://v6.ipv6-test.com/api/myip.php"
			;;
		*)
			api="http://ipv6-test.com/api/myip.php"
			;;
	esac
	curl -s "$api"
	echo # Newline.
}


##
# Extras
#

# Git plugin
autoload -Uz vcs_info
zstyle ":vcs_info:*" enable git
zstyle ":vcs_info:(git*):*" get-revision true
zstyle ":vcs_info:(git*):*" check-for-changes true

local _branch="%b"
zstyle ":vcs_info:git*" formats "$_branch"
zstyle ":vcs_info:git*" actionformats "$_branch"
zstyle ':vcs_info:git*+set-message:*' hooks git-stash
# Uncomment to enable vcs_info debug mode
# zstyle ':vcs_info:*+*:*' debug true


function +vi-git-stash() {
	if [[ -s "${hook_com[base]}/.git/refs/stash" ]]; then
		hook_com[misc]="%{$fg_bold[grey]%}~%{$reset_color%}"
	fi
}

precmd() {
	vcs_info
}

# Syntax highlighting plugin
if [[ -e /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
	source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -e /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
	source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Autosuggestion plugin
if [[ -e /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh  ]]; then
	source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# virtualenvwrapper support
# Remember to set $PROJECT_HOME in your profile file!
if command -V virtualenvwrapper_lazy.sh >/dev/null 2>&1; then
	export WORKON_HOME="$XDG_DATA_HOME/virtualenvs"
	source virtualenvwrapper_lazy.sh
	# Arch linux uses python3 by default, this is required to make python2-compatible projects
	alias mkproject2="mkproject -p /usr/bin/python2"
	alias mkvirtualenv2="mkvirtualenv -p /usr/bin/python2"
fi

# User profile
if [[ -e "$XDG_CONFIG_HOME/zsh/profile" ]]; then
	source "$XDG_CONFIG_HOME/zsh/profile"
fi


alias docker-clean="docker system prune -a --force"