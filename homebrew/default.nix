{
    pkgs,
    ...
}: {
    homebrew = {
        enable = true;
        /*  Essential brews and casks that ALL hosts must have. Common packages
            shared across several hosts go in # homebrew-{brews,casks}-common.nix.
            Host specific packages go in each host module.
        */
        brews = [
        ];
        casks = [
            # SOFTWARE
            "1password"
            "1password-cli"
            "blockblock"
            "default-folder-x"
            # "dropbox" # reached max number of devices
            "forklift"
            "google-drive"
            "hazel"
            "iterm2"
            "knockknock"
            "launchbar"
            "oversight"
            # "ransomwhere" # currently Intel-only
            "rectangle"
            "synology-drive"
            "temurin@21"
            "ubersicht"
            "visual-studio-code"
            "vivaldi" # config not in defaults

            /*  FONTS
                These may come as OpenType variable fonts, i.e., a single file
                covering all variants instead of discrete files for different
                weights/styles. Variable fonts aren't generally supported by
                LaTeX (maybe LuaLaTeX but definitely not XeLaTeX). The nix font
                packages appear to mostly provide non-variable fonts, so if a
                font really needs to work with XeLaTeX, prefer a nix version
                if available (see fonts.fonts and home-manager.home.packages).
            */
            "font-hack" # see fonts.fonts below for nerd font
            "font-inconsolata" # variable
            "font-iosevka"
        ];
        caskArgs.no_quarantine = true;
        global = {
            autoUpdate = false;
            brewfile = true;
        };
        # No global MAS apps because VMs can't connect to the App Store.
        # masApps = {};
        onActivation = {
            autoUpdate = false;
            upgrade = false;
            cleanup = "uninstall"; # should maybe be "zap" - remove anything not listed here
        };
        taps = [
            "homebrew/core"
            "homebrew/cask"
            "homebrew/bundle"
        ];
    };
}
