{
    pkgs,
    lib,
    username,
    ...
}:
let
    quietlight = pkgs.vimUtils.buildVimPluginFrom2Nix {
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
        stateVersion = "23.05";

        homeDirectory = "/Users/${username}";
        packages = with pkgs; [
            eza
            git-extras
            less
            lesspipe
            lsd
            zsh-completions
        ];
        sessionVariables = {
            ISPMS_HOST = "sobmac0011.staff.uod.otago.ac.nz";
            LESS="--no-init --raw-control-chars";
            LESSOPEN="| lesspipe.sh %s";
            LSCOLORS="ExGxFxDaCxDxDxxbaDacec";
            PAGER = "less";
        };
        file = {
            ".config/lsd/config.yaml".source = ./configs/lsd/config.yaml;
            ".config/lsd/colors.yaml".source = ./configs/lsd/colors.yaml;
        };
    };

    programs.bat = {
        enable = true;
        # extraPackages = with pkgs.bat-extras; [ batdiff batman batgrep batwatch ];
        config = {
            theme = "Quiet Light";
            italic-text = "always";
        };
        themes = {
            "Quiet Light" = builtins.readFile (pkgs.fetchFromGitHub {
                owner = "colorsublime";
                repo = "colorsublime-themes"; # Bat uses sublime syntax for its themes
                rev = "949c70f12a8d8f5d8cfc966be45fd42cd3a6904c";
                sha256 = null;
            } + "/themes/QuietLight.tmTheme");
        };
    };

    programs.git = {
        enable = true;
        lfs.enable = true;
        package = pkgs.gitAndTools.gitFull;
        userName = "${username}";
        userEmail = "nigel.stanger@otago.ac.nz";
        aliases = import ./configs/git/aliases.nix;
        extraConfig = import ./configs/git/extraConfig.nix;
        ignores = import ./configs/git/gitignore.nix;
    };

    programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
    };

    programs.neovim = {
        enable = true;
        vimAlias = true;
        vimdiffAlias = true;
        plugins = with pkgs.vimPlugins; [ quietlight ];
        extraConfig = import ./configs/vim/vimrc.nix;
    };

    programs.taskwarrior = {
        enable = false;
        colorTheme = "light-256";
        dataLocation = "~/.config/task";
        config = {
            taskd = {
                certificate = ".config/task/Nigel_Stanger.cert.pem";
                key = "/Users/${username}/.config/task/Nigel_Stanger.key.pem";
                ca = "/Users/${username}/.config/task/ca.cert.pem";
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
        };
        extraConfig = builtins.concatStringsSep "\n" [ "nag=" "context=home" ];
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

    programs.starship = {
        enable = true;
        enableZshIntegration = true;
        settings = import ./configs/starship/settings.nix;
    };
}
