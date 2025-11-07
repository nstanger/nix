{
    lib,
    paths,
    pkgs,
    unstable,
    username,
    ...
}:
let
    inherit (lib.my) processHomeFiles mkConfigFile mkDir mkITermDynamicProfile mkShellScript;
    inherit (lib.meta) getExe getExe';
    inherit (lib.path) append;
    inherit (lib.attrsets) foldlAttrs;
    inherit (paths) defaults-path configs-path;

    hashdiff = pkgs.stdenv.mkDerivation rec {
        name = "hashdiff";
        src = pkgs.fetchgit {
            url = "https://isgb.otago.ac.nz/infosci/git/nigel.stanger/hashdiff.git";
            rev = "refs/tags/1.0";
            hash = "sha256-WxHe8IYuExJqfP57lzWL7KWhHuJlt90FV4v70pnyeNs=";
        };
        installPhase = ''
            mkdir -p $out/bin
            cp hashdiff $out/bin
        '';
    };

    quietlight = pkgs.vimUtils.buildVimPlugin {
        name = "quietlight";
        src = pkgs.fetchFromGitHub {
            owner = "aonemd";
            repo = "quietlight.vim";
            rev = "61b00ed7c9678c2b23a5ceec8b895001f76af56b";
            hash = "sha256-GlIF4Y9rjsg/m/ZghgE7v8Y05UXjULxuDuUXjfoX6SA=";
        };
    };
