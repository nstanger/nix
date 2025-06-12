{
    description = "System configuration";
    inputs = {
        nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
        nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.05-darwin";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

        home-manager.url = "github:nix-community/home-manager/release-25.05";
        home-manager.inputs.nixpkgs.follows = "nixpkgs-stable";

        nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
        nix-darwin.inputs.nixpkgs.follows = "nixpkgs-stable";

        nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
        nix-homebrew.inputs.nixpkgs.follows = "nixpkgs-stable";
        nix-homebrew.inputs.nix-darwin.follows = "nix-darwin";

        homebrew-core.url = "github:homebrew/homebrew-core";
        homebrew-core.flake = false;
        homebrew-cask.url = "github:homebrew/homebrew-cask";
        homebrew-cask.flake = false;
        homebrew-bundle.url = "github:homebrew/homebrew-bundle";
        homebrew-bundle.flake = false;
        # homebrew-cask-fonts.url = "github:homebrew/homebrew-cask-fonts";
        # homebrew-cask-fonts.flake = false;
        # homebrew-cask-versions.url = "github:homebrew/homebrew-cask-versions";
        # homebrew-cask-versions.flake = false;
    };
    outputs = inputs @ {
        self,
        nixpkgs,
        nixpkgs-stable,
        nixpkgs-darwin,
        nixpkgs-unstable,
        home-manager,
        nix-darwin,
        nix-homebrew,
        ... 
    }:
        let
            darwinSystem = system: username: extraModules: hostName:
                let
                    pkgs = import nixpkgs-darwin {
                        inherit system;
                        config.allowUnfree = true;
                    };
                    unstable = import nixpkgs-unstable {
                        inherit system;
                        config.allowUnfree = true;
                    };

                    # Easiest way to fix the major module paths so that we can
                    # access them from anywhere.
                    paths = with lib.path; rec {
                        # top-level paths
                        darwin-path = append ./. "darwin";
                        home-manager-path = append ./. "home-manager";
                        homebrew-path = append ./. "homebrew";
                        hosts-path = append ./. "hosts";
                        # commonly used sub-paths
                        configs-path = append home-manager-path "configs";
                        defaults-path = append home-manager-path "defaults";
                    };

                    lib = pkgs.lib.extend (self: super: {
                        my = import ./lib { inherit inputs paths pkgs username; lib = self; };
                    });
                in
                    nix-darwin.lib.darwinSystem {
                        inherit system;
                        specialArgs = { inherit nix-darwin inputs lib paths pkgs unstable self username; };
                        modules = with lib.path; with paths; [
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
                                    };

                                    # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
                                    mutableTaps = false;
                                };
                            }
                            home-manager.darwinModules.home-manager
                            {
#                                nixpkgs.overlays = overlays;
                                #system.darwinLabel = "${config.system.darwinLabel}@${rev}";
                                # This forces hostname -f to be just the short name, not the FQDN.
                                # Should it be localHostName or computerName instead? Or just not bother?
                                # networking.hostName = hostName;
                                home-manager = {
                                    backupFileExtension = "backup";
                                    useGlobalPkgs = true;
                                    useUserPackages = true;
                                    extraSpecialArgs = { inherit inputs paths pkgs unstable username; };
                                };
#                                home-manager.users.ragon = hmConfig;
                            }
                            darwin-path
                            homebrew-path
                            # host-specific configuration
                            (append hosts-path "${hostName}")
                        ] ++ extraModules;
                    };

            processConfigurations = builtins.mapAttrs (n: v: v n);

        in {
            # lib = lib.my;
            darwinConfigurations = processConfigurations {
                Nigels-Virtual-Machine = darwinSystem "aarch64-darwin" "nstanger" [ ];
                KGVYYWHLG6 = darwinSystem "aarch64-darwin" "stani07p" [ ];
                # uoK79KQLK7M0 = darwinSystem "aarch64-darwin" "stani07p" [ ];
                sondonesia = darwinSystem "aarch64-darwin" "nstanger" [ ];
                poldavia = darwinSystem "x86_64-darwin" "nstanger" [ ];
            };
        };
}
