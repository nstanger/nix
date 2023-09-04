{
    empty = "/bin/rm -rf ~/.Trash/*";
    java_home = "/usr/libexec/java_home";
    # unlocktrash = "/usr/bin/sudo /usr/sbin/chown -R ${USER}:${GROUP} ~/.Trash/*";
    ls = "lsd --classify --color=auto --group-directories-first";
    l = "lsd --classify --color=auto -l --group-directories-first";
    lr = "lsd --classify --color=auto -l --group-directories-first --tree";
    ll = "lsd --classify --color=auto -al --group-directories-first";
    llr = "lsd --classify --color=auto -al --group-directories-first --tree";
    "l@" = "/bin/ls -lFG@";
    "ll@" = "/bin/ls -alFG@";
    # man = "/usr/local/bin/openman";
    nixswitch = "darwin-rebuild switch --flake ~/Documents/nix/.#";
    nixupdate = "pushd ~/Documents/nix; nix flake update; nixswitch; popd";
    rm = "/bin/rm -i";
    # locate = "${BREW_PREFIX}/bin/glocate -d /var/db/locate.database";
    # smbclient = "rlwrap /opt/local/bin/smbclient";
    beep = "/usr/bin/tput bel";
    # grep = "${BREW_PREFIX}/bin/ggrep --color=auto";
}
