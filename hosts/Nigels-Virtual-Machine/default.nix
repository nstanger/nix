{
    inputs,
    lib,
    paths,
    pkgs,
    username,
    ...
}:
let
    inherit (lib.path) append;
    inherit (paths) home-manager-path;
in {
    users.users."${username}" = {
        home = "/Users/${username}";
        shell = pkgs.zsh;
        openssh.authorizedKeys.keyFiles = [
            # ./ssh/home_laptop.pub
        ];
    };
   
    environment.systemPath = [
        "/opt/homebrew/bin"
        "/opt/homebrew/sbin"
    ];

    # disable natural scrolling direction (for now)
    system.defaults.NSGlobalDomain."com.apple.swipescrolldirection" = false;

    nix-homebrew = {
        # user owning the homebrew prefix
        user = username;
        # apple silicon only: also install homebrew under the default intel prefix for rosetta 2
        enableRosetta = false;
        # automatically migrate existing homebrew installations - once only?
        autoMigrate = false;
    };

    homebrew = {
        # Don't import the common packages to avoid filling up the VM!
        # Add individual packages for testing as necessary.
        brews = [];
        casks = [];
    };

    home-manager.users."${username}" = {
        imports = [
            home-manager-path
        ];
        home = {
            homeDirectory = "/Users/${username}";
            packages = with pkgs; [
                # SOFTWARE
                proselint # to stop VS Code plugin complaining
                tvnamer #TESTING

                # FONTS
            ];
        };
        programs.zsh.shellAliases = {
        };
        targets.darwin = {
            defaults = {
                NSGlobalDomain = {
                    "com.apple.sound.beep.sound" = "/System/Library/Sounds/Funk.aiff";
                };
            };
        };
    };
}
