# # COLORS
# PS1="Niteeshkanungo: "

# reloads the prompt, usefull to take new modifications into account
# alias source="source ~/.zprofile" # Antigravity: Commented out because this breaks 'source filename' behavior

# sets your computer to sleep immediatly``
alias tata="pmset sleepnow"

# retrieves the http status code for any URL
alias httpstatuscode="curl -w %{http_code} -s --output /dev/null $1"

# grabs the latest .bash_profile file and reloads the prompt
alias update_profile="curl -L https://raw.githubusercontent.com/Niteeshkanungo/dotfiles/master/.zprofile > ~/.zprofile && source ~/.zprofile"

# your local ip
alias localip="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"

# ENVIRONMENT CONFIGURATION

export BLOCKSIZE=1k

# TERMINAL

alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias ll='ls -FGlAhp'                       # Preferred 'ls' implementation
alias less='less -FSRXc'                    # Preferred 'less' implementation
cd() { builtin cd "$@"; ll; }               # Always list directory contents upon 'cd'
alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels
alias edit='subl'                           # edit:         Opens any file in sublime editor
alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder
alias ~="cd ~"                              # ~:            Go Home
alias c='clear'                             # c:            Clear terminal display
alias which='type -all'                     # which:        Find executables
alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
alias show_options='shopt'                  # Show_options: display bash options settings
alias fix_stty='stty sane'                  # fix_stty:     Restore terminal settings when screwed up
alias cic='set completion-ignore-case On'   # cic:          Make tab-completion case-insensitive
mcd () { mkdir -p "$1" && cd "$1"; }        # mcd:          Makes new Dir and jumps inside
trash () { command mv "$@" ~/.Trash ; }     # trash:        Moves a file to the MacOS trash
ql () { qlmanage -p "$*" >& /dev/null; }    # ql:           Opens any file in MacOS Quicklook Preview
alias DT='tee ~/Desktop/terminalOut.txt'    # DT:           Pipe content to file on MacOS Desktop
alias Home="cd ~"
alias Project="cd Documents/Projects"
alias Personal="cd Documents/Personal"
alias Downloads="cd Documents/Downloads"
alias Software="cd Documents/Softwares"


# mans:   Search manpage given in agument '1' for term given in argument '2' (case insensitive)
    mans () {
        man $1 | grep -iC2 --color=always $2 | less
    }

# showa: to remind yourself of an alias (given some part of it)
showa () { grep --color=always -i -C 2 "$@" ~/.aliases | less -FSRXc ; }

# cdf:  'Cd's to frontmost window of MacOS Finder
    cdf () {
        currFolderPath=$( /usr/bin/osascript <<EOT
            tell application "Finder"
                try
            set currFolder to (folder of the front window as alias)
                on error
            set currFolder to (path to desktop folder as alias)
                end try
                POSIX path of currFolder
            end tell
EOT
        )
        echo "cd to \"$currFolderPath\""
        cd "$currFolderPath"
    }

extract() {
    # DESC:  Extracts a compressed file from multiple formats
    # USAGE: extract -v <file>

    local opt
    local OPTIND=1

    while getopts "hv" opt; do
        case "$opt" in
            h)
                cat <<EOF
  $ ${FUNCNAME[0]} [option] <archives>
  options:
    -h  show this message and exit
    -v  verbosely list files processed
EOF
                return
                ;;
            v)
                local -r verbose='v'
                ;;
            ?)
                extract -h >&2
                return 1
                ;;
        esac
    done
    shift $((OPTIND - 1))

    [ $# -eq 0 ] && extract -h && return 1
    while [ $# -gt 0 ]; do
        if [ -f "$1" ]; then
            case "$1" in
                *.tar.bz2 | *.tbz | *.tbz2) tar "x${verbose}jf" "$1" ;;
                *.tar.gz | *.tgz) tar "x${verbose}zf" "$1" ;;
                *.tar.xz)
                    xz --decompress "$1"
                    set -- "$@" "${1:0:-3}"
                    ;;
                *.tar.Z)
                    uncompress "$1"
                    set -- "$@" "${1:0:-2}"
                    ;;
                *.bz2) bunzip2 "$1" ;;
                *.deb) dpkg-deb -x${verbose} "$1" "${1:0:-4}" ;;
                *.pax.gz)
                    gunzip "$1"
                    set -- "$@" "${1:0:-3}"
                    ;;
                *.gz) gunzip "$1" ;;
                *.pax) pax -r -f "$1" ;;
                *.pkg) pkgutil --expand "$1" "${1:0:-4}" ;;
                *.rar) unrar x "$1" ;;
                *.rpm) rpm2cpio "$1" | cpio -idm${verbose} ;;
                *.tar) tar "x${verbose}f" "$1" ;;
                *.txz)
                    mv "$1" "${1:0:-4}.tar.xz"
                    set -- "$@" "${1:0:-4}.tar.xz"
                    ;;
                *.xz) xz --decompress "$1" ;;
                *.zip | *.war | *.jar) unzip "$1" ;;
                *.Z) uncompress "$1" ;;
                *.7z) 7za x "$1" ;;
                *) echo "'$1' cannot be extracted via extract" >&2 ;;
            esac
        else
            echo "extract: '$1' is not a valid file" >&2
        fi
        shift
    done
}

