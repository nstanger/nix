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

        nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

        homebrew-core.url = "github:homebrew/homebrew-core";
        homebrew-core.flake = false;
        homebrew-cask.url = "github:homebrew/homebrew-cask";
        homebrew-cask.flake = false;
        homebrew-cask-fonts.url = "github:homebrew/homebrew-cask-fonts";
        homebrew-cask-fonts.flake = false;
        homebrew-cask-versions.url = "github:homebrew/homebrew-cask-versions";
        homebrew-cask-versions.flake = false;
    };
    outputs = inputs @ {
        self,
        nixpkgs,
        nixpkgs-stable,
        nixpkgs-unstable,
        home-manager,
        darwin,
        nix-homebrew,
        ...
    }: {
        darwinConfigurations = let
            username = "nstanger";
        in {
            Nigels-Virtual-Machine = darwin.lib.darwinSystem {
                system = "aarch64-darwin";
                pkgs = import nixpkgs { system = "aarch64-darwin"; };
                specialArgs = {
                    inherit inputs nixpkgs-stable nixpkgs-unstable username;
                };
                modules = [
                    nix-homebrew.darwinModules.nix-homebrew {
                        nix-homebrew = {
                            # Install Homebrew under the default prefix
                            enable = true;

                            # apple silicon only: also install homebrew under the default intel prefix for rosetta 2
                            enablerosetta = false;

                            # user owning the homebrew prefix
                            user = "${username}";

                            # Declarative tap management
                            taps = with inputs; {
                                "homebrew/homebrew-core" = homebrew-core;
                                "homebrew/homebrew-cask" = homebrew-cask;
                                "homebrew/homebrew-cask-fonts" = homebrew-cask-fonts;
                                "homebrew/homebrew-cask-versions" = homebrew-cask-versions;
#                                "homebrew/homebrew-bundle" = homebrew-bundle;
#                                "homebrew/homebrew-services" = homebrew-services;
#                                "homebrew/homebrew-cask-drivers" = homebrew-cask-drivers;
                            };

                            # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
                            mutableTaps = false;

                            # automatically migrate existing homebrew installations
                            automigrate = false;
                        };

                    }
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
            uoK79KQLK7M0 = let
                username = "stani07p";
            in darwin.lib.darwinSystem {
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
    };
}
