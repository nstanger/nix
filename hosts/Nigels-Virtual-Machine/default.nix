{
    pkgs,
    inputs,
    ...
}: 
# let
#     makeUser = username: shell: authorizedKeys: {
#         users.users."${username}" = {
#             home = "/Users/${username}";
#             shell = pkgs.zsh;
#             openssh.authorizedKeys.keyFiles = authorizedKeys;
#     }
# in
let
    username = "nstanger";
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

    home-manager.users."${username}" = {
        imports = [
            ../../modules/home-manager
        ];
        home.homeDirectory = "/Users/${username}";
        programs.git = {
            userName = "${username}";
            userEmail = "nigel.stanger@otago.ac.nz";
        };
        programs.taskwarrior.config.taskd = {
            key = "/Users/${username}/.config/task/Nigel_Stanger.key.pem";
            ca = "/Users/${username}/.config/task/ca.cert.pem";
            extraConfig = builtins.concatStringsSep "\n" [ "nag=" "context=home" ];
        };
    };
}
