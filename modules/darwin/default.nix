{ pkgs, ... }: {
    system.stateVersion = 4;
    
    programs.zsh.enable = true;
    environment = {
        shells = [ pkgs.bash pkgs.zsh ];
        loginShell = pkgs.zsh;
    };
    nix.settings = {
        build-users-group = "nixbld";
        experimental-features = [ "nix-command" "flakes" "auto-allocate-uids" ];
        extra-nix-path = "nixpkgs=flake:nixpkgs";
        bash-prompt-prefix = "(nix:$name)\040";
    };
    users.users.nstanger.home = "/Users/nstanger";
        environment.systemPackages = [ pkgs.coreutils ];
        fonts.fontDir.enable = true;
        fonts.fonts = [ (pkgs.nerdfonts.override { fonts = [ "Hack" ]; }) ];
        services.nix-daemon.enable = true;
        system.defaults.NSGlobalDomain = {
        AppleShowAllExtensions = true;
        "com.apple.swipescrolldirection" = true;
    };
    system.defaults.finder = {
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = true;
        FXPreferredViewStyle = "Nlsv";
        CreateDesktop = true;
        ShowStatusBar = true;
        ShowPathbar = true;
    };
    system.defaults.dock = {
        orientation = "right";
        showhidden = true;
        # mouse in top left corner will (5) start screensaver
        wvous-tl-corner = 5;
    };
    system.defaults.CustomUserPreferences = {
        "com.apple.finder" = {
            DSDontWriteNetworkStores = true;
        };
        "com.apple.finder" = {
            ShowExternalHardDrivesOnDesktop = true;
            ShowHardDrivesOnDesktop = true;
            ShowMountedServersOnDesktop = true;
            _FXSortFoldersFirst = true;
        };
        "com.apple.menuextra.clock" = {
            ShowAMPM = 1;
            ShowDate = 1;
            ShowDayOfWeek = 1;
            ShowSeconds = 1;
        };
    };
}
