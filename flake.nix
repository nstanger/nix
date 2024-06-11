{
    description = "System configuration";
    inputs = {
        nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
        nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.05-darwin";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

        home-manager.url = "github:nix-community/home-manager/release-24.05";
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
        darwin,
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

                    # Easiest way to fix the major module paths so that we can
                    # access them from anywhere.
                    paths = with lib.path; rec {
                        # top-level paths
                        apps-path = append ./. "apps";
                        darwin-path = append ./. "darwin";
                        home-manager-path = append ./. "home-manager";
                        hosts-path = append ./. "hosts";
                        # commonly used sub-paths
                        configs-path = append home-manager-path "configs";
                        defaults-path = append home-manager-path "defaults";
                    };

                    lib = pkgs.lib.extend (self: super: {
                        my = import ./lib { inherit inputs paths pkgs username; lib = self; };
                    });
                in
                    darwin.lib.darwinSystem {
                        inherit system;
                        specialArgs = { inherit darwin inputs lib paths pkgs self username; };
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
                                    extraSpecialArgs = { inherit inputs paths pkgs username; };
                                };
#                                home-manager.users.ragon = hmConfig;
                            }
                            darwin-path
                            # host-specific configuration
                            (append hosts-path "${hostName}")
                        ] ++ extraModules;
                    };

            processConfigurations = builtins.mapAttrs (n: v: v n);

        in {
            # lib = lib.my;
            darwinConfigurations = processConfigurations {
                Nigels-Virtual-Machine = darwinSystem "aarch64-darwin" "nstanger" [ ];
                uoK79KQLK7M0 = darwinSystem "aarch64-darwin" "stani07p" [ ];
                sondonesia = darwinSystem "aarch64-darwin" "nstanger" [ ];
            };
        };
}
