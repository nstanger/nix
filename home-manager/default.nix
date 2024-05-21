{
    pkgs,
    lib,
    ...
}:
let
    # these need to be refactored into some kind of utility library
    processHomeFiles = builtins.mapAttrs (name: fn: fn name);

    # Add a text-based config file
    mkConfigFile = sourcePath: targetPath: name: {
        text = builtins.readFile ./${sourcePath}/${name};
        target = "${targetPath}/${name}";
    };

    # Add a required directory using the invisible file trick
    mkDir = targetPath: name: {
        text = "";
        target = "${targetPath}/${name}/.nix-keep";
    };
    
    # Add iTerm dynamic profiles (JSON)
    mkITermDynamicProfile = name: {
        source = ../apps/iterm/dynamic-profiles/${name};
        target = "Library/Application Support/iTerm2/DynamicProfiles/${name}";
    };

    # Add shell scripts in specified location
    # see https://nixos.org/manual/nixpkgs/stable/#trivial-builder-writeText
    # and https://discourse.nixos.org/t/how-to-invoke-script-installed-with-writescriptbin-inside-other-config-file/8795/2
    # writeShellScript automatically inserts a shebang line
    mkShellScript = targetPath: name: {
        executable = true;
        source = pkgs.writeShellScript "${name}" (builtins.readFile ./binfiles/${name});
        target = "${targetPath}/${name}";
    };

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
            ".agignore" = mkConfigFile "./configs/silver-searcher" "";
            "logrotate.conf" = mkConfigFile "./configs/logrotate" ".config/logrotate";

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
            ALL_PAPERS_ROOT = "$HOME/Documents/Teaching";
            TEACHING_SHARED = "$HOME/Documents/Teaching/Shared";

            # tool paths
            EDITOR = "code --wait --new-window";
            # GIT_EDITOR = "code --wait --new-window";
            # GRAPHVIZ_DOT = "${BREW_PREFIX}/bin/dot";
            # JAVA_HOME = $(/usr/libexec/java_home -v 17);
            # R_GSCMD = "${BREW_PREFIX}/bin/gs";
            # RSTUDIO_WHICH_R = "${BREW_PREFIX}/bin/R";
            TEXDOCVIEW_pdf = "$HOME/bin/preview %s";
            TEXEDIT = "code --wait --goto %s:%d";

            # library paths
            CLASSPATH = "$HOME/Library/Java:.";
            # PERL5LIB = "${BREW_PREFIX}/lib/perl5";
            # export R_LIBS_SITE="${BREW_PREFIX}/lib/R/library"
            TCLLIBPATH = "/usr/lib";

            # misc configuration
            EXA_COLORS = import ./configs/eza/colours.nix;
            ISPMS_HOST = "sobmac0011.staff.uod.otago.ac.nz";
            LESS="--no-init --raw-control-chars";
            LSCOLORS="ExGxFxDaCxDxDxxbaDacec";
            PAGER = "bat";
            XSLT="saxon-b";
            # automatic completion suggestions: use a slightly lighter shade of grey
            ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=246";
        };

        activation = let
            # Some coreutils programs (e.g., cp, chmod, ...) somehow
            # don't mask the macOS provided versions, so use
            # coreutils --coreutils-prog=xxxx to run them. This is mainly
            # to ensure --verbose is available (where supported).
            coreutilsCmd = cmd: "coreutils --coreutils-prog=${cmd}";
        in {
            # Symlinking an input plugin file doesn't seem to register,
            # so copy the file into place instead. Target file mode seems
            # to default to 555, which makes overwriting tricky. Don't
            # rebuild while Keyboard Settings is open?
            # See com.apple.HIToolbox for input source defaults.
            copyIso10646InputPlugin = let
                target = ''"$HOME/Library/Input Methods/ISO 10646.inputplugin"'';
                mode = "644";
            in lib.hm.dag.entryAfter ["writeBoundary"] ''
                $DRY_RUN_CMD ${coreutilsCmd "cp"} $VERBOSE_ARG \
                    ${builtins.toPath ./configs/keyboard/ISO10646.inputplugin} ${target}
                $DRY_RUN_CMD ${coreutilsCmd "chmod"} $VERBOSE_ARG ${mode} ${target}
            '';

            # Create per-user logrotate status file.
            createLogRotateDotStatus = let
                target = ''$HOME/.logrotate.status'';
                mode = "600";
            in lib.hm.dag.entryAfter ["writeBoundary"] ''
                $DRY_RUN_CMD touch ${target}
                $DRY_RUN_CMD ${coreutilsCmd "chmod"} $VERBOSE_ARG ${mode} ${target}
            '';

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
        aliases = import ./configs/git/aliases.nix;
        extraConfig = import ./configs/git/extraConfig.nix;
        ignores = import ./configs/git/gitignore.nix;
        lfs.enable = true;
        package = pkgs.gitAndTools.gitFull;
        userName = "Nigel Stanger";
        userEmail = "nigel.stanger@otago.ac.nz";
    };

    programs.gpg = {
        enable = true;
    };

    programs.java = {
        enable = true;
        package = pkgs.jdk17;
    };

    programs.jq.enable = true;
    programs.less.enable = true;
    # programs.lesspipe.enable = true; # way less reliable than bat

    programs.neovim = {
        enable = true;
        vimAlias = true;
        vimdiffAlias = true;
        plugins = with pkgs.vimPlugins; [ quietlight ];
        extraConfig = import ./configs/vim/vimrc.nix;
    };

    programs.pandoc.enable = true;
    programs.readline.enable = true;

    programs.ripgrep = {
        enable = true;
    };

    programs.starship = {
        enable = true;
        enableZshIntegration = true;
        settings = import ./configs/starship/settings.nix;
    };

    programs.taskwarrior = {
        enable = true;
        colorTheme = "light-256";
        dataLocation = "~/.config/task";
        config = {
            taskd = {
                certificate = "~/.config/task/Nigel_Stanger.cert.pem";
                key = "~/.config/task/Nigel_Stanger.key.pem";
                ca = "~/.config/task/ca.cert.pem";
                credentials = "stanger.org.nz/Nigel Stanger/ffce3667-319b-456f-ad9f-ce815131db35";
                server = "taskd.stanger.org.nz:53589";
            };
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
        extraConfig = import ./configs/yt-dlp/config;
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
        enableAutosuggestions = true;

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

        initExtraBeforeCompInit = builtins.readFile ./configs/zsh/initExtraBeforeCompInit.sh;
        completionInit = builtins.readFile ./configs/zsh/completionInit.sh;
        initExtraFirst = ''
            source ${pkgs.zsh-defer}/share/zsh-defer/zsh-defer.plugin.zsh
        '';
        initExtra = let
            preExtra = builtins.readFile ./configs/zsh/initExtra.sh;
            pluginFiles = [
                # additional plugins not already loaded elsewhere
                "${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh"
            ];
            pluginSources = map (x: "zsh-defer source " + x) pluginFiles;
            plugins = builtins.concatStringsSep "\n" (pluginSources);
            # for anything that must be run AFTER a plugin loads
            postExtra = ''
            '';
        in ''
            ${preExtra}
            ${plugins}
            ${postExtra}
        '';

        syntaxHighlighting.enable = true;

        shellAliases = import ./configs/zsh/aliases-essential.nix pkgs;
    };

    programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
    };

    launchd.enable = true;

    targets.darwin = {
        defaults = {
            NSGlobalDomain = import ../apps/global.nix;
            "at.EternalStorms.Yoink" = import ../apps/yoink.nix; # small screen only?
            "at.obdev.LaunchBar" = import ../apps/launchbar.nix;
            "com.apple.desktopservices" = import ../apps/desktopservices.nix;
            "com.apple.dock" = import ../apps/dock.nix;
            "com.apple.dt.Xcode" = import ../apps/xcode.nix;
            "com.apple.finder" = import ../apps/finder.nix;
            "com.apple.FontBook" = import ../apps/fontbook.nix;
            "com.apple.HIToolbox" = import ../apps/hitoolbox.nix;
            "com.apple.inputsources" = import ../apps/inputsources.nix;
            "com.apple.mail" = import ../apps/mail.nix;
            "com.apple.Music".showStatusBar = 1;
            "com.apple.Preview" = import ../apps/preview.nix;
            "com.apple.Safari" = import ../apps/safari.nix;
            "com.apple.scriptmenu".ScriptMenuEnabled = 1;
            "com.apple.Spotlight" = import ../apps/spotlight.nix;
            # always show window proxy icons (where available)
            "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = 1;
            "com.apple.universalaccess".showWindowTitlebarIcons = 1;
            "com.atow.msgfiler" = import ../apps/msgfiler.nix;
            "com.binarynights.ForkLift" = import ../apps/forklift.nix;
            "com.flexibits.fantastical2.mac" = import ../apps/fantastical2.nix;
            "com.google.drivefs.settings" = import ../apps/google-drive.nix;
            "com.googlecode.iterm2" = import ../apps/iterm;
            "com.if.Amphetamine" = import ../apps/amphetamine.nix;
            "com.knollsoft.Rectangle" = import ../apps/rectangle.nix;
            "com.microsoft.Excel" = import ../apps/excel.nix;
            "com.microsoft.Word" = import ../apps/word.nix;
            "com.microsoft.office" = import ../apps/office.nix;
            "com.microsoft.Powerpoint" = import ../apps/powerpoint.nix;
            "com.modesittsoftware.Photo-GeoTag" = import ../apps/photo-geotag.nix;
            "com.objective-see.oversight" = import ../apps/oversight.nix;
            "com.noodlesoft.Hazel" = import ../apps/hazel.nix;
            "com.stclairsoft.DefaultFolderX5" = import ../apps/default-folder-x.nix;
            "edu.ucsd.cs.mmccrack.bibdesk" = import ../apps/bibdesk.nix;
            # where on earth are the rest of Vivaldi's settings???
            # (similar for Chrome and Firefox)
            "com.vivaldi.Vivaldi".SUAutomaticallyUpdate = 0;
            "net.sourceforge.skim-app.skim" = import ../apps/skim.nix;
            "org.clindberg.ManOpen" = import ../apps/manopen.nix;
            "org.herf.Flux" = import ../apps/f.lux.nix;
            # not a hell of a lot else exposed via defaults :/
            "org.videolan.vlc".SUEnableAutomaticChecks = 1;
            "tracesOf.Uebersicht" = import ../apps/ubersicht.nix;
            "uk.co.tla-systems.pcalc" = import ../apps/pcalc.nix;
        };
        search = "Google";
    };
}
