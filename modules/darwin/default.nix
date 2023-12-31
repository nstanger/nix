{
    pkgs,
    ...
}: {
    system.stateVersion = 4;

    documentation = {
        enable = true;
        man.enable = true;
    };

    programs.zsh.enable = true;

    environment = {
        shells = with pkgs; [ bash zsh ];
        loginShell = "${pkgs.zsh}/bin/zsh -l";
        variables.SHELL = "${pkgs.zsh}/bin/zsh";
        
        pathsToLink = [
            "/Applications"
        ];
        
        systemPackages = with pkgs; [
            curl
            coreutils
            findutils
            git
            gnused
        ];
        systemPath = [
            "/usr/local/sbin"
            "/usr/libexec"
        ];
    };
    
    nix.settings = {
        auto-optimise-store = true;
        bash-prompt-prefix = "(nix:$name)\\040";
        build-users-group = "nixbld";
        experimental-features = [ "nix-command" "flakes" "auto-allocate-uids" ];
        extra-nix-path = "nixpkgs=flake:nixpkgs";
    };
    
    homebrew = {
        enable = true;
        brews = [
            # can't install via nix on aarch64-darwin even though the
            # package is available - missing dependency acl?
            "logrotate"
        ];
        casks = [
            "1password"
            "1password-cli"
            "blockblock"
            "calcservice"
            "cardhop" # not configured
            "dbeaver-community" # not configured
            "default-folder-x"
            # "dropbox"
            "flux"
            "forklift"
            "google-drive"
            "hazel"
            "inkscape" # install fails under home-manager
            "iterm2" # not configured
            "knockknock"
            "launchbar"
            "muzzle"
            "netbeans" # not configured
            "oversight" # not configured
            # currently Intel-only
            # "ransomwhere"
            "rectangle" # not configured
            "skim"
            "synology-drive"
            # temurin8 requires Rosetta 2 on macOS 13, and isn't supported
            # at all on 14+; can enable on x86 hosts
            "temurin11"
            "temurin17"
            "temurin21"
            "ubersicht" # not configured
            "vivaldi"
            "visual-studio-code"
            "wordservice"
            "zoom"
        ];
        caskArgs.no_quarantine = true;
        global = {
            autoUpdate = false;
            brewfile = true;
        };
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
            "homebrew/cask-fonts"
            "homebrew/cask-versions"
        ];
    };

    fonts = {
        fontDir.enable = true;
        fonts = with pkgs; [
            iosevka
            (nerdfonts.override { fonts = [ "Hack" ]; })
            open-sans
            roboto
        ];
    };

    # security.pam.enableSudoTouchIdAuth = true;
    
    services.nix-daemon.enable = true;

    # system.keyboard.enableKeyMapping = true;
    
    system.defaults = {
        NSGlobalDomain = {
            AppleShowAllExtensions = true;
            AppleShowScrollBars = "Always";
            # automatic substitutions
            NSAutomaticDashSubstitutionEnabled = false; # otherwise "--" => em dash (bleh)
            NSAutomaticPeriodSubstitutionEnabled = false; # on double-space
            # keep apps alive even when inactive
            NSDisableAutomaticTermination = true;
            # just say no to iCloud
            NSDocumentSaveNewDocumentsToCloud = false;
            # expand save and print dialogs by default
            NSNavPanelExpandedStateForSaveMode = true;
            NSNavPanelExpandedStateForSaveMode2 = true;
            PMPrintingExpandedStateForPrint = true;
            PMPrintingExpandedStateForPrint2 = true;
            # disable natural scrolling direction (for now)
            # "com.apple.swipescrolldirection" = false;
            "com.apple.keyboard.fnState" = true;
        };
        finder = {
            AppleShowAllExtensions = true;
            # CreateDesktop = true;
            # "SCcf" = restrict Finder search to current folder
            FXDefaultSearchScope = "SCcf";
            FXEnableExtensionChangeWarning = false;
            # "Nlsv" = list view
            FXPreferredViewStyle = "Nlsv";
            # QuitMenuItem = true;
            ShowStatusBar = true;
            ShowPathbar = true;
        };
        dock = {
            appswitcher-all-displays = true;
            launchanim = false;
            minimize-to-application = true;
            # don't auto-rearrange spaces based on recent usage
            mru-spaces = false;
            mouse-over-hilite-stack = true;
            orientation = "right";
            # don't show recent apps
            show-recents = false;
            showhidden = true;
            tilesize = 48;
            # mouse in bottom right corner will (6) disable screensaver
            wvous-br-corner = 6;
            # mouse in top left corner will (5) start screensaver
            wvous-tl-corner = 5;
        };
        loginwindow = {
            GuestEnabled = false;
            # username + password
            SHOWFULLNAME = true;
        };
        menuExtraClock = {
            ShowAMPM = true;
            ShowDate = 1;
            ShowDayOfWeek = true;
            ShowSeconds = true;
        };
        screencapture.type = "png";
        # universalaccess.closeViewScrollWheelToggle = true;
        ActivityMonitor.IconType = 3; # disk activity

        CustomSystemPreferences = {
            NSGlobalDomain = {
                AppleHighlightColor = "0.75 0.498039 1.000000 Other";
            };
        };

        CustomUserPreferences = {
            # see extraUserActivation below for "complicated" settings
            "com.apple.desktopservices" = {
                DSDontWriteNetworkStores = true;
                # DSDontWriteUSBStores = true;
            };
            "com.apple.scriptmenu".ScriptMenuEnabled = 1;
            # note: move MAS apps into host-specific
            "at.obdev.LaunchBar" = import ./apps/launchbar.nix;
            "com.apple.finder" = import ./apps/finder.nix;
            "com.apple.Preview" = import ./apps/preview.nix;
            "com.apple.Safari" = import ./apps/safari.nix;
            "com.google.drivefs.settings" = import ./apps/googledrive.nix;
            "com.incident57.Muzzle" = import ./apps/muzzle.nix;
            "com.knollsoft.Rectangle" = import ./apps/rectangle.nix;
            "com.microsoft.Excel" = import ./apps/excel.nix;
            "com.microsoft.Word" = import ./apps/word.nix;
            "com.microsoft.office" = import ./apps/office.nix;
            "com.microsoft.Powerpoint" = import ./apps/powerpoint.nix;
            "com.objective-see.oversight" = import ./apps/oversight.nix;
            "com.noodlesoft.Hazel" = import ./apps/hazel.nix;
            "com.stclairsoft.DefaultFolderX5" = import ./apps/defaultfolderx.nix;
            "net.sourceforge.skim-app.skim" = import ./apps/skim.nix;
            "org.herf.Flux" = import ./apps/f.lux.nix;
            "tracesOf.Uebersicht" = import ./apps/ubersicht.nix;
        };
    };

    system.activationScripts = {
        extraActivation = {
            enable = true;
            text = ''
                echo "activating extra system preferences..."

                # Microsoft AutoUpdate daemon check once per week instead of *every 2 hours*.
                # NOTE: Editing plist files with defaults is officially deprecated and will
                # be moved to a different tool at some stage.
                defaults write /Library/LaunchAgents/com.microsoft.update.agent.plist StartInterval -int 604800
                # For some reason the previous command changes the permissions to 600.
                chmod 644 /Library/LaunchAgents/com.microsoft.update.agent.plist
            '';
        };

        extraUserActivation = {
            enable = true;

            # huh, .source doesn't work...
            # How to make this host-specific?? Multiple scripts?
            # Technically it doesn't matter that much but it will create
            # a bunch of irrelevent PLIST files in ~/Library/Preferences.
            # This might make more sense as home manager.activation scripts?
            # define shell functions write defaults.
            text = ''
                echo "activating extra user preferences..."
                # create per-user logrotate status file
                touch ~/.logrotate.status && chmod 600 ~/.logrotate.status

                # Close any open System Preferences panes, to prevent them from overriding
                # settings we're about to change
                osascript -e 'tell application "System Settings" to quit'

                # Show the ~/Library folder
                # We really only ever need to do this *once*, but you never know...
                # chflags -f nohidden ~/Library && [[ $(xattr ~/Library) = *com.apple.FinderInfo* ]] && xattr -d com.apple.FinderInfo ~/Library

                # Display emails in threaded mode, sorted by date (newest at the top)
                # defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
                # defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "no"
                # defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

                # easiest way to refactor the complicated stuff...
                for f in modules/darwin/apps/*.sh; do source $f; done
            '';
        };

        # https://medium.com/@zmre/nix-darwin-quick-tip-activate-your-preferences-f69942a93236
        postUserActivation = {
            enable = true;
            text = ''
                # Following line should allow us to avoid a logout/login cycle
                /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
            '';
        };
    };
}
