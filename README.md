# nix-darwin bootstrap on a new machine

1. Install `nix` using the Determinate Systems installer:

   ```sh
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

1. Start a `git` shell:

   ```sh
   nix-shell -p git
   ```

1. Clone the flake:

   ```sh
   git clone https://github.com/nstanger/nix.git
   ```

1. Assuming system and user names are correct, `cd` into the flake repo and bootstrap the flake:

   ```sh
   # prevent griping about "Unexpected files in /etc"
   sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
   sudo mv /etc/shells /etc/shells.before-nix-darwin
   sudo mv /etc/zshenv /etc/zshenv.before-nix-darwin

   nix build --extra-experimental features "nix-command flakes" ./#darwinConfigurations.[system name].system
   ./result/sw/bin/darwin-rebuild switch --flake /path/to/flake/repo
   ```

   If there is a “Problem with the SSL CA cert”, during the initial `nix build`, check the solutions in this issue: <https://github.com/nixos/nix/issues/2899>. this usually happens if starting again after wiping a previous `nix` installation, which can leave dangling links as per <https://github.com/nixos/nix/issues/2899#issuecomment-1669501326>. You need to `sudo rm /etc/ssl/certs/ca-certificates.crt` again before `darwin-rebuild switch` as otherwise it complains about the file being in the way.

1. Profit!


# nix-darwin bootstrap on an existing machine

As above, but before cloning and bootstrapping the flake, remove all installed Homebrew packages:

   ```sh
   brew remove --force $(brew list --formula) --ignore-dependencies
   ```
