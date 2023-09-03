{
  description = "System configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs: {
    darwinConfigurations.Nigels-Virtual-Machine = inputs.darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      pkgs = import inputs.nixpkgs { system = "aarch64-darwin"; };
      modules = [
        ({ pkgs, ... }: {
          programs.zsh.enable = true;
          environment.shells = [ pkgs.bash pkgs.zsh ];
          environment.loginShell = pkgs.zsh;
          nix.settings = {
            build-users-group = "nixbld";
            experimental-features = [ "nix-command" "flakes" "auto-allocate-uids" ];
            extra-nix-path = "nixpkgs=flake:nixpkgs";
            bash-prompt-prefix = "(nix:$name)\040";
          };
          users.users.nstanger.home = "/Users/nstanger";
          environment.systemPackages = [ pkgs.coreutils ];
          fonts.fontDir.enable = true;
          fonts.fonts = [ (pkgs.nerdfonts.override { fonts = [ "Hack" ]; }) ];
          services.nix-daemon.enable = true;
          system.defaults.NSGlobalDomain = {
            AppleShowAllExtensions = true;
            "com.apple.swipescrolldirection" = true;
          };
          system.defaults.finder = {
            AppleShowAllExtensions = true;
            FXEnableExtensionChangeWarning = true;
            FXPreferredViewStyle = "Nlsv";
            CreateDesktop = true;
            ShowStatusBar = true;
            ShowPathbar = true;
          };
          system.defaults.dock = {
            orientation = "right";
            showhidden = true;
            # mouse in top left corner will (5) start screensaver
            wvous-tl-corner = 5;
          };
          system.defaults.CustomUserPreferences = {
            "com.apple.finder" = {
              DSDontWriteNetworkStores = true;
            };
            "com.apple.finder" = {
              ShowExternalHardDrivesOnDesktop = true;
              ShowHardDrivesOnDesktop = true;
              ShowMountedServersOnDesktop = true;
              _FXSortFoldersFirst = true;
            };
            "com.apple.menuextra.clock" = {
              ShowAMPM = 1;
              ShowDate = 1;
              ShowDayOfWeek = 1;
              ShowSeconds = 1;
            };
          };
          system.stateVersion = 4;
        })
        inputs.home-manager.darwinModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.nstanger.imports = [
              ({pkgs, ...}: {
                home.stateVersion = "23.05";
                home.homeDirectory = "/Users/nstanger";
                home.packages = [ pkgs.less pkgs.lsd pkgs.exa pkgs.git-extras ];
                home.sessionVariables = {
                  PAGER = "less";
                  ISPMS_HOST = "sobmac0011.staff.uod.otago.ac.nz";
                };
                home.file = {
                  ".config/lsd/config.yaml".text = ''
                    color:
                      theme: light
                  '';
                  ".config/lsd/themes/light.yaml".text = ''
                    user: 0
                    group: 0
                    permission:
                      read: 0
                      write: 0
                      exec: 0
                    date:
                      hour-old: 28
                      day-old: 27
                      older: 0
                    size:
                      small: 0
                      medium: 172
                      large: 160
                    inode:
                      valid: 0
                    links:
                      valid: 0
                    tree-edge: 0
                  '';
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
                  ignores = [
                    ####################
                    # (LA)TEX
                    ####################
                    "*.aex"
                    "*.aux"
                    "*.bbl"
                    "*.blg"
                    "*.dvi"
                    "*.glo"
                    "*.gls"
                    "*.idx"
                    "*.ilg"
                    "*.ind"
                    "*.ist"
                    "*.lof"
                    "*.log"
                    "*.lot"
                    "*.nav"
                    "*.out"
                    "*.snm"
                    "*.tmp"
                    "*.toc"
                    "*.vrb"
                    "*.fdb_latexmk"
                    "*.fls"
                    "*.run.xml"
                    "*.xdv"
                    "*.listing"
                    "*.synctex"
                    "*.synctex(busy)"
                    "*.pyg"

                    ####################
                    # MAC CRUD
                    ####################
                    ".AppleDouble"
                    ".DS_Store"
                    ".FBCIndex"
                    ".FBCLockFolder"
                    ".FBCSemaphoreFile"
                    ".LSOverride"
                    "Icon"

                    # Thumbnails
                    "._*"

                    # Files that might appear on external disk
                    ".Spotlight-V100"
                    ".Trashes"

                    ####################
                    # WINDOWS CRUD
                    ####################
                    # Image file caches
                    "Thumbs.db"
                    "ehthumbs.db"

                    # Folder config file
                    "Desktop.ini"

                    # Recycle Bin used on file shares
                    "$RECYCLE.BIN/"

                    ####################
                    # CVS
                    ####################
                    "/CVS/*"
                    "*/CVS/*"
                    ".cvsignore"
                    "*/.cvsignore"

                    ####################
                    # COMPILED SOURCE
                    ####################
                    "*.a"
                    "*.com"
                    "*.class"
                    "*.dll"
                    "*.dylib"
                    "*.exe"
                    "*.o"
                    "*.so"

                    ####################
                    # PACKAGES
                    ####################
                    "*.7z"
                    "*.dmg"
                    "*.gz"
                    "*.iso"
                    "*.jar"
                    "*.rar"
                    "*.tar"
                    "*.tgz"
                    "*.zip"
                    "*.bzip2"

                    ####################
                    # R
                    ####################
                    ".Rproj.user"
                    ".Rhistory"
                    ".RData"

                    ####################
                    # ORACLE DATA MODELER
                    ####################
                    "Objects.local"
                    "ChangeRequests.local"
                    "DDLSelection.local"
                    "Diagrams.local"
                    "dmd_open.local"

                    ####################
                    # MISCELLANEOUS
                    ####################
                    "*.cache"
                    "*.swp"

                    ####################
                    # PYTHON
                    ####################
                    # Byte-compiled / optimized / DLL files
                    "__pycache__/"
                    "*.py[cod]"
                    "*$py.class"

                    # C extensions
                    "*.so"

                    # Distribution / packaging
                    ".Python"
                    "env/"
                    "build/"
                    "develop-eggs/"
                    "dist/"
                    "downloads/"
                    "eggs/"
                    ".eggs/"
                    "lib/"
                    "lib64/"
                    "parts/"
                    "sdist/"
                    "var/"
                    "*.egg-info/"
                    ".installed.cfg"
                    "*.egg"

                    # PyInstaller
                    #  Usually these files are written by a python script from a template
                    #  before PyInstaller builds the exe, so as to inject date/other infos into it.
                    "*.manifest"
                    "*.spec"

                    # Installer logs
                    "pip-log.txt"
                    "pip-delete-this-directory.txt"

                    # Unit test / coverage reports
                    "htmlcov/"
                    ".tox/"
                    ".coverage"
                    ".coverage.*"
                    ".cache"
                    "nosetests.xml"
                    "coverage.xml"
                    "*,cover"
                    ".hypothesis/"

                    # Translations
                    "*.mo"
                    "*.pot"

                    # Django stuff:
                    "*.log"
                    "local_settings.py"

                    # Flask stuff:
                    "instance/"
                    ".webassets-cache"

                    # Scrapy stuff:
                    ".scrapy"

                    # Sphinx documentation
                    "docs/_build/"

                    # PyBuilder
                    "target/"

                    # IPython Notebook
                    ".ipynb_checkpoints"

                    # pyenv
                    ".python-version"

                    # celery beat schedule file
                    "celerybeat-schedule"

                    # dotenv
                    ".env"

                    # virtualenv
                    ".venv/"
                    "venv/"
                    "ENV/"

                    # Spyder project settings
                    ".spyderproject"

                    # Rope project settings
                    ".ropeproject"

                    ####################
                    # ECLIPSE
                    ####################
                    ".metadata"
                    "bin/"
                    "tmp/"
                    "*.tmp"
                    "*.bak"
                    "*.swp"
                    "*~.nib"
                    "local.properties"
                    ".settings/"
                    ".loadpath"
                    ".recommenders"

                    # External tool builders
                    ".externalToolBuilders/"

                    # Locally stored "Eclipse launch configurations"
                    "*.launch"

                    # PyDev specific (Python IDE for Eclipse)
                    "*.pydevproject"

                    # CDT-specific (C/C++ Development Tooling)
                    ".cproject"

                    # CDT- autotools
                    ".autotools"

                    # Java annotation processor (APT)
                    ".factorypath"

                    # PDT-specific (PHP Development Tools)
                    ".buildpath"

                    # sbteclipse plugin
                    ".target"

                    # Tern plugin
                    ".tern-project"

                    # TeXlipse plugin
                    ".texlipse"

                    # STS (Spring Tool Suite)
                    ".springBeans"

                    # Code Recommenders
                    ".recommenders/"

                    # Annotation Processing
                    ".apt_generated/"

                    # Scala IDE specific (Scala & Java development for Eclipse)
                    ".cache-main"
                    ".scala_dependencies"
                    ".worksheet"

                    ### Eclipse Patch ###
                    # Eclipse Core
                    ".project"

                    # JDT-specific (Eclipse Java Development Tools)
                    ".classpath"

                    # Annotation Processing
                    ".apt_generated"

                    ".sts4-cache/"

                    ####################
                    # GRADLE
                    ####################
                    ".gradle"
                    "build/"
                    "gradle"

                    # Ignore Gradle GUI config
                    "gradle-app.setting"

                    # Avoid ignoring Gradle wrapper jar file (.jar files are usually ignored)
                    "!gradle-wrapper.jar"

                    # Cache of project
                    ".gradletasknamecache"

                    # # Work around https://youtrack.jetbrains.com/issue/IDEA-116898
                    # gradle/wrapper/gradle-wrapper.properties

                    ### Gradle Patch ###
                    "**/build/"

                    ####################
                    # XCODE
                    ####################

                    ## User settings
                    "xcuserdata/"

                    ## compatibility with Xcode 8 and earlier (ignoring not required starting Xcode 9)
                    "*.xcscmblueprint"
                    "*.xccheckout"

                    ## compatibility with Xcode 3 and earlier (ignoring not required starting Xcode 4)
                    "build/"
                    "DerivedData/"
                    "*.moved-aside"
                    "*.pbxuser"
                    "!default.pbxuser"
                    "*.mode1v3"
                    "!default.mode1v3"
                    "*.mode2v3"
                    "!default.mode2v3"
                    "*.perspectivev3"
                    "!default.perspectivev3"

                    ## Xcode Patch
                    "*.xcodeproj/*"
                    "!*.xcodeproj/project.pbxproj"
                    "!*.xcodeproj/xcshareddata/"
                    "!*.xcworkspace/contents.xcworkspacedata"
                    "/*.gcno"

                    ### Xcode Patch ###
                    "**/xcshareddata/WorkspaceSettings.xcsettings"

                    ####################
                    # NETBEANS
                    ####################

                    "**/nbproject/private/"
                    "**/nbproject/Makefile-*.mk"
                    "**/nbproject/Package-*.bash"
                    "build/"
                    "nbbuild/"
                    "dist/"
                    "nbdist/"
                    ".nb-gradle/"

                    ####################
                    # INTELLIJ
                    ####################
                    ".idea"
                  ];
                };
                programs.zsh = {
                  enable = true;
                  enableCompletion = true;
                  enableAutosuggestions = true;
                  syntaxHighlighting.enable = true;
                  shellAliases = {
                    empty = "/bin/rm -rf ~/.Trash/*";
                    # unlocktrash = "/usr/bin/sudo /usr/sbin/chown -R ${USER}:${GROUP} ~/.Trash/*";
                    ls = "lsd --classify --color=auto --group-directories-first";
                    l = "lsd --classify --color=auto -l --group-directories-first";
                    lr = "lsd --classify --color=auto -l --group-directories-first --tree";
                    ll = "lsd --classify --color=auto -al --group-directories-first";
                    llr = "lsd --classify --color=auto -al --group-directories-first --tree";
                    "l@" = "/bin/ls -lFG@";
                    "ll@" = "/bin/ls -alFG@";
                    # man = "/usr/local/bin/openman";
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
                };
              })
            ];
          };
        }
      ];
    };
  };
}
