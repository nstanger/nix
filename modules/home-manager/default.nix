{ pkgs, lib, ... }: {
    home = {
        stateVersion = "23.05";

        homeDirectory = "/Users/nstanger";
        packages = with pkgs; [
            exa
            git-extras
            less
            lesspipe
            lsd
            zsh-completions
        ];
        sessionVariables = {
            PAGER = "less";
            ISPMS_HOST = "sobmac0011.staff.uod.otago.ac.nz";
            LESS="--no-init --raw-control-chars";
            LESSOPEN="| lesspipe.sh %s";
            LSCOLORS="ExGxFxDaCxDxDxxbaDacec";
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
        userName = "nstanger";
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
        extraLuaConfig = ''
            set runtimepath^=~/.vim runtimepath+=~/.vim/after
            let &packpath = &runtimepath
            source ~/.vimrc
        '';
        extraConfig = ''
            " Disable compatibility with vi which can cause unexpected issues.
            set nocompatible

            " Enable type file detection. Vim will be able to try to detect the type of file in use.
            filetype on

            " Enable plugins and load plugin for the detected file type.
            filetype plugin on

            " Load an indent file for the detected file type.
            filetype indent on

            " Turn syntax highlighting on.
            syntax on

            " Add numbers to each line on the left-hand side.
            set number

            " Show line numbers relative to current line.
            set relativenumber"

            " Highlight cursor line underneath the cursor horizontally.
            set cursorline

            " Use spaces instead of tabs
            set expandtab

            " Be smart when using tabs ;)
            set smarttab

            " 1 tab == 4 spaces
            set shiftwidth=4
            set tabstop=4

            " Do not save backup files.
            set nobackup

            " Ignore case when searching
            set ignorecase

            " When searching try to be smart about cases
            set smartcase

            " Show matching words during a search.
            set showmatch

            " Highlight search results
            set hlsearch

            " Makes search act like search in modern browsers
            set incsearch

            " Always show current position
            set ruler

            " Height of the command bar
            set cmdheight=1

            " Show partial command you type in the last line of the screen.
            set showcmd

            " Show the mode you are on the last line.
            set showmode

            " Set colour scheme.
            "colorscheme mac_classic_alt
            "colorscheme quietlight
            "set t_Co=256
            "set background=light

            set mouse=a
            set nomodeline

            if exists("g:neovide")
                " macOS key bindings
                let g:neovide_input_use_logo=v:true
                map <D-v> "+p<CR>
                map! <D-v> <C-R>+
                tmap <D-v> <C-R>+
                vmap <D-c> "+y<CR>
            endif
        '';
    };

    programs.taskwarrior = {
        enable = false;
        colorTheme = "light-256";
        dataLocation = "~/.config/task";
        config = {
            taskd = {
                certificate = ".config/task/Nigel_Stanger.cert.pem";
                key = "/Users/nstanger/.config/task/Nigel_Stanger.key.pem";
                ca = "/Users/nstanger/.config/task/ca.cert.pem";
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
