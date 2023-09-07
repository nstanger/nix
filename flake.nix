{
    description = "System configuration";
    inputs = {
        nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager.url = "github:nix-community/home-manager/master";
        home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

        darwin.url = "github:lnl7/nix-darwin";
        darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    outputs = inputs @ {
        self,
        nixpkgs,
        nixpkgs-stable,
        nixpkgs-unstable,
        home-manager,
        darwin,
        ...
    }: let
        username = "nstanger";
    in {
        darwinConfigurations.Nigels-Virtual-Machine = darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            pkgs = import nixpkgs { system = "aarch64-darwin"; };
            specialArgs = {
                inherit inputs nixpkgs-stable nixpkgs-unstable username;
            };
            modules = [
                ./modules/darwin
                home-manager.darwinModules.home-manager {
                    home-manager = {
                        useGlobalPkgs = true;
                        useUserPackages = true;
                        users."${username}".imports = [
                            ./modules/home-manager
                        ];
                        extraSpecialArgs = {
                            inherit username;
                        };
                    };
                }
            ];
        };
    };
}