# Git Shortcuts
# #####################################

alias diff="git difftool"                                  # Open file in git's default diff tool <file>
alias fetch="git fetch origin"                             # Fetch from origin
alias gamend='git commit --amend'                          # Add more changes to the commit
alias gap='git add -p'                                     # Step through each change
alias gba='git branch -a'                                  # Lists local and remote branches
alias gs='git status'                                      # Current git status
alias gc="git --no-pager commit"                           # Commit w/ message written in EDITOR
alias gcl='git clone --recursive'                          # Clone with all submodules
alias gcm="git --no-pager commit -m"                       # Commit w/ message from the command line <commit message>
alias gcv="git --no-pager commit --no-verify"              # Commit without verification
alias ginitsubs='git submodule update --init --recursive'  # Init and update all submodules
alias gundo="git reset --soft HEAD^"                       # Undo last commit
alias gs='git --no-pager status -s --untracked-files=all'  # Git status
alias gsearch='git rev-list --all | xargs git grep -F'     # Find a string in Git History <search string>
alias gss='git remote update && git status -uno'           # Are we behind remote?
alias gsubs='git submodule update --recursive --remote'    # Update all submodules
alias gup="git remote update -p; git merge --ff-only @{u}" # Update & Merge
alias undopush="git push -f origin HEAD^:master"           # Undo a git push
alias unstage='git reset HEAD'                             # Unstage a file

ga() { git add "${@:-.}"; } # Add file (default: all)

alias gl='git log --pretty=format:"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --date=short' # A nicer Git Log

applyignore() {
    # DESC: Applies changes to the git .ignorefile after the files mentioned were already committed to the repo

    git ls-files -ci --exclude-standard -z | xargs -0 git rm --cached
}

rollback() (
    # DESC: Resets the current HEAD to specified commit
    # ARGS: $1 (Required): Commit to revert to
    # USAGE: gitRollback <commit>

    _is_clean_() {
        if [[ $(git diff --shortstat 2>/dev/null | tail -n1) != "" ]]; then
            echo "Your branch is dirty, please commit your changes"
            return 1
        fi
        return 0
    }

    _commit_exists_() {
        git rev-list --quiet "$1"
        status=$?
        if [ $status -ne 0 ]; then
            echo "Commit ${1} does not exist"
            return 1
        fi
        return 0
    }

    _keep_changes_() {
        while true; do
            read -r -p "Do you want to keep all changes from rolled back revisions in your working tree? [Y/N]" RESP
            case $RESP in

                [yY])
                    echo "Rolling back to commit ${1} with unstaged changes"
                    git reset "$1"
                    break
                    ;;
                [nN])
                    echo "Rolling back to commit ${1} with a clean working tree"
                    git reset --hard "$1"
                    break
                    ;;
                *)
                    echo "Please enter Y or N"
                    ;;
            esac
        done
    }

    if [ -n "$(git symbolic-ref HEAD 2>/dev/null)" ]; then
        if _is_clean_; then
            if _commit_exists_ "$1"; then

                while true; do
                    read -r -p "WARNING: This will change your history and move the current HEAD back to commit ${1}, continue? [Y/N]" RESP
                    case $RESP in

                        [yY])
                            _keep_changes_ "$1"
                            break
                            ;;
                        [nN])
                            break
                            ;;
                        *)
                            echo "Please enter Y or N"
                            ;;
                    esac
                done
            fi
        fi
    else
        echo "you're currently not in a git repository"
    fi
)

gurl() (
    # DESC:  Prints URL of current git repository

    local remote remotename host user_repo

    remotename="${*:-origin}"
    remote="$(git remote -v | awk '/^'"${remotename}"'.*\(push\)$/ {print $2}')"
    [[ "${remote}" ]] || return
    host="$(echo "${remote}" | perl -pe 's/.*@//;s/:.*//')"
    user_repo="$(echo "${remote}" | perl -pe 's/.*://;s/\.git$//')"
    echo "https://${host}/${user_repo}"
)

