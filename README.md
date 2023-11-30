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

1. Install Homebrew using the [https://brew.sh/](usual method).

1. Assuming system and user names are correct, `cd` into the flake repo and bootstrap the flake:

   ```sh
   # prevent griping about "Unexpected files in /etc"
   sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
   sudo mv /etc/shells /etc/shells.before-nix-darwin
   sudo mv /etc/zshenv /etc/zshenv.before-nix-darwin

   nix build ./#darwinConfigurations.[system name].system
   ./result/sw/bin/darwin-rebuild switch --flake /path/to/flake/repo
   ```

1. Profit!
