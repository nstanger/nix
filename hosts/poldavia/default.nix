{
    inputs,
    lib,
    paths,
    pkgs,
    username,
    ...
}:
let
    inherit (lib.my) processHomeFiles mkConfigFile;
    inherit (lib.path) append;
    inherit (paths) configs-path defaults-path home-manager-path homebrew-path;
in {
    users.users."${username}" = {
        home = "/Users/${username}";
        shell = pkgs.zsh;
        openssh.authorizedKeys.keyFiles = [
            # ./ssh/home_laptop.pub
        ];
    };
   
    environment.systemPath = [
        # "/opt/homebrew/bin"
        # "/opt/homebrew/sbin"
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
        brews = import (append homebrew-path "homebrew-brews-common.nix") ++ [
        ];
        casks = import (append homebrew-path "homebrew-casks-common.nix") ++ [
            "android-file-transfer"
            "arq"
            "carbon-copy-cloner"
            "docker"
            "fujitsu-scansnap-home" # not configured
            "hugin" # no config
            "iina"
            "makemkv" # minimal config
            "moneydance" # minimal config
            "onedrive"
            "opencore-configurator"
            "opencore-patcher"
            # "ransomwhere"
            "smcfancontrol"
            # "spamsieve"
            "steam" # settings in cloud
            "steelseries-gg" # no config
            "transcribe" # no config
            "utm"
            "unicodechecker" # no config
            "uninstallpkg" # no config
            "vuescan" # no config
        ];
        masApps = import (append homebrew-path "mas-apps-common.nix") // {
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
            home-manager-path
        ];
        home = {
            homeDirectory = "/Users/${username}";
            file = processHomeFiles {
                "previewtemplate.tex" = mkConfigFile (append configs-path "bibdesk") "Library/Application Support/BibDesk";
            };
            packages = with pkgs; import (append home-manager-path "packages-common.nix") pkgs ++ [
                # SOFTWARE
                # android-tools
                tvnamer #TESTING
                wakeonlan

                # FONTS
                open-sans
            ];
        };
        programs.taskwarrior.extraConfig = builtins.concatStringsSep "\n" [
            "context=home"
        ];
        programs.zsh.shellAliases = import (append configs-path "zsh/aliases-common.nix") pkgs // {
        };
        targets.darwin = {
            defaults = {
                NSGlobalDomain = {
                    "com.apple.sound.beep.sound" = "/Users/${username}/Library/Sounds/Eyuuurh.aiff";
                };
                "com.bombich.ccc" = import (append defaults-path "carbon-copy-cloner.nix");
                "com.colliderli.iina" = import (append defaults-path "iina.nix");
                "com.eidac.smcFanControl2" = import (append defaults-path "smcfancontrol.nix");
                "com.mactrackerapp.Mactracker" = import (append defaults-path "mactracker.nix");
                "com.michelf.sim-daltonism" = import (append defaults-path "sim-daltonism.nix");
                "com.microsoft.OneDrive" = import (append defaults-path "onedrive.nix");
                "com.utmapp.UTM" = import (append defaults-path "utm.nix");
                "org.clindberg.ManOpen" = import (append defaults-path "manopen.nix") username;
                "org.cups.PrintingPrefs".UseLastPrinter = 0;
            };
        };
    };
}
