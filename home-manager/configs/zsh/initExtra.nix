builtins.concatStringsSep "\n" [
    #####################################################################
    # Useful configuration from <https://scriptingosx.com/2019/06/moving-to-zsh/>.
    # Case-insensitive globbing
    "setopt NO_CASE_GLOB"

    # Directory changing
    # push the previous directory onto the stack
    "setopt AUTO_PUSHD"
    # maximum directory stack size
    "DIRSTACKSIZE=10"
    # ignore duplicates in the directory stack
    "setopt PUSHD_IGNORE_DUPS"
    # swap meaning of cd +/- so that -2 means item numbered 2 in the stack,
    # not the second from the bottom
    "setopt PUSHD_MINUS"

    # Shell history
    # append to history
    "setopt APPEND_HISTORY"
    # ignore duplicates when searching
    "setopt HIST_FIND_NO_DUPS"
    # don't save duplicates to the history file
    "setopt HIST_SAVE_NO_DUPS"
    # removes extra blanks from commmands in history
    "setopt HIST_REDUCE_BLANKS"
    # verify !! command substitution
    "setopt HIST_VERIFY"

    # Auto-correction
    "setopt CORRECT"
    # "setopt CORRECT_ALL"

    # Input/output
    # Allow comments in interactive shells
    "setopt INTERACTIVE_COMMENTS"

    # Miscellaneous
    # Force prompts to be re-evaluated <https://unix.stackexchange.com/a/40646>.
    "setopt PROMPT_SUBST"

    #####################################################################
    # Key bindings.
    # backspace should be bound by default, being careful
    "bindkey \"^H\" backward-delete-char"
    # forward delete
    "bindkey \"\\e[3~\" delete-char"

    # option backspace should be bound by default, being careful
    "bindkey \"\\e^?\" backward-kill-word"
    # option forward delete
    "bindkey \"\\e(\" kill-word"

    # control U should be bound by default, being careful
    "bindkey \"^U\" backward-kill-line"
]
