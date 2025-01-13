# nix flake configuration

## nix-darwin bootstrap on a new machine

1. Install `nix` using the Determinate Systems installer:

   ```sh
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

   > **Don’t** install with the `--determinate` switch! In true Nix fashion, there is a confusing distinction between the **Determinate Nix Installer** and **Determinate Nix**. The former can install either “plain” Nix or Determinate Nix (using the `--determinate` switch). The latter is a downstream distribution of Nix that includes `nixd`. Apparently Determinate Nix shouldn’t be installed via installer if you are using `nix-darwin `(see <https://github.com/DeterminateSystems/determinate>), although it seems to be working OK on Poldavia after I inadvertently installed it.
   >
   > On `nix-darwin` systems you should install Nix normally (without `--determinate`) as in the command above. This flake then installs Determinate Nix via the Determinate flake (<https://github.com/DeterminateSystems/determinate?tab=readme-ov-file#installing-using-our-nix-flake>).
   >
   > There’s a subtlety around `follows` for `nixpkgs` that I don’t quite understand: “We recommend not using a follows directive for Nixpkgs (`inputs.nixpkgs.follows = "nixpkgs"`) in conjunction with the Determinate flake, as it leads to cache misses for artifacts otherwise available from FlakeHub Cache.” However it looks like I don’t do that anyway (I think?) so it should be fine.

2. Start a `git` shell:

   ```sh
   nix shell nixpkgs#git

   # or: nix-shell -p git
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
   # e.g., nix build --extra-experimental-features "nix-command flakes" ./#darwinConfigurations.poldavia.system
   ./result/sw/bin/darwin-rebuild switch --flake /path/to/flake/repo
   # e.g., ./result/sw/bin/darwin-rebuild switch --flake ~/Documents/Development/nix/.#
   ```

   If there is a “Problem with the SSL CA cert”, during the initial `nix build`, check the solutions in this issue: <https://github.com/nixos/nix/issues/2899>. this usually happens if starting again after wiping a previous `nix` installation, which can leave dangling links as per <https://github.com/nixos/nix/issues/2899#issuecomment-1669501326>. You need to `sudo rm /etc/ssl/certs/ca-certificates.crt` again before `darwin-rebuild switch` as otherwise it complains about the file being in the way.

5. Profit!

## nix-darwin bootstrap on an existing machine

As above, but before cloning and bootstrapping the flake, uninstall Homebrew (as per <https://github.com/homebrew/install#uninstall-homebrew>):

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
sudo rm -rf /usr/local/Homebrew
sudo rm -rf /usr/local/Frameworks
```

or if you’re feeling lucky, just remove all the packages, but this may not always work cleanly:

```sh
brew remove --force $(brew list --cask) --ignore-dependencies
brew remove --force $(brew list --formula) --ignore-dependencies
```

Theoretically you should be able to migrate an existing Homebrew installation by setting `nix-homebrew.autoMigrate = true`, but I’m wary of it working cleanly:

```text
Warning: /usr/local seems to contain an existing copy of Homebrew.
==> Looks like an Intel installation (Homebrew repository is under the 'Homebrew' subdirectory)
==> There are two ways to proceed:
==> 1. Use the official uninstallation script to remove Homebrew (you will lose all taps and installed packages)
==> 2. Set nix-homebrew.autoMigrate = true; to allow nix-homebrew to migrate the installation
==> During auto-migration, nix-homebrew will delete the existing installation while keeping installed packages.
```

Reinstalling from scratch should be much cleaner.

Other issues:

* `mv ~/.zshrc ~/.zshrc.old` and `mv ~/.zshenv ~/.zshenv.old` probably makes sense to ensure things are clean. (If there is an existing `~/.zshrc.d` then this can probably also be removed, or at least emptied.) **Check for machine-specific initialisations that may need to be migrated.**
* Existing apps in `/Applications` may need to be manually removed to avoid clashes.
* If you get an error like `SHA.c: loadable library and perl binaries are mismatched (got handshake key 0xf880080, needed 0xc400080)` then `rm -rf ~/Library/perl5` and try again. (Nix is getting confused over Perl versions.)
* Homebrew cask installs through Nix can be extremely slow (looking at you, Calibre 😠) as they are usually downloaded from the original website, with highly variable bandwidth. This is particularly bad on the first `switch` 🙁 as Nix doesn’t print download progress (perhaps `-verbose`?). Doing an initial `brew fetch` of all the casks might help somewhat (i.e., `brew fetch --force --casks [list]`)—it’s no faster but at least displays download progress by default. Formulae seems to be just as slow, but there aren’t many these and they’re only installed as dependencies of other things. It’s probably sensible to keep a copy of the downloaded cache.

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
first try a few times to see whether it eventually resolves itself. The number of packages built usually goes down each time. If that doesn’t work, try setting `auto-optimise-store = false` in `/etc/nix/nix.conf` followed by `nix store optimise`, then re-enable `auto-optimise-store`. (This may no longer be an issue with Determinate Nix?)

## If a macOS update borks Nix

See <https://gist.github.com/meeech/0b97a86f235d10bc4e2a1116eec38e7e>.

Some possible causes of borkage include:

* Overwriting `/etc/zshrc`.
* Deleting `/Library/LaunchDaemons/org.nixos.darwin-store.plist`.
* Messing with `/etc/synthetic.conf`.

