autoload -Uz compinit

#####################################################################
# Only check once per day whether the cached .zcompdump file needs to be
# regenerated (see <https://gist.github.com/ctechols/ca1035271ad134841284>).
function {
    setopt extended_glob local_options
    if [[ ! -e ${HOME}/.zcompdump || -n ${HOME}/.zcompdump(#qNY1.mh+24) ]]; then
        compinit
        touch ${HOME}/.zcompdump
    else
        compinit -C
    fi
}

# Use bash style word boundaries. The normal solution of:
#   autoload -U select-word-style
#   select-word-style bash
# doesn't seem to work, and neither does manually doing the same things
# that `select-word-style`` bash does? Let's just stomp WORDCHARS instead.
export WORDCHARS=
