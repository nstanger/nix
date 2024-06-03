{
    paths,
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
    username = "nstanger";
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

    # disable natural scrolling direction (for now)
    # system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = false;

    nix-homebrew = {
        # user owning the homebrew prefix
        user = username;
        # apple silicon only: also install homebrew under the default intel prefix for rosetta 2
        enableRosetta = false;
        # automatically migrate existing homebrew installations - once only?
        autoMigrate = false;
    };

    homebrew = {
        brews = import (paths.darwin + "/homebrew-brews-common.nix") ++ [
        ];
        casks = import (paths.darwin + "/homebrew-casks-common.nix") ++ [
            "android-file-transfer"
            "arq"
            "blueharvest"
            # "carbon-copy-cloner" # HTTP 404
            "diffusionbee"
            "discord"
            "docker"
            "dropbox" # settings are in the cloud
            "ears"
            "fujitsu-scansnap-home"
            "hugin"
            "iina"
            # "makemkv" # version mismatch
            "moneydance"
            "mongodb-compass"
            "monitorcontrol"
            "mysqlworkbench"
            "onedrive"
            # "ransomwhere"
            # "scroll" # not configured
            # "spamsieve"
            "steam"
            "transcribe"
            "utm"
            "unicodechecker"
            "uninstallpkg"
            "vuescan"
            "warp"
            # "whatsapp" # HTTP 500
            "zed" # basic text editor for now
        ];
        masApps = import (paths.darwin + "/mas-apps-common.nix") // {
            # "Apple Configurator" = 1289583905; # not configured
            # "Final Cut Pro" = 424389933; # not configured
            Mactracker = 430255202;
            # "Pixelmator Pro" = 1289583905; # not configured
            "Sim Daltonism" = 693112260;
            # "Slack for Desktop" = 803453959; # not configured
        };
    };

    home-manager.users."${username}" = {
        imports = [
            paths.home-manager
        ];
        home = {
            homeDirectory = "/Users/${username}";
            packages = with pkgs; import (paths.home-manager + "/packages-common.nix") pkgs ++ [
                # SOFTWARE
                tart
                tvnamer #TESTING
                wakeonlan

                # FONTS
                open-sans
            ];
        };
        programs.taskwarrior.extraConfig = builtins.concatStringsSep "\n" [
            "context=home"
        ];
        programs.zsh.shellAliases = with paths; import (home-manager + "/configs/zsh/aliases-common.nix") pkgs // {
        };
        launchd.agents = with paths; {
            "task.sync" = import (home-manager + "/configs/launchd/task-sync.nix") username;
        };
        targets.darwin = {
            defaults = with paths; {
                NSGlobalDomain = {
                    "com.apple.sound.beep.sound" = "/Users/${username}/Library/Sounds/Eyuuurh.aiff";
                };
                "com.mactrackerapp.Mactracker" = import (apps + "/mactracker.nix");
                "com.michelf.sim-daltonism" = import (apps + "/sim-daltonism.nix");
                "org.cups.PrintingPrefs".UseLastPrinter = 0;
            };
        };
    };
}
