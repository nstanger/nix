{
    lib,
    paths,
    pkgs,
    username,
    ...
}:
let
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
        file = with lib.my; with lib.path; with paths; processHomeFiles {
            # text-based config files
            ".agignore" = mkConfigFile (append home-manager-p "configs/silver-searcher") "";
            "logrotate.conf" = mkConfigFile (append home-manager-p "configs/logrotate") ".config/logrotate";

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
            /*  Some coreutils programs (e.g., cp, chmod, ...) somehow
                occasionally don't mask the macOS provided versions, so use
                coreutils --coreutils-prog=xxxx to run them. This is mainly
                to ensure --verbose is available (where supported).
            */
            coreutilsCmd = cmd: "coreutils --coreutils-prog=${cmd}";

            dBeaverPrefs = [
                "org.eclipse.core.resources.prefs"
                "org.eclipse.e4.ui.css.swt.theme.prefs"
                "org.eclipse.e4.ui.workbench.renderers.swt.prefs"
                "org.eclipse.jsch.core.prefs"
                "org.eclipse.team.core.prefs"
                "org.eclipse.ui.browser.prefs"
                "org.eclipse.ui.editors.prefs"
                "org.eclipse.ui.ide.prefs"
                "org.eclipse.ui.workbench.prefs"
                "org.jkiss.dbeaver.core.prefs"
                "org.jkiss.dbeaver.erd.ui.prefs"
                "org.jkiss.dbeaver.ui.statistics.prefs"
            ];
        in with builtins; with lib.path; with paths; {
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
                $DRY_RUN_CMD ${coreutilsCmd "cp"} $VERBOSE_ARG ${append home-manager-p "configs/keyboard/ISO10646.inputplugin"} ${target}
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

            /*  Install DBeaver prefs files. We can't just symlink these because
                DBeaver recreates some of them on quit even when nothing has
                obviously changed :(.
            */
            copyDBeaverPrefs = let
                targetDir = ''$HOME/Library/DBeaverData/workspace6/.metadata/.plugins/org.eclipse.core.runtime/.settings'';
                mode = "644";
            in lib.hm.dag.entryAfter ["writeBoundary"] (concatStringsSep "" (map (file: ''
                $DRY_RUN_CMD ${coreutilsCmd "cp"} $VERBOSE_ARG ${append apps "dbeaver/${file}"} ${targetDir}/${file}
                $DRY_RUN_CMD ${coreutilsCmd "chmod"} $VERBOSE_ARG ${mode} ${targetDir}/${file}
                $DRY_RUN_CMD sed -i -e 's/@USERNAME@/${username}/' ${targetDir}/${file}
            '') dBeaverPrefs));

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

    launchd = with lib.path; with paths; {
        enable = true;
        agents = {
            "task.sync" = import (append home-manager-p "configs/launchd/task-sync.nix") username;
        };
    };

    targets.darwin = {
        defaults = with lib.path; with paths; {
            NSGlobalDomain = import (append apps "global.nix");
            "at.EternalStorms.Yoink" = import (append apps "yoink.nix"); # small screen only?
            "at.obdev.LaunchBar" = import (append apps "launchbar.nix");
            "com.apple.desktopservices" = import (append apps "desktopservices.nix");
            "com.apple.dock" = import (append apps "dock.nix");
            "com.apple.dt.Xcode" = import (append apps "xcode.nix");
            "com.apple.finder" = import (append apps "finder.nix");
            "com.apple.FontBook" = import (append apps "fontbook.nix");
            "com.apple.HIToolbox" = import (append apps "hitoolbox.nix");
            "com.apple.inputsources" = import (append apps "inputsources.nix");
            "com.apple.mail" = import (append apps "mail.nix");
            "com.apple.Music".showStatusBar = 1;
            "com.apple.Preview" = import (append apps "preview.nix");
            "com.apple.Safari" = import (append apps "safari.nix");
            "com.apple.scriptmenu".ScriptMenuEnabled = 1;
            "com.apple.Spotlight" = import (append apps "spotlight.nix");
            # always show window proxy icons (where available)
            "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = 1;
            "com.apple.universalaccess".showWindowTitlebarIcons = 1;
            "com.araeliumgroup.screenflick" = import (append apps "screenflick.nix");
            "com.atow.msgfiler" = import (append apps "msgfiler.nix");
            "com.binarynights.ForkLift" = import (append apps "forklift.nix");
            "com.charlessoft.pacifist" = import (append apps "pacifist.nix");
            "com.flexibits.fantastical2.mac" = import (append apps "fantastical2.nix");
            "com.google.drivefs.settings" = import (append apps "google-drive.nix");
            "com.googlecode.iterm2" = import (append apps "iterm");
            "com.if.Amphetamine" = import (append apps "amphetamine.nix");
            "com.knollsoft.Rectangle" = import (append apps "rectangle.nix");
            "com.microsoft.Excel" = import (append apps "excel.nix");
            "com.microsoft.Word" = import (append apps "word.nix");
            "com.microsoft.office" = import (append apps "office.nix");
            "com.microsoft.Powerpoint" = import (append apps "powerpoint.nix");
            "com.modesittsoftware.Photo-GeoTag" = import (append apps "photo-geotag.nix");
            "com.objective-see.oversight" = import (append apps "oversight.nix");
            "com.noodlesoft.Hazel" = import (append apps "hazel.nix");
            "com.pascal.freeruler" = import (append apps "free-ruler.nix");
            "com.stclairsoft.DefaultFolderX5" = import (append apps "default-folder-x.nix");
            "com.zeroonetwenty.BlueHarvest5" = import (append apps "blueharvest.nix");
            "edu.ucsd.cs.mmccrack.bibdesk" = import (append apps "bibdesk.nix");
            # where on earth are the rest of Vivaldi's settings???
            # (similar for Chrome and Firefox)
            # Chrome: ~/Library/Application Support/Google/Chrome/Default/Preferences (JSON)
            #   (Vivaldi being Chromium based presumably uses the same file.)
            #   > Google Chrome settings and storage represent user-selected preferences and
            #   > information and MUST not be extracted, overwritten or modified except through
            #   > Google Chrome defined APIs.
            #   This may be helpful: <https://support.google.com/chrome/a/answer/187948>
            # Firefox: ~/Library/Application Support/Firefox/Profiles/iipge4v0.default-release/prefs.js
            #   The profile name may differ!
            #   > DO NOT EDIT THIS FILE.
            #   >
            #   > If you make changes to this file while the application is running,
            #   > the changes will be overwritten when the application exits.
            #   >
            #   > To change a preference value, you can either:
            #   > - modify it via the UI (e.g. via about:config in the browser); or
            #   > - set it within a user.js file in your profile.
            "com.vivaldi.Vivaldi".SUAutomaticallyUpdate = 0;
            "net.sourceforge.skim-app.skim" = import (append apps "skim.nix");
            "org.herf.Flux" = import (append apps "f.lux.nix");
            # not a hell of a lot else exposed via defaults :/
            "org.videolan.vlc".SUEnableAutomaticChecks = 1;
            "tracesOf.Uebersicht" = import (append apps "ubersicht.nix");
            "uk.co.tla-systems.pcalc" = import (append apps "pcalc.nix");
        };
        search = "Google";
    };
}
