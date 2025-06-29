{
    lib,
    paths,
    pkgs,
    unstable,
    username,
    ...
}: let
    inherit (lib.attrsets) foldlAttrs;
    inherit (lib.meta) getExe';
    inherit (lib.path) append;
    inherit (paths) darwin-path;
in {
    system.stateVersion = 4;

    documentation = {
        enable = true;
        man.enable = true;
    };

    programs.zsh.enable = true;

    environment = {
        shells = with pkgs; [ bash zsh ];
        variables.SHELL = "${pkgs.zsh}/bin/zsh";
        
        pathsToLink = [
            "/Applications"
        ];
        
        systemPackages = with pkgs; [
            coreutils
            curl
            duti # file type mappings
            findutils # => GNU find, xargs
            findutils.locate # => GNU locate, updatedb
            gnused
            setconf # to edit key/value config files
        ];
        systemPath = [
            "/usr/local/sbin"
            "/usr/libexec"
        ];
    };
    
    nix = {
        enable = false;
        # optimise.automatic = true;
        settings = {
            bash-prompt-prefix = "(nix:$name)\\040";
            build-users-group = "nixbld";
            experimental-features = [ "nix-command" "flakes" "auto-allocate-uids" ];
            extra-nix-path = "nixpkgs=flake:nixpkgs";
        };
    };
    
    fonts = {
        packages = with pkgs; [
            # terminal nerd font
            nerd-fonts.hack
        ];
    };

    # system.keyboard.enableKeyMapping = true;
    
    system.defaults = {
        # also see home-manager.targets.darwin.defaults
        NSGlobalDomain = {
            AppleMeasurementUnits = "Centimeters";
            AppleMetricUnits = 1;
            AppleShowAllExtensions = true;
            AppleShowScrollBars = "Always";
            AppleTemperatureUnit = "Celsius";
            # automatic substitutions
            NSAutomaticCapitalizationEnabled = false;
            NSAutomaticDashSubstitutionEnabled = false; # otherwise "--" => em dash (bleh)
            NSAutomaticPeriodSubstitutionEnabled = false; # on double-space
            NSAutomaticQuoteSubstitutionEnabled = true;
            NSAutomaticSpellingCorrectionEnabled = true;
            # keep apps alive even when inactive
            NSDisableAutomaticTermination = true;
            # just say no to iCloud
            NSDocumentSaveNewDocumentsToCloud = false;
            # expand save and print dialogs by default
            NSNavPanelExpandedStateForSaveMode = true;
            NSNavPanelExpandedStateForSaveMode2 = true;
            PMPrintingExpandedStateForPrint = true;
            PMPrintingExpandedStateForPrint2 = true;
            # scroll direction is host specific
            # "com.apple.swipescrolldirection" = false;
            # F1, F2, etc. keys are standard function keys
            "com.apple.keyboard.fnState" = true;
        };
        # also see home-manager.targets.darwin.defaults
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

        # home-manager.targetrs.darwin.defaults seems to do a better job than
        # CustomSystemPreferences for non-specified defaults
        # CustomSystemPreferences = {};
    };

    system.primaryUser = username;

    system.activationScripts = {
        extraActivation = {
            enable = true;
            text = let
                userLibrary = "/Users/${username}/Library";
            in ''
                echo "activating extra system preferences..."

                # Microsoft AutoUpdate daemon check once per week instead of *every 2 hours*.
                # NOTE: Editing plist files with defaults is officially deprecated and will
                # be moved to a different tool at some stage.
                defaults write /Library/LaunchAgents/com.microsoft.update.agent.plist StartInterval -int 604800
                # For some reason the previous command changes the permissions to 600.
                chmod 644 /Library/LaunchAgents/com.microsoft.update.agent.plist

                # Enable plugins in Mail.
                # The following line will cease to work at some stage, but plugins
                # will probably also be gone by then anyway.
                sudo defaults write "/Library/Preferences/com.apple.mail.plist" EnableBundles 1

                # Enable CUPS web interface.
                cupsctl WebInterface=yes

                echo "activating extra user preferences..."

                # Close any open System Preferences panes, to prevent them from overriding
                # settings we're about to change
                osascript -e 'tell application "System Settings" to quit'

                # Show the ~/Library folder
                # We really only ever need to do this *once*, but you never know...
                sudo -u ${username} chflags -f nohidden ${userLibrary} && [[ $(xattr ${userLibrary}) = *com.apple.FinderInfo* ]] && xattr -d com.apple.FinderInfo ${userLibrary}
            '';
        };

        # https://medium.com/@zmre/nix-darwin-quick-tip-activate-your-preferences-f69942a93236
        postActivation = let
            utiMappings = import (append darwin-path "utis.nix");
        in {
            enable = true;
            text = with builtins; ''
                echo "activating settings..."

                # Following line should allow us to avoid a logout/login cycle
                /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
            '' +
            # Default file type (UTI) mappings; **requires duti package** (systemPackages)
            concatStringsSep "\n" (foldlAttrs (dutiCmds: bundleId: utiList: dutiCmds ++ map (uti: ''${getExe' pkgs.duti "duti"} -s ${bundleId} ${uti} all'') utiList) [] utiMappings);
        };
    };
}