# From Git-Extras (https://github.com/tj/git-extras)
alias obliterate='git obliterate'       # Completely remove a file from the repository, including past commits and tags
alias release='git-release'             # Create release commit with the given <tag> and other options
alias rename-branch='git rename-branch' # Rename a branch and sync with remote. <old name> <new name>
alias rename-tag='git rename-tag'       # Rename a tag (locally and remotely). <old name> <new name>
alias ignore='git ignore'               # Add files to .gitignore. Run without arguments to list ignored files.
alias ginfo='git info --no-config'      # Show information about the current repository.
alias del-sub='git delete-submodule'    # Delete a submodule. <name>
alias del-tag='git delete-tag'          # Delete a tag. <name>
alias changelog='git changelog'         # Generate a Changelog from tags and commit messages. -h for help.
alias garchive='git archive'            # Creates a zip archive of the current git repository. The name of the archive will depend on the current HEAD of your git repository.
alias greset='git reset'                # Reset one file to HEAD or certain commit. <file> <commit (optional)>
alias gclear='git clear-soft'           # Does a hard reset and deletes all untracked files from the working directory, excluding those in .gitignore.
alias gbrowse='git browse'              # Opens the current git repository website in your default web browser.
alias gtimes='git utimes'               # Change files modification time to their last commit date.



# SEARCHING

alias qfind="find . -name "                 # qfind:    Quickly search for file
ff () { /usr/bin/find . -name "$@" ; }      # ff:       Find file under the current directory
ffs () { /usr/bin/find . -name "$@"'*' ; }  # ffs:      Find file whose name starts with a given string
ffe () { /usr/bin/find . -name '*'"$@" ; }  # ffe:      Find file whose name ends with a given string

# spotlight: Search for a file using MacOS Spotlight's metadata
    spotlight () { mdfind "kMDItemDisplayName == '$@'wc"; }

# PROCESS MANAGEMENT

#   findPid: find out the pid of a specified process
#   -----------------------------------------------------
#       Note that the command name can be specified via a regex
#       E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
#       Without the 'sudo' it will only find processes of the current user
#   -----------------------------------------------------
    findPid () { lsof -t -c "$@" ; }

#   memHogsTop, memHogsPs:  Find memory hogs
#   -----------------------------------------------------
    alias memHogsTop='top -l 1 -o rsize | head -20'
    alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

#   cpuHogs:  Find CPU hogs
#   -----------------------------------------------------
    alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

#   topForever:  Continual 'top' listing (every 10 seconds)
#   -----------------------------------------------------
    alias topForever='top -l 9999999 -s 10 -o cpu'

#   ttop:  Recommended 'top' invocation to minimize resources
#   ------------------------------------------------------------
#       Taken from this macosxhints article
#       http://www.macosxhints.com/article.php?story=20060816123853639
#   ------------------------------------------------------------
    alias ttop="top -R -F -s 10 -o rsize"

#   my_ps: List processes owned by my user:
#   ------------------------------------------------------------
    my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }

show_colors() {
    # Prints all tput colors to terminal
    for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}


# NETWORKING

alias myip='curl icanhazip.com'                    # myip:         Public facing IP Address
alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
alias openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections
alias showBlocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs

#   ii:  display useful host related informaton

    ii() {
        echo -e "\nYou are logged on ${RED}$HOST"
        echo -e "\nAdditionnal information:$NC " ; uname -a
        echo -e "\n${RED}Users logged on:$NC " ; w -h
        echo -e "\n${RED}Current date :$NC " ; date
        echo -e "\n${RED}Machine stats :$NC " ; uptime
        echo -e "\n${RED}Current network location :$NC " ; scselect
        echo -e "\n${RED}Public facing IP Address :$NC " ;myip
        #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
        echo
    }

weather() { curl wttr.in/"${1:-}"; }

# SYSTEMS OPERATIONS & INFORMATION

alias mountReadWrite='/sbin/mount -uw /'    # mountReadWrite:   For use when booted into single-user

#   cleanupDS:  Recursively delete .DS_Store files
#   -------------------------------------------------------------------
    alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"

#   finderShowHidden:   Show hidden files in Finder
#   finderHideHidden:   Hide hidden files in Finder
#   -------------------------------------------------------------------
    alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'
    alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'

