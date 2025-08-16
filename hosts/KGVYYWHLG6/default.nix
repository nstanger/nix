{
    inputs,
    lib,
    paths,
    pkgs,
    username,
    ...
}:
let
    inherit (lib.my) processHomeFiles mkConfigFile mkDir mkShellScript;
    inherit (lib.meta) getExe getExe';
    inherit (lib.path) append;
    inherit (paths) configs-path defaults-path home-manager-path homebrew-path;

    # autopostgresqlbackup = pkgs.stdenv.mkDerivation rec {
    #     name = "autopostgresqlbackup";
    #     version = "2.3";
    #     buildInputs = [pkgs.pandoc];
    #     src = pkgs.fetchgit {
    #         url = "https://github.com/k0lter/autopostgresqlbackup.git";
    #         rev = "refs/tags/${version}";
    #         hash = "sha256-dTamqJQFQI+QWOSDAcUNFfeQd8WNa3mcGCfe7viRq4c=";
    #     };
    #     installPhase = ''
    #         mkdir -p $out/bin
    #         cp autopostgresqlbackup $out/bin
    #         mkdir -p $out/man/man8
    #         cp autopostgresqlbackup.8 $out/man/man8
    #     '';
    # };
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
                    # course-outlines	-fstype=smbfs,soft ://${username}@registry.otago.ac.nz/obs/obsdept/infosci/shared/AdminStaff/Course%20Outlines

                    infosci-datasets	-fstype=smbfs,soft ://${username}@storage.hcs-p01.otago.ac.nz/infosci/Datasets
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
    security.pam.services.sudo_local.touchIdAuth = true;

    nix-homebrew = {
        # user owning the homebrew prefix
        user = username;
        # apple silicon only: also install homebrew under the default intel prefix for rosetta 2
        enableRosetta = false;
        # automatically migrate existing homebrew installations - first time only
        autoMigrate = false;
    };

    homebrew = {
        brews = import (append homebrew-path "homebrew-brews-common.nix") ++ [
            # nixpkgs version broken on aarch64-darwin
            # Installs a buttload of crap just to give us ssconvert :(
            "gnumeric"
        ];
        casks = import (append homebrew-path "homebrew-casks-common.nix") ++ [
            "docker-desktop"
            "dropbox" # settings are in the cloud
            "ears"
            "mongodb-compass" # minimal config
            "mysqlworkbench" # minimal config
            "ollama-app" # minimal config
            # "ransomwhere"
            # "scroll"
            # "spamsieve"
            "steermouse"
            "zed" # basic text editor for now # minimal config
        ];
        masApps = import (append homebrew-path "mas-apps-common.nix") // {
            # "Apple Configurator" = 1037126344; # not configured
            # "Final Cut Pro" = 424389933; # not configured
            Klack = 6446206067; # not configured, but pretty simple
            Mactracker = 430255202;
            # "Pixelmator Pro" = 1289583905; # not configured
            "Sim Daltonism" = 693112260;
            # "Slack for Desktop" = 803453959; # not configured
            "WhatsApp Messenger" = 310633997;
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
            if grep -q auto_shares /etc/auto_master
            then
                echo 'SMB automount already configured'
            else
                echo 'configuring SMB automount...'
                echo '/System/Volumes/Data/mnt/shares    auto_shares    -nosuid,noowners' | sudo tee -a /etc/auto_master > /dev/null
            fi
            echo "mounting shared volumes..."
            sudo automount -vc
        '';
    };

    home-manager.users."${username}" = {
        imports = [
            home-manager-path
        ];
        home = {
            homeDirectory = "/Users/${username}";
            file = processHomeFiles {
                # This is bundled into the system activation, but still useful as a fallback.
                "fix-automount" = mkShellScript "bin";

                # BibDesk
                "previewtemplate.tex" = mkConfigFile (append configs-path "bibdesk") "Library/Application Support/BibDesk";
                "DPAbstractExportTemplate.html" = mkConfigFile (append configs-path "bibdesk") "Library/Application Support/BibDesk/Templates";
                "DPExportTemplate.html" = mkConfigFile (append configs-path "bibdesk") "Library/Application Support/BibDesk/Templates";
                "DPItemExportTemplate.html" = mkConfigFile (append configs-path "bibdesk") "Library/Application Support/BibDesk/Templates";

                # logrotate
                # autopostgresqlbackup and RustDesk are a pain because they already rotate
                # and timestamp their own log files. It might be possible to convince
                # logrotate to delete the old versions, but it turns out they're relatively
                # tiny (e.g., RustDesk hundreds of KB at worst), so who cares?
            };
            packages = with pkgs; import (append home-manager-path "packages-common.nix") pkgs ++ [
                # autopostgresqlbackup
                camunda-modeler
                macpm # Apple Silicon only
                mongodb-tools
                mongosh
                openai-whisper-cpp
                mariadb_114 # for the client, server(s) run in Docker
                postgresql_14 # for the client, server(s) run in Docker
                pwgen
                tart

                # FONTS
            ];
        };
        programs.taskwarrior.extraConfig = builtins.concatStringsSep "\n" [
            "context=work"
        ];
        programs.zsh.shellAliases = import (append configs-path "zsh/aliases-common.nix") pkgs // {
            fakesmtp = "java_home -v 11 -exec java -jar /Applications/fakeSMTP-2.0.jar";
        };
        targets.darwin = {
            defaults = {
                NSGlobalDomain = {
                    "com.apple.sound.beep.sound" = "/Users/${username}/Library/Sounds/Eyuuurh.aiff";
                    # correct key, but doesn't change in System Settings? (CHECK)
                    "com.apple.trackpad.forceClick" = 0;
                };
                # switch off all the infuriating Multitouch Mouse gestures
                "com.apple.AppleMultitouchMouse" = {
                    # This is currently disabled by Scroll but it probably just
                    # sets this anyway!
                    # MouseHorizontalScroll = 0;
                    MouseOneFingerDoubleTapGesture = 0;
                    MouseTwoFingerDoubleTapGesture = 0;
                    MouseTwoFingerHorizSwipeGesture = 0;
                };
                # Dodgy hack to make Touch ID work for sudo with a DisplayLink
                # dock (see https://apple.stackexchange.com/a/444202). No-one
                # seems to know what this actually does or what other effects
                # this might have. "Ard" perhaps refers to Apple Remote Desktop?
                # Update: this turns out to make sense given that the DisplayLink
                # appears to emulate a remote desktop connection.
                "com.apple.security.authorization".ignoreArd = true;
                "com.c-command.SpamSieve" = import (append defaults-path "spamsieve.nix");
                "com.clickontyler.Ears" = import (append defaults-path "ears.nix");
                "com.googlecode.iterm2".BootstrapDaemon = 0; # permits Touch ID for sudo
                "com.knollsoft.Scroll" = import (append defaults-path "scroll.nix");
                "com.if.Amphetamine" = {
                    "End Session On Low Battery" = 1;
                    "Ignore Battery on AC" = 1;
                    "Low Battery Percent" = 10;
                };
                "com.mactrackerapp.Mactracker" = import (append defaults-path "mactracker.nix");
                "com.michelf.sim-daltonism" = import (append defaults-path "sim-daltonism.nix");
                "net.whatsapp.WhatsApp" = import (append defaults-path "whatsapp.nix");
                "org.clindberg.ManOpen" = import (append defaults-path "manopen.nix") username;
                "org.cups.PrintingPrefs".UseLastPrinter = 0;
            };
            currentHostDefaults = {
                "com.apple.controlcenter".BatteryShowPercentage = true;
            };
        };
    };
}
