# Based on <https://github.com/thexyno/nixos-config>

{ pkgs, ... }:

with builtins;
rec {
    # processHomeFiles: Add various kinds of file using the mapAttrs trick
    processHomeFiles = mapAttrs (name: fn: fn name);

    # mkConfigFile: Add a text-based config file
    mkConfigFile = sourcePath: targetPath: name: {
        text = readFile (sourcePath + "/${name}");
        target = "${targetPath}/${name}";
    };

    # mkDir: Add a required directory using the invisible file trick
    mkDir = targetPath: name: {
        text = "";
        target = "${targetPath}/${name}/.nix-keep";
    };

    # mkShellScript: Add shell scripts in specified location
    # see https://nixos.org/manual/nixpkgs/stable/#trivial-builder-writeText
    # and https://discourse.nixos.org/t/how-to-invoke-script-installed-with-writescriptbin-inside-other-config-file/8795/2
    # writeShellScript automatically inserts a shebang line
    mkShellScript = sourcePath: targetPath: name: {
        executable = true;
        source = pkgs.writeShellScript "${name}" (readFile (sourcePath + "/${name}"));
        target = "${targetPath}/${name}";
    };
}