#   cleanupLS:  Clean up LaunchServices to remove duplicates in the "Open With" menu
#   -----------------------------------------------------------------------------------
    alias cleanupLS="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

#    screensaverDesktop: Run a screensaver on the Desktop
#   -----------------------------------------------------------------------------------
    alias screensaverDesktop='/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background'

#   ---------------------------------------
#   8. WEB DEVELOPMENT
#   ---------------------------------------

alias apacheEdit='sudo edit /etc/httpd/httpd.conf'      # apacheEdit:       Edit httpd.conf
alias apacheRestart='sudo apachectl graceful'           # apacheRestart:    Restart Apache
alias editHosts='sudo edit /etc/hosts'                  # editHosts:        Edit /etc/hosts file
alias herr='tail /var/log/httpd/error_log'              # herr:             Tails HTTP error logs
alias apacheLogs="less +F /var/log/apache2/error_log"   # Apachelogs:   Shows apache error logs
httpHeaders () { /usr/bin/curl -I -L $@ ; }             # httpHeaders:      Grabs headers from web page

#   httpDebug:  Download a web page and show info on what took time
#   -------------------------------------------------------------------
httpDebug () { /usr/bin/curl $@ -o /dev/null -w "dns: %{time_namelookup} connect: %{time_connect} pretransfer: %{time_pretransfer} starttransfer: %{time_starttransfer} total: %{time_total}\n" ; }


# MacOS Specific Shortcuts
# ###########################

if [[ ${OSTYPE} == "darwin"* ]]; then # Only load these on a MacOS computer

    ## ALIASES ##
    alias cpwd='pwd | tr -d "\n" | pbcopy'                        # Copy the working path to clipboard
    alias cl="fc -e -|pbcopy"                                     # Copy output of last command to clipboard
    alias caff="caffeinate -ism"                                  # Run command without letting mac sleep
    alias cleanDS="find . -type f -name '*.DS_Store' -ls -delete" # Delete .DS_Store files on Macs
    alias showHidden='defaults write com.apple.finder AppleShowAllFiles TRUE'
    alias hideHidden='defaults write com.apple.finder AppleShowAllFiles FALSE'
    alias capc="screencapture -c"
    alias capic="screencapture -i -c"
    alias capiwc="screencapture -i -w -c"

    ql() {
        # DESC:  Opens files in MacOS Quicklook
        # ARGS:  $1 (optional): File to open in Quicklook
        # USAGE: ql [file1] [file2]
        qlmanage -p "${*}" &>/dev/null
    }

    alias cleanupLS="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder" # Clean up LaunchServices to remove duplicates in the "Open With" menu

    unquarantine() {
        # DESC:  Manually remove a downloaded app or file from the MacOS quarantine
        # ARGS:  $1 (required): Path to file or app
        # USAGE: unquarantine [file]

        local attribute
        for attribute in com.apple.metadata:kMDItemDownloadedDate com.apple.metadata:kMDItemWhereFroms com.apple.quarantine; do
            xattr -r -d "${attribute}" "$@"
        done
    }

    browser() {
        # DESC:  Pipe HTML to a Safari browser window
        # USAGE: echo "<h1>hi mom!</h1>" | browser'

        local FILE
        FILE=$(mktemp -t browser.XXXXXX.html)
        cat /dev/stdin >|"${FILE}"
        open -a Safari "${FILE}"
    }

    finderpath() {
        # DESC:  Echoes the path of the frontmost window in the finder
        # ARGS:  None
        # OUTS:  None
        # USAGE: cd $(finderpath)
        # credit: https://github.com/herrbischoff/awesome-osx-command-line/blob/master/functions.md

        local FINDER_PATH

        FINDER_PATH=$(
            osascript -e 'tell application "Finder"' \
                -e "if (${1-1} <= (count Finder windows)) then" \
                -e "get POSIX path of (target of window ${1-1} as alias)" \
                -e 'else' \
                -e 'get POSIX path of (desktop as alias)' \
                -e 'end if' \
                -e 'end tell' 2>/dev/null
        )

        echo "${FINDER_PATH}"
    }

    ## SPOTLIGHT MAINTENANCE ##
    alias spot-off="sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist"
    alias spot-on="sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist"

    # If the 'mds' process is eating tons of memory it is likely getting hung on a file.
    # This will tell you which file that is.
    alias spot-file="lsof -c '/mds$/'"

    # Search for a file using MacOS Spotlight's metadata
    spotlight() { mdfind "kMDItemDisplayName == '${1}'wc"; }
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
