{ pkgs, lib, ... }: {
    home = {
        stateVersion = "23.05";

        homeDirectory = "/Users/nstanger";
        packages = with pkgs; [
            bat
            exa
            git-extras
            less
            lesspipe
            lsd
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
