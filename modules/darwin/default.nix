{
    pkgs,
    username,
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
            git
            gnused
        ];
        systemPath = [
            "/opt/homebrew/bin"
            "/opt/homebrew/sbin"
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
        # brews = [];
        casks = [
            "1password"
            "1password-cli"
            "dbeaver-community"
            "default-folder-x"
            "forklift"
            "inkscape" # install fails under home-manager
            "iterm2"
            "launchbar"
            "netbeans"
            "rectangle"
            "skim"
            "temurin8"
            "temurin11"
            "temurin17"
            "temurin21"
            "vivaldi"
            "visual-studio-code"
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
            "homebrew/cask-fonts"
            "homebrew/cask-versions"
        ];
    };

    users.users."${username}" = {
        home = "/Users/${username}";
        shell = pkgs.zsh;
        openssh.authorizedKeys.keyFiles = [
            ./ssh/work_desktop.pub
            ./ssh/home_laptop.pub
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

    security.pam.enableSudoTouchIdAuth = true;
    
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
            "com.apple.swipescrolldirection" = false;
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

        CustomSystemPreferences = {};

        CustomUserPreferences = {
            "com.apple.desktopservices" = {
                DSDontWriteNetworkStores = true;
                # DSDontWriteUSBStores = true;
            };
            "com.apple.finder" = {
                ShowExternalHardDrivesOnDesktop = true;
                ShowHardDrivesOnDesktop = true;
                ShowMountedServersOnDesktop = true;
                ShowRecentTags = false;
                # new windows default to user home
                NewWindowTarget = "PfHm";
                _FXSortFoldersFirst = true;
                # DesktopViewSettings.IconViewSettings = {
                #     arrangeBy = "kind";
                    # backgroundType = 0;
                    # iconSize = 64;
                    # labelOnBottom = 1;
                    # showIconPreview = 1;
                    # showItemInfo = 1;
                # };
                WarnOnEmptyTrash = false;
            };
            "com.apple.Safari" = {
                # Privacy: don’t send search queries to Apple
                UniversalSearchEnabled = false;
                SuppressSearchSuggestions = true;
                # Press Tab to highlight each item on a web page
                # WebKitTabToLinksPreferenceKey = true;
                ShowFullURLInSmartSearchField = true;
                # Prevent Safari from opening ‘safe’ files automatically after downloading
                AutoOpenSafeDownloads = false;
                # ShowFavoritesBar = false;
                IncludeInternalDebugMenu = true;
                IncludeDevelopMenu = true;
                WebKitDeveloperExtrasEnabledPreferenceKey = true;
                WebContinuousSpellCheckingEnabled = true;
                WebAutomaticSpellingCorrectionEnabled = false;
                AutoFillFromAddressBook = false;
                AutoFillCreditCardData = false;
                AutoFillMiscellaneousForms = false;
                WarnAboutFraudulentWebsites = true;
                WebKitJavaEnabled = false;
                WebKitJavaScriptCanOpenWindowsAutomatically = false;
                "com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks" = true;
                "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
                "com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled" = false;
                "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled" = false;
                "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles" = false;
                "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically" = false;
            };
        };
    };

    system.activationScripts = {
        extraActivation.enable = true;

        # huh, .source doesn't work...
        extraActivation.text = ''
            echo "activating extra preferences..."
            # Close any open System Preferences panes, to prevent them from overriding
            # settings we're about to change
            osascript -e 'tell application "System Settings" to quit'

            # Show the ~/Library folder
            # We really only ever need to do this *once*, but you never know...
            # chflags -f nohidden ~/Library && [[ $(xattr ~/Library) = *com.apple.FinderInfo* ]] && xattr -d com.apple.FinderInfo ~/Library

            # set Finder view preferences, but it doesn't seem to stick :(
            # defaults write "com.apple.finder" "DesktopViewSettings" -dict-add "IconViewSettings" \
            #     '{ arrangeBy = kind; backgroundColorBlue = 1; backgroundColorGreen = 1; backgroundColorRed = 1; backgroundType = 0; gridOffsetX = 0; gridOffsetY = 0; gridSpacing = 54; iconSize = 128; labelOnBottom = 1; showIconPreview = 1; showItemInfo = 1; textSize = 12; viewOptionsVersion = 1; }'

            # Display emails in threaded mode, sorted by date (newest at the top)
            # defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
            # defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "no"
            # defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

            # this doesn't seem to stick either :(:(
            defaults write com.apple.spotlight orderedItems -array \
                '{ enabled = 1; name = APPLICATIONS; }' \
                '{ enabled = 0; name = "MENU_SPOTLIGHT_SUGGESTIONS"; }' \
                '{ enabled = 0; name = "MENU_CONVERSION"; }' \
                '{ enabled = 0; name = "MENU_EXPRESSION"; }' \
                '{ enabled = 1; name = "MENU_DEFINITION"; }' \
                '{ enabled = 0; name = "SYSTEM_PREFS"; }' \
                '{ enabled = 1; name = DOCUMENTS; }' \
                '{ enabled = 1; name = DIRECTORIES; }' \
                '{ enabled = 1; name = PRESENTATIONS; }' \
                '{ enabled = 0; name = SPREADSHEETS; }' \
                '{ enabled = 1; name = PDF; }' \
                '{ enabled = 1; name = MESSAGES; }' \
                '{ enabled = 1; name = CONTACT; }' \
                '{ enabled = 1; name = "EVENT_TODO"; }' \
                '{ enabled = 1; name = IMAGES; }' \
                '{ enabled = 0; name = BOOKMARKS; }' \
                '{ enabled = 0; name = MUSIC; }' \
                '{ enabled = 0; name = MOVIES; }' \
                '{ enabled = 0; name = FONTS; }' \
                '{ enabled = 1; name = "MENU_OTHER"; }' \
                '{ enabled = 1; name = SOURCE; }'
        '';

        # https://medium.com/@zmre/nix-darwin-quick-tip-activate-your-preferences-f69942a93236
        postUserActivation.text = ''
            # Following line should allow us to avoid a logout/login cycle
            /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
        '';
    };
}
