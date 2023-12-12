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
            "at.EternalStorms.Yoink" = import ../../modules/darwin/apps/yoink.nix; # small screen only?
            "com.if.Amphetamine" = import ../../modules/darwin/apps/amphetamine.nix; # laptop only
            "uk.co.tla-systems.pcalc" = import ../../modules/darwin/apps/pcalc.nix;
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
            "ransomwhere"
        ];
        masApps = {
            Amphetamine = 937984704;
            "eduVPN client" = 1317704208; # not configured
            Fantastical = 975937182; # not configured
            PCalc = 403504866;
            Mactracker = 430255202; # not configured
            "Sim Daltonism" = 693112260; # not configured
            Unicycle = 1472950010; # not configured
            Xcode = 497799835; # not configured
            Yoink = 457622435;
        };
    };

    home-manager.users."${username}" = {
        imports = [
            ../../modules/home-manager
        ];
        home.homeDirectory = "/Users/${username}";
        programs.git = {
            userName = "${username}";
            userEmail = "nigel.stanger@otago.ac.nz";
        };
        programs.taskwarrior.config.taskd = {
            key = "/Users/${username}/.config/task/Nigel_Stanger.key.pem";
            ca = "/Users/${username}/.config/task/ca.cert.pem";
            extraConfig = builtins.concatStringsSep "\n" [ "nag=" "context=home" ];
        };
    };
}
