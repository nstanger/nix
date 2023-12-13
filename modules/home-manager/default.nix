{
    pkgs,
    lib,
    ...
}:
let
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

        file = {
            ".agignore".source = ./configs/silver-searcher/agignore.nix;
            # this doesn't seem to register :(
            "ISO 10646.inputplugin" = {
                source = ./configs/keyboard/ISO10646.inputplugin;
                target = "Library/Input Methods/ISO10646.inputplugin";
            };
        };

        packages = with pkgs; [
            bfg-repo-cleaner
            blackbox
            entr
            eza
            ffmpeg
            git-extras
            gnugrep
            gnumake
            gnutar
            gron
            gzip
            imagemagick
            mkcert
            # neovide
            openssl
            p7zip
            plantuml
            proselint
            ps2eps
            R
            rlwrap
            rsync
            silver-searcher
            svgcleaner
            thefuck
            tvnamer
            vimv-rs
            watch
            wget
            xq
            zsh-completions
            zsh-you-should-use
        ];

        sessionVariables = {
            EXA_COLORS = import ./configs/eza/colours.nix;
            ISPMS_HOST = "sobmac0011.staff.uod.otago.ac.nz";
            LESS="--no-init --raw-control-chars";
            LSCOLORS="ExGxFxDaCxDxDxxbaDacec";
            PAGER = "less";
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

    programs.git = {
        enable = true;
        lfs.enable = true;
        package = pkgs.gitAndTools.gitFull;
        aliases = import ./configs/git/aliases.nix;
        extraConfig = import ./configs/git/extraConfig.nix;
        ignores = import ./configs/git/gitignore.nix;
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
    programs.lesspipe.enable = true;

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
                credentials = "stanger.org.nz/Nigel Stanger/c877003c-d516-4efb-ab5f-e004449c4232";
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

        initExtraBeforeCompInit = import ./configs/zsh/initExtraBeforeCompInit.nix;
        completionInit = import ./configs/zsh/completionInit.nix;
        initExtra = import ./configs/zsh/initExtra.nix;

        syntaxHighlighting.enable = true;

        shellAliases = import ./configs/zsh/aliases.nix;
    };
}
