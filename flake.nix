{
    description = "System configuration";
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs";

        home-manager.url = "github:nix-community/home-manager/master";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        darwin.url = "github:lnl7/nix-darwin";
        darwin.inputs.nixpkgs.follows = "nixpkgs";
    };
    outputs = inputs @ { nixpkgs, home-manager, darwin, ... }: {
        darwinConfigurations.Nigels-Virtual-Machine = darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            pkgs = import nixpkgs { system = "aarch64-darwin"; };
            modules = [
                ./modules/darwin
                home-manager.darwinModules.home-manager {
                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        users.nstanger.imports = [
                            ./modules/home-manager
                        ];
                    };
                }
            ];
        };
    };
}
