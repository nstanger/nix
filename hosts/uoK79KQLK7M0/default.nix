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
    
    environment = {
        etc = {
            "auto_shares" = {
                enable = true;
                text = ''
                    ${username}	-fstype=smbfs,soft ://${username}@registry.otago.ac.nz/obs/obsuser/${username}

                    infosci-shared	-fstype=smbfs,soft ://${username}@registry.otago.ac.nz/obs/obsdept/infosci/shared
                    infosci-software	-fstype=smbfs,soft ://${username}@registry.otago.ac.nz/obs/obsdept/infosci/software
                    calt-course-advising	-fstype=smbfs,soft ://${username}@registry.otago.ac.nz/obs/obsdept/shared_projects/caltcourseadvising
                    staff-desktop	-fstype=smbfs,soft ://${username}@registry.otago.ac.nz/mdr/Profiles-V2/s/${username}
                    #course-outlines	-fstype=smbfs,soft ://${username}@registry.otago.ac.nz/obs/obsdept/infosci/shared/AdminStaff/Course%20Outlines

                    infosci-python	-fstype=smbfs,soft ://${username}@storage.hcs-p01.otago.ac.nz/infosci-python
                    its-software	-fstype=smbfs,soft ://${username}@storage.hcs-p01.otago.ac.nz/its-software
                    lecture-dropboxes	-fstype=smbfs,soft ://${username}@storage.hcs-p01.otago.ac.nz/its-alldropboxes
                    student-teaching	-fstype=smbfs,soft ://${username}@storage.hcs-p01.otago.ac.nz/stud-shared

                    water-quality	-fstype=smbfs,soft ://${username}@storage.hcs-wlg.otago.ac.nz/uow-ph-drinkingwater

                    warpdrive	-fstype=smbfs,soft ://${username}@inf-ufs-p02.registry.otago.ac.nz/sci-shared/Users/${username}
                    coursework	-fstype=smbfs,soft ://${username}@inf-ufs-p02.registry.otago.ac.nz/sci-shared/Coursework
                '';
            };
        };
        systemPath = [
            "/opt/homebrew/bin"
            "/opt/homebrew/sbin"
        ];
    };

    # enable Touch ID for sudo in terminal
    # (but also see targets.darwin.defaults below for additional hackery)
    security.pam.enableSudoTouchIdAuth = true;

    nix-homebrew = {
        # user owning the homebrew prefix
        user = username;
        # apple silicon only: also install homebrew under the default intel prefix for rosetta 2
        enableRosetta = false;
        # automatically migrate existing homebrew installations - first time only
        autoMigrate = false;
    };

    homebrew = {
        brews = import ../../darwin/homebrew-brews-common.nix ++ [
        ];
        casks = import ../../darwin/homebrew-casks-common.nix ++ [
            "docker"
            "dropbox" # settings are in the cloud
            "mongodb-compass"
            # "ransomwhere"
            "spamsieve"
            "zed" # basic text editor for now
        ];
        masApps = import ../../darwin/mas-apps-common.nix // {
            # "Apple Configurator" = 1289583905; # not configured
            # "Final Cut Pro" = 424389933; # not configured
            Mactracker = 430255202;
            # "Pixelmator Pro" = 1289583905; # not configured
            "Sim Daltonism" = 693112260;
            # "Slack for Desktop" = 803453959; # not configured
        };
    };

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
    };

    system.activationScripts.postActivation = {
        enable = true;
        text = ''
            # reload automount configuration
            echo "mounting shared volumes..."
            sudo automount -vc
        '';
    };

    home-manager.users."${username}" = {
        imports = [
            ../../home-manager
        ];
        home = {
            homeDirectory = "/Users/${username}";
            packages = with pkgs; import ../../home-manager/packages-common.nix pkgs ++ [
                camunda-modeler
                mongodb-tools
                mongosh
                postgresql_14 # for the client, server(s) run in Docker
                tart
            ];
        };
        programs.taskwarrior.extraConfig = builtins.concatStringsSep "\n" [
            "context=work"
        ];
        programs.zsh.shellAliases = import ../../home-manager/configs/zsh/aliases-common.nix pkgs // {
        };
        launchd.agents = {
            "task.sync" = import ../../home-manager/configs/launchd/task-sync.nix username;
        };
        targets.darwin = {
            defaults = {
                NSGlobalDomain = {
                    "com.apple.sound.beep.sound" = "/Users/${username}/Library/Sounds/Eyuuurh.aiff";
                    # correct key, but doesn't change in System Settings? (CHECK)
                    "com.apple.trackpad.forceClick" = 0;
                };
                # Dodgy hack to make Touch ID work for sudo with a DisplayLink
                # dock (see https://apple.stackexchange.com/a/444202). No-one
                # seems to know what this actually does or what other effects
                # this might have. "Ard" perhaps refers to Apple Remote Desktop?
                "com.apple.security.authorization".ignoreArd = true;
                "com.c-command.SpamSieve" = import ../../apps/spamsieve.nix;
                "com.googlecode.iterm2".BootstrapDaemon = 0; # theoretically permits Touch ID for sudo
                "com.if.Amphetamine" = {
                    "End Session On Low Battery" = 1;
                    "Ignore Battery on AC" = 1;
                    "Low Battery Percent" = 10;
                };
                "com.mactrackerapp.Mactracker" = import ../../apps/mactracker.nix;
                "com.michelf.sim-daltonism" = import ../../apps/sim-daltonism.nix;
                "org.cups.PrintingPrefs".UseLastPrinter = 0;
            };
            currentHostDefaults = {
                "com.apple.controlcenter".BatteryShowPercentage = true;
            };
        };
    };
}
