# nix flake configuration

## nix-darwin bootstrap on a new machine

1. Install `nix` using the Determinate Systems installer:

   ```sh
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate
   ```

2. Start a `git` shell:

   ```sh
   nix-shell -p git
   ```

3. Clone the flake:

   ```sh
   git clone https://github.com/nstanger/nix.git
   ```

4. Assuming system and user names are correct, `cd` into the flake repo and bootstrap the flake:

   ```sh
   # prevent griping about "Unexpected files in /etc"
   sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
   sudo mv /etc/shells /etc/shells.before-nix-darwin
   sudo mv /etc/zshenv /etc/zshenv.before-nix-darwin

   nix build --extra-experimental-features "nix-command flakes" ./#darwinConfigurations.[system name].system
   ./result/sw/bin/darwin-rebuild switch --flake /path/to/flake/repo
   ```

   If there is a “Problem with the SSL CA cert”, during the initial `nix build`, check the solutions in this issue: <https://github.com/nixos/nix/issues/2899>. this usually happens if starting again after wiping a previous `nix` installation, which can leave dangling links as per <https://github.com/nixos/nix/issues/2899#issuecomment-1669501326>. You need to `sudo rm /etc/ssl/certs/ca-certificates.crt` again before `darwin-rebuild switch` as otherwise it complains about the file being in the way.

5. Profit!

## nix-darwin bootstrap on an existing machine

As above, but before cloning and bootstrapping the flake, remove all installed Homebrew packages:

```sh
brew remove --force $(brew list --cask) --ignore-dependencies
brew remove --force $(brew list --formula) --ignore-dependencies
```

Theoretically you should be able to migrate the existing installation by setting `nix-homebrew.autoMigrate = true`, but it may or may not work.

Existing apps in `/Applications` may need to be manually removed to avoid clashes.

## Update flake to latest stable

**Never change the value of `home-manager.stateVersion`!**

In theory, just change the version number in all `nixpkgs` references in `flake.nix` (e.g., `23.11` → `24.05`), then

```sh
nix flake update
nixswitch
```

If you get errors like:

```sh
error: cannot link '/nix/store/.tmp-link-59633-1986182875' to '/nix/store/.links/068x3y3a6lhjiixbmxx1wrg3lbxhq37blnlxp03038qvhdg0kcvc': File exists
error: some substitutes for the outputs of derivation '/nix/store/...' failed (usually happens due to networking issues); try '--fallback' to build derivation from source
```
first try a few times to see whether it eventually resolves itself. The number of packages built usually goes down each time. If that doesn’t work, try setting `auto-optimise-store = false` in `/etc/nix/nix.conf` followed by `nix store optimise`, then re-enable `auto-optimise-store`.
