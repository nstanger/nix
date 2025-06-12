# Essential aliases that ALL hosts must have.
# Common aliases shared across several hosts go in
# aliases-common.nix.
# Host specific aliases go in each host module.
pkgs: let
    ezaBasicOptions = "--icons --classify --color=auto --group-directories-first";
    ezaLongOptions = "--long --group";
in {
    # e.g., appid /Applications/VLC/Contents/Info.plist
    appid="plutil -extract CFBundleIdentifier raw";
    empty = "${pkgs.coreutils}/bin/rm -rf ~/.Trash/*";
    # e.g., fileuti test.wav
    fileuti = "mdls -name kMDItemContentType";
    # java_home = "/usr/libexec/java_home";
    # unlocktrash = "/usr/bin/sudo /usr/sbin/chown -R ${USER}:${GROUP} ~/.Trash/*";
    ls = "${pkgs.eza}/bin/eza ${ezaBasicOptions}";
    lsr = "${pkgs.eza}/bin/eza ${ezaBasicOptions} --tree";
    l = "${pkgs.eza}/bin/eza ${ezaBasicOptions} ${ezaLongOptions}";
    lr = "${pkgs.eza}/bin/eza ${ezaBasicOptions} ${ezaLongOptions} --tree";
    ll = "${pkgs.eza}/bin/eza ${ezaBasicOptions} ${ezaLongOptions} --all";
    llr = "${pkgs.eza}/bin/eza ${ezaBasicOptions} ${ezaLongOptions} --all --tree";
    lsregister = "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister";
    # Requires manual install of ManOpen.app and /usr/local/bin/openman.
    # Nix man paths aren't exposed in MANPATH but do appear in the output of
    # the manpath command.
    man = "/usr/local/bin/openman -M $(manpath 2>/dev/null)";
    nixswitch = "pushd ~/Documents/Development/nix; sudo darwin-rebuild switch --flake .#; popd";
    nixupdate = "pushd ~/Documents/Development/nix; nix flake update; nixswitch; popd";
    rm = "${pkgs.coreutils}/bin/rm -i";
    # locate = "${BREW_PREFIX}/bin/glocate -d /var/db/locate.database";
    # smbclient = "rlwrap /opt/local/bin/smbclient";
    beep = "/usr/bin/tput bel";
    grep = "${pkgs.gnugrep}/bin/grep --color=auto";

    # set terminal window and tab title
    winname = "printf \"\\033]2;%s\\a\"";
    # OSC 1 works for iTerm tabs but not panes, OSC 0 works for both
    tabname = "printf \"\\033]0;%s\\a\"";
}
