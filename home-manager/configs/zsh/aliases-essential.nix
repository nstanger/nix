# Essential aliases that ALL hosts must have.
# Common aliases shared across several hosts go in
# aliases-common.nix.
# Host specific aliases go in each host module.
pkgs: let
    ezaBasicOptions = "--icons --classify --color=auto --group-directories-first";
    ezaLongOptions = "--long --group";
in {
    empty = "${pkgs.coreutils}/bin/rm -rf ~/.Trash/*";
    # java_home = "/usr/libexec/java_home";
    # unlocktrash = "/usr/bin/sudo /usr/sbin/chown -R ${USER}:${GROUP} ~/.Trash/*";
    ls = "${pkgs.eza}/bin/eza ${ezaBasicOptions}";
    lsr = "${pkgs.eza}/bin/eza ${ezaBasicOptions} --tree";
    l = "${pkgs.eza}/bin/eza ${ezaBasicOptions} ${ezaLongOptions}";
    lr = "${pkgs.eza}/bin/eza ${ezaBasicOptions} ${ezaLongOptions} --tree";
    ll = "${pkgs.eza}/bin/eza ${ezaBasicOptions} ${ezaLongOptions} --all";
    llr = "${pkgs.eza}/bin/eza ${ezaBasicOptions} ${ezaLongOptions} --all --tree";
    lsregister = "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister";
    # requires manual install of ManOpen.app and /usr/local/bin/openman
    man = "/usr/local/bin/openman";
    nixswitch = "darwin-rebuild switch --flake ~/Documents/Development/nix/.#";
    nixupdate = "pushd ~/Documents/Development/nix; nix flake update; nixswitch; popd";
    rm = "${pkgs.coreutils}/bin/rm -i";
    # locate = "${BREW_PREFIX}/bin/glocate -d /var/db/locate.database";
    # smbclient = "rlwrap /opt/local/bin/smbclient";
    beep = "/usr/bin/tput bel";
    grep = "${pkgs.gnugrep}/bin/grep --color=auto";

    # set terminal window and tab title
    winname = "printf \"\\033]2;%s\\a\"";
    tabname = "printf \"\\033]1;%s\\a\"";
}