in
{
    home = {
        stateVersion = "23.11";

        # append anything weird using //
        file = processHomeFiles {
            # text-based config files
            ".agignore" = mkConfigFile (append configs-path "silver-searcher") "";
            "latexmkrc" = mkConfigFile (append configs-path "latexmk") ".config/latexmk";
            "logrotate.conf" = mkConfigFile (append configs-path "logrotate") ".config/logrotate";

            # directories
            "logrotate.d" = mkDir ".config/logrotate";
            "tmp" = mkDir "";
            ".zshrc.d" = mkDir "";

            # scripts to go in various bin locations
            "die-safari" = mkShellScript "bin";
            "preview" = mkShellScript "bin";
            "pu2pdf" = mkShellScript "bin";
            "svg2pdf" = mkShellScript "bin";

            # iTerm profiles using the mapAttrs trick
            "console.json" = mkITermDynamicProfile;
            "home-ssh.json" = mkITermDynamicProfile;
            "other-ssh.json" = mkITermDynamicProfile;
            "teaching.json" = mkITermDynamicProfile;
            "work-ssh.json" = mkITermDynamicProfile;
        };

        # Essential packages that ALL hosts must have.
        # Common packages shared across several hosts go in
        # packages-common.nix.
        # Host specific packages go in each host module.
        packages = with pkgs; [
            # SOFTWARE
            bfg-repo-cleaner
            blackbox
            dos2unix
            exiftool
            eza
            file
            getopt
            git-credential-oauth
            git-extras
            gnugrep
            gnumake
            gnutar
            gzip
            hashdiff # not *that* essential, but easier to add here
            openssl
            rlwrap
            rsync
            silver-searcher
            virtualenv
            wget
            zsh-completions
            zsh-defer
            zsh-you-should-use

            # FONTS
            # Open Sans is automatically provided on University managed
            # machines, so it has to be installed per host.
            roboto # Homebrew package breaks?
        ];

        sessionPath = [
            "$HOME/bin"
            "$HOME/.local/bin"
            "/Users/Shared/bin"
            "/Library/TeX/Distributions/Programs/texbin" # MacTeX installs in a weird place...
        ];

        sessionVariables = {
            # TEXMF paths
            TEXMFCONFIG = "$(/Library/TeX/Distributions/Programs/texbin/kpsewhich -expand-var '$TEXMFCONFIG')";
            TEXMFDIST = "$(/Library/TeX/Distributions/Programs/texbin/kpsewhich -expand-var '$TEXMFDIST')";
            TEXMFHOME = "$(/Library/TeX/Distributions/Programs/texbin/kpsewhich -expand-var '$TEXMFHOME')";
            TEXMFLOCAL = "$(/Library/TeX/Distributions/Programs/texbin/kpsewhich -expand-var '$TEXMFLOCAL')";
            TEXMFMAIN = "$(/Library/TeX/Distributions/Programs/texbin/kpsewhich -expand-var '$TEXMFMAIN')";
            TEXMFSYSCONFIG = "$(/Library/TeX/Distributions/Programs/texbin/kpsewhich -expand-var '$TEXMFSYSCONFIG')";
            TEXMFSYSVAR = "$(/Library/TeX/Distributions/Programs/texbin/kpsewhich -expand-var '$TEXMFSYSVAR')";
            TEXMFVAR = "$(/Library/TeX/Distributions/Programs/texbin/kpsewhich -expand-var '$TEXMFVAR')";

            # directory paths
            # On OUDW systems current year files will be symlinked under this path as
            # OneDrive and direnv don't interact well.
            ALL_PAPERS_ROOT = "$HOME/Documents/Teaching";
            TEACHING_SHARED = "$HOME/Documents/Teaching/Shared";

            # tool paths
            EDITOR = "code --wait --new-window";
            # GIT_EDITOR = "code --wait --new-window";
            # GRAPHVIZ_DOT = "${BREW_PREFIX}/bin/dot";
            # JAVA_HOME = $(/usr/libexec/java_home -v 17);
            # R_GSCMD = "${BREW_PREFIX}/bin/gs";
            # RSTUDIO_WHICH_R = "${BREW_PREFIX}/bin/R";
            # TEXDOCVIEW_pdf = "$HOME/bin/preview %s";
            TEXEDIT = "code --wait --goto %s:%d";

            # library paths
            CLASSPATH = "$HOME/Library/Java:.";
            # PERL5LIB = "${BREW_PREFIX}/lib/perl5";
            # export R_LIBS_SITE="${BREW_PREFIX}/lib/R/library"
            TCLLIBPATH = "/usr/lib";

            # misc configuration
            EXA_COLORS = import (append configs-path "eza/colours.nix");
            # ISPMS_HOST = "sobmac0011.staff.uod.otago.ac.nz";
            LESS="--no-init --raw-control-chars";
            LSCOLORS="ExGxFxDaCxDxDxxbaDacec";
            PAGER = "bat";
            # see <https://plantuml.com/security>; UNSECURE is fine
            PLANTUML_SECURITY_PROFILE = "UNSECURE";
            # Something broke virtualenvwrapper between nixpkgs 23.11 and
            # 24.05 :( and the solution appears to be to set this variable.
            VIRTUALENVWRAPPER_PYTHON=''${getExe' pkgs.python312Full "python3"}'';
            XSLT="saxon-b";
            # automatic completion suggestions: use a slightly lighter shade of grey
            ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=246";
        };

        activation = let
            /*  Some coreutils programs (e.g., cp, chmod, ...) somehow
                occasionally don't mask the macOS provided versions, so use
                coreutils --coreutils-prog=xxxx to run them. This is mainly
                to ensure --verbose is available (where supported).
            */
            coreutilsCmd = cmd: ''${getExe' pkgs.coreutils "coreutils"} --coreutils-prog=${cmd}'';
        in with builtins; {
            /*  Install DBeaver prefs files. We can't just symlink these because
                DBeaver recreates some of them on quit even when nothing has
                obviously changed :(. setconf lets us write directly to the
                prefs files, but for some reason -a is adding multiple entries?
                It still works regardless.
            */
            copyDBeaverPrefs = let
                dBeaverPrefs =  foldlAttrs (outeracc: file: prefs:
                                    outeracc ++ foldlAttrs (inneracc: key: value:
                                        inneracc ++ [{filename = "${file}"; "key" = key; "value" = value;}]
                                    ) [] prefs
                                ) [] (import (append configs-path "dbeaver") username);
                targetDir = ''$HOME/Library/DBeaverData/workspace6/.metadata/.plugins/org.eclipse.core.runtime/.settings'';
                mode = "644";
            in lib.hm.dag.entryAfter ["writeBoundary"] (concatStringsSep "" (map (pref: ''
                $DRY_RUN_CMD ${coreutilsCmd "mkdir"} -p $VERBOSE_ARG "${targetDir}"
                $DRY_RUN_CMD ${getExe pkgs.setconf} -a "${targetDir}/${pref.filename}" "${pref.key}" "${toString pref.value}"
                $DRY_RUN_CMD ${coreutilsCmd "chmod"} $VERBOSE_ARG ${mode} "${targetDir}/${pref.filename}"
            '') dBeaverPrefs));

            /*  Symlinking an input plugin file doesn't seem to register,
                so copy the file into place instead. Target file mode seems
                to default to 555, which makes overwriting tricky. Don't
                rebuild while Keyboard Settings is open?
                See com.apple.HIToolbox for input source defaults.
            */
            copyIso10646InputPlugin = let
                target = ''"$HOME/Library/Input Methods/ISO 10646.inputplugin"'';
                mode = "644";
            in lib.hm.dag.entryAfter ["writeBoundary"] ''
                $DRY_RUN_CMD ${coreutilsCmd "cp"} $VERBOSE_ARG ${append configs-path "keyboard/ISO10646.inputplugin"} ${target}
                $DRY_RUN_CMD ${coreutilsCmd "chmod"} $VERBOSE_ARG ${mode} ${target}
            '';

            # Create ~/.autodbbackup.d and ensure correct permissions.
            # Unfortunately this doesn't seem able to be done as host-specific
            # activation :(.
            createDotAutoDbBackupDotD = let
                target = ''$HOME/.autodbbackup.d'';
                modeDir = "700";
                modeFiles = "600";
            in lib.hm.dag.entryAfter ["writeBoundary"] ''
                $DRY_RUN_CMD ${coreutilsCmd "mkdir"} -p -m ${modeDir} ${target}
                $DRY_RUN_CMD ${coreutilsCmd "chmod"} $VERBOSE_ARG -f ${modeFiles} ${target}/*
            '';

            # Create per-user logrotate status file.
            createLogRotateDotStatus = let
                target = ''$HOME/.logrotate.status'';
                mode = "600";
            in lib.hm.dag.entryAfter ["writeBoundary"] ''
                $DRY_RUN_CMD ${coreutilsCmd "touch"} ${target}
                $DRY_RUN_CMD ${coreutilsCmd "chmod"} $VERBOSE_ARG ${mode} ${target}
            '';

            /*  Install NetBeans prefs files. Annoyingly it includes the major version
                in the path (so it changes all the time), and also scatters the files
                over a bunch of sub-directory trees:(.
            */
            # copyNetBeansPrefs = let
            #     version = "21";
            #     targetDir = ''"$HOME/Library/Application Support/NetBeans/${version}/config/Preferences/org/netbeans"'';
            #     mode = "644";
            # in lib.hm.dag.entryAfter ["writeBoundary"] (concatStringsSep "" (map (file: ''
            #     $DRY_RUN_CMD ${coreutilsCmd "cp"} $VERBOSE_ARG ${append configs-path "netbeans/${file}"} ${targetDir}/${file}
            #     $DRY_RUN_CMD ${coreutilsCmd "chmod"} $VERBOSE_ARG ${mode} ${targetDir}/${file}
            #     $DRY_RUN_CMD sed -i -e 's/@USERNAME@/${username}/' ${targetDir}/${file}
            # '') netbeansPrefs));

            # Relaunch the Finder to update view settings. (Sneaky naming hack
            # so that this runs after setDarwinDefaults.)
            updateFinderSettings = ''
                $DRY_RUN_CMD /usr/bin/osascript -e 'tell application "Finder" to quit'
                $DRY_RUN_CMD /usr/bin/open -g -a Finder
            '';
        };
    };

    programs.bat = {
        enable = true;
        # extraPackages = with pkgs.bat-extras; [ batdiff batman batgrep batwatch ];
        config = {
            theme = "QuietLight";
            italic-text = "always";
        };
        themes = {
            QuietLight = {
                src = pkgs.fetchFromGitHub {
                    owner = "colorsublime";
                    repo = "colorsublime-themes"; # Bat uses sublime syntax for its themes
                    rev = "949c70f12a8d8f5d8cfc966be45fd42cd3a6904c";
                    sha256 = null;
                };
                file = "themes/QuietLight.tmTheme";
            };
        };
    };

    programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
    };

    programs.fzf = {
        enable = true;
        enableZshIntegration = true;
    };

    programs.git = {
        enable = true;
        aliases = import (append configs-path "git/aliases.nix");
        extraConfig = import (append configs-path "git/extraConfig.nix");
        ignores = import (append configs-path "git/gitignore.nix");
        lfs.enable = true;
        package = unstable.gitAndTools.gitFull;
        userName = "Nigel Stanger";
        userEmail = "nigel.stanger@otago.ac.nz";
    };

    programs.gpg = {
        enable = true;
    };

    programs.java = {
        enable = true;
        package = pkgs.jdk21;
    };

    programs.jq.enable = true;
    programs.less.enable = true;
    # programs.lesspipe.enable = true; # way less reliable than bat

    programs.neovim = {
        enable = true;
        vimAlias = true;
        vimdiffAlias = true;
        plugins = with pkgs.vimPlugins; [ quietlight ];
        extraConfig = import (append configs-path "vim/vimrc.nix");
    };

    programs.pandoc.enable = true;
    programs.readline.enable = true;

    programs.ripgrep = {
        enable = true;
    };

    programs.starship = {
        enable = true;
        enableZshIntegration = true;
        settings = import (append configs-path "starship/settings.nix");
    };

    programs.taskwarrior = {
        enable = true;
        package = pkgs.taskwarrior3;
        colorTheme = "light-256";
        dataLocation = "~/.config/task";
        config = {
            sync.server.url = "https://task.stanger.org.nz";
            # Put sync.server.client_id and sync.encryption_secret in
            # .config/task/taskrc for security.
            # taskd = { # CHANGES in TW 3.0
            #     certificate = "~/.config/task/Nigel_Stanger.cert.pem";
            #     key = "~/.config/task/Nigel_Stanger.key.pem";
            #     ca = "~/.config/task/ca.cert.pem";
            #     credentials = "stanger.org.nz/Nigel Stanger/ffce3667-319b-456f-ad9f-ce815131db35";
            #     server = "taskd.stanger.org.nz:53589";
            # };
            context.home = {
                read = "+home";
                write = "+home";
            };
            context.work = {
                read = "+work";
                write = "+work";
            };
            context.nzoug = {
                read = "+nzoug";
                write = "+nzoug";
            };
            # suppress "You have more urgent tasks." message
            nag = "";
        };
    };

    programs.thefuck = {
        enable = true;
        enableZshIntegration = true;
    };

    programs.yt-dlp = {
        enable = true;
        extraConfig = import (append configs-path "yt-dlp/config");
    };

    programs.zsh = {
        enable = true;

        # Directory changing
        # add "cd" to bare directory names
        autocd = true;
        # directory search path (auto-complete directories, cf. tcsh)
        cdpath = [
            "~"
            "~/Documents"
            "~/Documents/Development"
            "~/Documents/Teaching"
        ];

        # this just enables completions, still need zsh-completions package
        enableCompletion = true;
        autosuggestion.enable = true;

        # Shell history
        history = {
            # expire duplicates first
            expireDuplicatesFirst = true;
            # extended history information
            extended = true;
            # do not store any duplications
            ignoreAllDups = true;
            # share history across multiple zsh sessions (implies INC_APPEND_HISTORY)
            share = false;
        };

        completionInit = builtins.readFile (append configs-path "zsh/completionInit.sh");
        initContent = let
            zshConfigEarlyInit = lib.mkOrder 500 ''
                source ${pkgs.zsh-defer}/share/zsh-defer/zsh-defer.plugin.zsh
            '';
            zshConfigBeforeCompInit = lib.mkOrder 550 (builtins.readFile (append configs-path "zsh/initExtraBeforeCompInit.sh"));
            zshConfig = let
                preExtra = builtins.readFile (append configs-path "zsh/initExtra.sh");
                pluginFiles = [
                    # additional plugins not already loaded elsewhere
                    "${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh"
                ];
                pluginSources = map (x: "zsh-defer source " + x) pluginFiles;
                plugins = builtins.concatStringsSep "\n" (pluginSources);
                # for anything that must be run AFTER a plugin loads
                postExtra = ''
                '';
            in lib.mkOrder 1000 ''
                ${preExtra}
                ${plugins}
                ${postExtra}
            '';
            zshConfigAfter = lib.mkOrder 1500 ''
            '';
        in lib.mkMerge [ zshConfigEarlyInit zshConfigBeforeCompInit zshConfig zshConfigAfter ];

        syntaxHighlighting.enable = true;

        shellAliases = import (append configs-path "zsh/aliases-essential.nix") pkgs;
    };

    programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
    };

    launchd = {
        enable = true;
        agents = {
            "logrotate" = import (append configs-path "launchd/logrotate.nix") username;
            "task.sync" = import (append configs-path "launchd/task-sync.nix") username; # NEEDS UPDATING TW 3.0
        };
    };

    targets.darwin = {
        currentHostDefaults = {
            NSGlobalDomain = {
                # Compactify menu extras somewhat.
                # <https://www.jessesquires.com/blog/2023/12/16/macbook-notch-and-menu-bar-fixes>
                NSStatusItemSpacing = 12;
                NSStatusItemSelectionPadding = 8;
            };
        };
        defaults = {
            NSGlobalDomain = import (append defaults-path "global.nix");
            "at.EternalStorms.Yoink" = import (append defaults-path "yoink.nix"); # small screen only?
            "at.obdev.LaunchBar" = import (append defaults-path "launchbar.nix");
            "com.apple.archiveutility" = import (append defaults-path "archive-utility.nix");
            "com.apple.desktopservices" = import (append defaults-path "desktopservices.nix");
            "com.apple.dock" = import (append defaults-path "dock.nix");
            "com.apple.dt.Xcode" = import (append defaults-path "xcode.nix");
            "com.apple.finder" = import (append defaults-path "finder.nix");
            "com.apple.FontBook" = import (append defaults-path "fontbook.nix");
            "com.apple.HIToolbox" = import (append defaults-path "hitoolbox.nix");
            "com.apple.inputsources" = import (append defaults-path "inputsources.nix");
            "com.apple.mail" = import (append defaults-path "mail.nix");
            "com.apple.Music".showStatusBar = 1;
            "com.apple.Preview" = import (append defaults-path "preview.nix");
            "com.apple.Safari" = import (append defaults-path "safari.nix");
            "com.apple.scriptmenu".ScriptMenuEnabled = 1;
            "com.apple.Spotlight" = import (append defaults-path "spotlight.nix");
            # always show window proxy icons (where available)
            "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = 1;
            "com.apple.universalaccess" = import (append defaults-path "universal-access.nix");
            "com.araeliumgroup.screenflick" = import (append defaults-path "screenflick.nix");
            "com.atow.msgfiler" = import (append defaults-path "msgfiler.nix");
            "com.binarynights.ForkLift" = import (append defaults-path "forklift.nix");
            "com.charlessoft.pacifist" = import (append defaults-path "pacifist.nix");
            "com.crystalidea.macsfancontrol" = import (append defaults-path "macs-fan-control.nix");
            "cx.c3.theunarchiver" = import (append defaults-path "theunarchiver.nix");
            "com.flexibits.fantastical2.mac" = import (append defaults-path "fantastical2.nix");
            "com.google.drivefs.settings" = import (append defaults-path "google-drive.nix");
            "com.googlecode.iterm2" = import (append defaults-path "iterm");
            "com.if.Amphetamine" = import (append defaults-path "amphetamine.nix");
            "com.knollsoft.Rectangle" = import (append defaults-path "rectangle.nix");
            "com.microsoft.Excel" = import (append defaults-path "excel.nix");
            "com.microsoft.Word" = import (append defaults-path "word.nix");
            "com.microsoft.office" = import (append defaults-path "office.nix");
            "com.microsoft.Powerpoint" = import (append defaults-path "powerpoint.nix");
            "com.modesittsoftware.Photo-GeoTag" = import (append defaults-path "photo-geotag.nix");
            "com.objective-see.oversight" = import (append defaults-path "oversight.nix");
            "com.noodlesoft.Hazel" = import (append defaults-path "hazel.nix");
            "com.pascal.freeruler" = import (append defaults-path "free-ruler.nix");
            "com.stclairsoft.DefaultFolderX5" = import (append defaults-path "default-folder-x.nix");
            "com.zeroonetwenty.BlueHarvest5" = import (append defaults-path "blueharvest.nix");
            "edu.ucsd.cs.mmccrack.bibdesk" = import (append defaults-path "bibdesk.nix");
            "com.vivaldi.Vivaldi".SUAutomaticallyUpdate = 0;
            "net.sourceforge.skim-app.skim" = import (append defaults-path "skim.nix");
            "org.herf.Flux" = import (append defaults-path "f.lux.nix");
            "org.localsend.localsendApp" = import (append defaults-path "localsend.nix");
            # not a hell of a lot else exposed via defaults :/
            "org.videolan.vlc".SUEnableAutomaticChecks = 1;
            "tracesOf.Uebersicht" = import (append defaults-path "ubersicht.nix");
            "uk.co.tla-systems.pcalc" = import (append defaults-path "pcalc.nix");
        };
        search = "Google";
    };
}
