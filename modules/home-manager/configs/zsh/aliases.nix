let
    ezaBasicOptions = "--icons --classify --color=auto --group-directories-first";
    ezaLongOptions = "--long --group";
in {
    empty = "/bin/rm -rf ~/.Trash/*";
    # java_home = "/usr/libexec/java_home";
    # unlocktrash = "/usr/bin/sudo /usr/sbin/chown -R ${USER}:${GROUP} ~/.Trash/*";
    ls = "eza ${ezaBasicOptions}";
    lsr = "eza ${ezaBasicOptions} --tree";
    l = "eza ${ezaBasicOptions} ${ezaLongOptions}";
    lr = "eza ${ezaBasicOptions} ${ezaLongOptions} --tree";
    ll = "eza ${ezaBasicOptions} ${ezaLongOptions} --all";
    llr = "eza ${ezaBasicOptions} ${ezaLongOptions} --all --tree";
    # man = "/usr/local/bin/openman";
    nixswitch = "darwin-rebuild switch --flake ~/Documents/nix/.#";
    nixupdate = "pushd ~/Documents/nix; nix flake update; nixswitch; popd";
    rm = "/bin/rm -i";
    # locate = "${BREW_PREFIX}/bin/glocate -d /var/db/locate.database";
    # smbclient = "rlwrap /opt/local/bin/smbclient";
    beep = "/usr/bin/tput bel";
    # grep = "${BREW_PREFIX}/bin/ggrep --color=auto";

    # Set Terminal window and tab title
    winname="printf \"\\033]2;%s\\a\"";
    tabname="printf \"\\033]1;%s\\a\"";
}
