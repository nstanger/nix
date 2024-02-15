#####################################################################
# Useful configuration from <https://scriptingosx.com/2019/06/moving-to-zsh/>.
# Case-insensitive globbing
setopt NO_CASE_GLOB

# Directory changing
# push the previous directory onto the stack
setopt AUTO_PUSHD
# maximum directory stack size
DIRSTACKSIZE=10
# ignore duplicates in the directory stack
setopt PUSHD_IGNORE_DUPS
# swap meaning of cd +/- so that -2 means item numbered 2 in the stack,
# not the second from the bottom
setopt PUSHD_MINUS

# Shell history
# append to history
setopt APPEND_HISTORY
# ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# don't save duplicates to the history file
setopt HIST_SAVE_NO_DUPS
# removes extra blanks from commmands in history
setopt HIST_REDUCE_BLANKS
# verify !! command substitution
setopt HIST_VERIFY

# Auto-correction
setopt CORRECT
# setopt CORRECT_ALL

# Input/output
# Allow comments in interactive shells
setopt INTERACTIVE_COMMENTS

# Miscellaneous
# Force prompts to be re-evaluated <https://unix.stackexchange.com/a/40646>.
setopt PROMPT_SUBST


#####################################################################
# Key bindings.
# backspace should be bound by default, being careful
bindkey "^H" backward-delete-char
# forward delete
bindkey "\e[3~" delete-char

# option backspace should be bound by default, being careful
bindkey "\e^?" backward-kill-word # works on Monterey but not Ventura
bindkey "\e177" backward-kill-word # works on Ventura but not Monterey
# option forward delete
bindkey "\e(" kill-word

# control U should be bound by default, being careful
bindkey "^U" backward-kill-line


#####################################################################
# Python 2 and the "python" executable disappear in more recent macOS, but some
# things still look for "python", e.g., zsh-git-prompt.
if [[ -z $(command -v python) ]]
then
    alias python="python3"
fi


#####################################################################
# Lazy-load the Python virtualenv wrapper so that it doesn't slow down
# shell initialisation.
zsh-defer source virtualenvwrapper.sh


#####################################################################
# Source any local scripts in ~/.zshrc.d
function () {
    # null_glob prevents an error if the directory is empty
    # (see <https://unix.stackexchange.com/a/504718>)
    setopt null_glob local_options
    if [[ -d "$HOME/.zshrc.d" ]]; then
        for FILE in $HOME/.zshrc.d/*; do
            source "$FILE"
        done
        unsetopt null_glob
    fi
}


#####################################################################
# Function to set working directory. Only activates when you start a
# new session in $HOME, to avoid stomping on restored sessions. If
# no argument is provided, default to either $ALL_PAPERS_ROOT
# (Terminal) or the profile name (iTerm) Takes advantage of cdpath
# and assumes directory names contain no blanks.
function set_working_dir() {
    if [[ "$PWD" = "$HOME" ]]
    then
        if [[ -z "$1" ]]
        then
            if [[ "$TERM_PROGRAM" = "iTerm.app" ]]
            then
                target=$(echo "$ITERM_PROFILE" | tr -d ' ')
            else
                target="$ALL_PAPERS_ROOT"
            fi
        else
            target=$(echo "$1" | tr -d ' ')
        fi
        cd "$target"
    fi
}
