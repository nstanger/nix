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
        aliases = {
            # br = branch
            # ci = commit
            # co = checkout
            discard = "checkout --";
            freeze = "update-index --assume-unchanged";
            frozen = "!git ls-files -v | grep ^[[:lower:]]";
            last = "log -1 HEAD";
            lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
            lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
            ls = "log --pretty=format:\"%C(yellow) %h %C(blue) %ad%C(red) %d %C(reset) %s%C(green) [%cn]%C(reset)\" --decorate --date=short";
            # nuke = "!sh -c \"git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch -r "$*"' --prune-empty --tag-name-filter cat -- --all\" -";
            recover = "!git checkout $(git rev-list -n 1 HEAD -- \"$1\")^ -- \"$1\"";
            # st = status
            skip = "update-index --skip-worktree";
            skipped = "!git ls-files -v | grep '^S'";
            subpull = "!sh -c \"git subtree pull --prefix $1 --squash $1 master\"";
            thaw = "update-index --no-assume-unchanged";
            # undo = "reset --soft HEAD^";
            unskip = "update-index --no-skip-worktree";
            unstage = "reset HEAD --";
        };
        extraConfig = {
        color = {
            ui = true;
            branch = "auto";
            diff = "auto";
            interactive = "auto";
            status = "auto";
        };
        core = {
            autocrlf = "input";
        };
        credential = {
            helper = "osxkeychain";
            useHttpPath = true;
        };
        init.defaultBranch = "main";
        push.default = "simple";
        pull.rebase = "false";
        };
        ignores = import ./configs/git/gitignore.nix;
    };
    programs.zsh = {
        enable = true;
        autocd = true;
        cdpath = [ "~" "~/Documents" "~/Documents/Development" "~/Documents/Teaching" ];
        enableCompletion = true;
        enableAutosuggestions = true;
        history = {
            # expire duplicates first
            expireDuplicatesFirst = true;
            # extended history information
            extended = true;
            # do not store any duplications
            ignoreAllDups = true;

        };
        syntaxHighlighting.enable = true;
        shellAliases = {
            empty = "/bin/rm -rf ~/.Trash/*";
            java_home = "/usr/libexec/java_home";
            # unlocktrash = "/usr/bin/sudo /usr/sbin/chown -R ${USER}:${GROUP} ~/.Trash/*";
            ls = "lsd --classify --color=auto --group-directories-first";
            l = "lsd --classify --color=auto -l --group-directories-first";
            lr = "lsd --classify --color=auto -l --group-directories-first --tree";
            ll = "lsd --classify --color=auto -al --group-directories-first";
            llr = "lsd --classify --color=auto -al --group-directories-first --tree";
            "l@" = "/bin/ls -lFG@";
            "ll@" = "/bin/ls -alFG@";
            # man = "/usr/local/bin/openman";
            nixswitch = "darwin-rebuild switch --flake ~/Documents/nix/.#";
            nixupdate = "pushd ~/Documents/nix; nix flake update; nixswitch; popd";
            rm = "/bin/rm -i";
            # locate = "${BREW_PREFIX}/bin/glocate -d /var/db/locate.database";
            # smbclient = "rlwrap /opt/local/bin/smbclient";
            beep = "/usr/bin/tput bel";
            # grep = "${BREW_PREFIX}/bin/ggrep --color=auto";
        };
    };
    programs.starship = {
        enable = true;
        enableZshIntegration = true;
        settings = import ./configs/starship/settings.nix;
    };
}
