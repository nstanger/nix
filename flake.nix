{
    description = "System configuration";
    inputs = {
        nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
        nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
        nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

        home-manager.url = "github:nix-community/home-manager/release-23.11";
        home-manager.inputs.nixpkgs.follows = "nixpkgs-stable";

        darwin.url = "github:lnl7/nix-darwin";
        darwin.inputs.nixpkgs.follows = "nixpkgs-stable";

        nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

        homebrew-core.url = "github:homebrew/homebrew-core";
        homebrew-core.flake = false;
        homebrew-cask.url = "github:homebrew/homebrew-cask";
        homebrew-cask.flake = false;
        homebrew-bundle.url = "github:homebrew/homebrew-bundle";
        homebrew-bundle.flake = false;
        homebrew-cask-fonts.url = "github:homebrew/homebrew-cask-fonts";
        homebrew-cask-fonts.flake = false;
        homebrew-cask-versions.url = "github:homebrew/homebrew-cask-versions";
        homebrew-cask-versions.flake = false;
    };
    outputs = inputs @ {
        self,
        nixpkgs,
        nixpkgs-stable,
        nixpkgs-darwin,
        nixpkgs-unstable,
        home-manager,
        darwin,
        nix-homebrew,
        ...
    }:
        let
            darwinSystem = system: extraModules: hostName:
                let
                    pkgs = import nixpkgs-darwin {
                        inherit system;
                        config.allowUnfree = true;
                    };
                in
                    darwin.lib.darwinSystem {
                        inherit system;
                        specialArgs = { inherit pkgs inputs self darwin; };
                        modules = [
                            nix-homebrew.darwinModules.nix-homebrew {
                                nix-homebrew = {
                                    # Install Homebrew under the default prefix
                                    enable = true;

                                    # user is set in per-host configuration

                                    # Declarative tap management
                                    taps = with inputs; {
                                        "homebrew/homebrew-core" = homebrew-core;
                                        "homebrew/homebrew-cask" = homebrew-cask;
                                        "homebrew/homebrew-bundle" = homebrew-bundle;
                                        "homebrew/homebrew-cask-fonts" = homebrew-cask-fonts;
                                        "homebrew/homebrew-cask-versions" = homebrew-cask-versions;
        #                                "homebrew/homebrew-services" = homebrew-services;
        #                                "homebrew/homebrew-cask-drivers" = homebrew-cask-drivers;
                                    };

                                    # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
                                    mutableTaps = false;
                                };
                            }
                            home-manager.darwinModules.home-manager
                            {
#                                nixpkgs.overlays = overlays;
                                #system.darwinLabel = "${config.system.darwinLabel}@${rev}";
                                networking.hostName = hostName;
                                home-manager = {
                                    useGlobalPkgs = true;
                                    useUserPackages = true;
                                    extraSpecialArgs = { inherit inputs pkgs; };
                                };
#                                home-manager.users.ragon = hmConfig;
                            }
                            ./darwin
                            # host-specific configuration
                            ./hosts/${hostName}
                        ] ++ extraModules;
                    };

            processConfigurations = builtins.mapAttrs (n: v: v n);

        in {
            darwinConfigurations = processConfigurations {
                Nigels-Virtual-Machine = darwinSystem "aarch64-darwin" [ ];
                uoK79KQLK7M0 = darwinSystem "aarch64-darwin" [ ];
            };
        };
}
