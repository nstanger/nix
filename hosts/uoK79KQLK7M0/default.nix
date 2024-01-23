{
    pkgs,
    inputs,
    ...
}: 
# let
#     makeUser = username: shell: authorizedKeys: {
#         users.users."${username}" = {
#             home = "/Users/${username}";
#             shell = pkgs.zsh;
#             openssh.authorizedKeys.keyFiles = authorizedKeys;
#     }
# in
let
    username = "stani07p";
in {
    users.users."${username}" = {
        home = "/Users/${username}";
        shell = pkgs.zsh;
        openssh.authorizedKeys.keyFiles = [
            # ./ssh/home_laptop.pub
        ];
    };
    
    environment.systemPath = [
        "/opt/homebrew/bin"
        "/opt/homebrew/sbin"
    ];

    # enable Touch ID for sudo in terminal
    security.pam.enableSudoTouchIdAuth = true;

    system.defaults = {
        trackpad = {
            Clicking = false;
            Dragging = false;
        };
        NSGlobalDomain = {
            # enable natural scrolling direction
            "com.apple.swipescrolldirection" = true;
            # disable tap to click - it changes the setting but doesn't seem to activate
            "com.apple.mouse.tapBehavior" = null;
        };

        CustomSystemPreferences = {
            NSGlobalDomain = {
                # correct key, but doesn't change in System Settings
                "com.apple.trackpad.forceClick" = 0;
            };
        };

        CustomUserPreferences = {
            "at.EternalStorms.Yoink" = import ../../darwin/apps/yoink.nix; # small screen only?
            "com.if.Amphetamine" = import ../../darwin/apps/amphetamine.nix; # laptop only
            "uk.co.tla-systems.pcalc" = import ../../darwin/apps/pcalc.nix;
        };
    };

    nix-homebrew = {
        # user owning the homebrew prefix
        user = username;
        # apple silicon only: also install homebrew under the default intel prefix for rosetta 2
        enableRosetta = false;
        # automatically migrate existing homebrew installations - first time only
        autoMigrate = false;
    };

    homebrew = {
        casks = [
            "docker"
            "mongodb-compass"
            "ransomwhere"
        ];
        masApps = {
            Amphetamine = 937984704;
            "eduVPN client" = 1317704208; # not configured
            Fantastical = 975937182;
            PCalc = 403504866;
            Mactracker = 430255202; # not configured
            MsgFiler = 418778021;
            "Sim Daltonism" = 693112260; # not configured
            Unicycle = 1472950010; # not configured
            Xcode = 497799835; # not configured
            Yoink = 457622435;
        };
    };

    home-manager.users."${username}" = {
        imports = [
            ../../home-manager
        ];
        home = {
            homeDirectory = "/Users/${username}";
            packages = with pkgs; [
                mongodb-tools
                mongosh
                tart
            ];
        };
        programs.git = {
            userName = "${username}";
            userEmail = "nigel.stanger@otago.ac.nz";
        };
        programs.taskwarrior.extraConfig = builtins.concatStringsSep "\n" [
            "context=work"
        ];
        launchd.agents = {
            "task.sync" = import ../../home-manager/configs/launchd/task-sync.nix username;
        };
    };
}
