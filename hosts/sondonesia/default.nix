{
    inputs,
    lib,
    paths,
    pkgs,
    ...
}:

with lib.path;
with paths; 
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
        brews = import (append darwin-p "homebrew-brews-common.nix") ++ [
        ];
        casks = import (append darwin-p "homebrew-casks-common.nix") ++ [
            "android-file-transfer"
            "arq"
            "carbon-copy-cloner"
            "diffusionbee"
            "discord"
            "docker"
            "dropbox" # settings in cloud
            "ears"
            "fujitsu-scansnap-home" # not configured
            "hugin" # no config
            "iina"
            "makemkv" # minimal config
            "moneydance" # minimal config
            "mongodb-compass" # minimal config
            "monitorcontrol"
            "mysqlworkbench" # minimal config
            "onedrive"
            # "ransomwhere"
            # "spamsieve"
            "steam" # settings in cloud
            "transcribe" # no config
            "utm"
            "unicodechecker" # no config
            "uninstallpkg" # no config
            "vuescan" # no config
            "warp"
            "whatsapp"
            "zed" # basic text editor for now # minimal config
        ];
        masApps = import (append darwin-p "mas-apps-common.nix") // {
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
            home-manager-p
        ];
        home = {
            homeDirectory = "/Users/${username}";
            file = with lib.my; processHomeFiles {
                "teaching.json" = mkITermDynamicProfile username;
            };
            packages = with pkgs; import (append home-manager-p "packages-common.nix") pkgs ++ [
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
        programs.zsh.shellAliases = import (append home-manager-p "configs/zsh/aliases-common.nix") pkgs // {
        };
        launchd.agents = {
            "task.sync" = import (append home-manager-p "configs/launchd/task-sync.nix") username;
        };
        targets.darwin = {
            defaults = {
                NSGlobalDomain = {
                    "com.apple.sound.beep.sound" = "/Users/${username}/Library/Sounds/Eyuuurh.aiff";
                };
                "com.bombich.ccc" = import (append apps "carbon-copy-cloner.nix");
                "com.clickontyler.Ears" = import (append apps "ears.nix");
                "com.colliderli.iina" = import (append apps "iina.nix");
                "com.mactrackerapp.Mactracker" = import (append apps "mactracker.nix");
                "com.michelf.sim-daltonism" = import (append apps "sim-daltonism.nix");
                "com.microsoft.OneDrive" = import (append apps "onedrive.nix");
                "com.utmapp.UTM" = import (append apps "utm.nix");
                "dev.warp.Warp-Stable" = import (append apps "warp.nix");
                "me.guillaumeb.MonitorControl" = import (append apps "monitorcontrol.nix");
                "net.whatsapp.WhatsApp" = import (append apps "whatsapp.nix");
                "org.clindberg.ManOpen" = import (append apps "manopen.nix") username;
                "org.cups.PrintingPrefs".UseLastPrinter = 0;
            };
        };
    };
}
