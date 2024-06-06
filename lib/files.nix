# Based on <https://github.com/thexyno/nixos-config>

{ paths, pkgs, ... }:

with builtins;
with paths;
rec {
    /*  processHomeFiles: Add various kinds of home file using the mapAttrs trick.
        It would be nicer to use argument sets, but unfortunately you can't
        do partial application with them :(.
        <https://nixos.org/guides/nix-pills/05-functions-and-imports.html#default-and-variadic-attributes>
    */
    processHomeFiles = mapAttrs (name: fn: fn name);

    # mkConfigFile: Add a text-based config file
    mkConfigFile = sourcePath: targetPath: name: {
        text = readFile (sourcePath + "/${name}");
        /*  This adds an unnecessary "/" at the front if targetPath is empty,
            but the target path is always "relative to HOME", so it's not
            worth the effort to do anything about it.
            <https://nix-community.github.io/home-manager/options.xhtml#opt-home.file._name_.target>
        */
        target = "${targetPath}/${name}";
    };

    # mkDir: Add a required directory using the invisible file trick.
    mkDir = targetPath: name: {
        text = "";
        # See comment in mkConfigFile.
        target = "${targetPath}/${name}/.nix-keep";
    };

    /*  mkShellScript: Add shell scripts in specified location.
        see https://nixos.org/manual/nixpkgs/stable/#trivial-builder-writeText
        and https://discourse.nixos.org/t/how-to-invoke-script-installed-with-writescriptbin-inside-other-config-file/8795/2
        writeShellScript automatically inserts a shebang line.
    */
    mkShellScript = targetPath: name: {
        executable = true;
        source = pkgs.writeShellScript "${name}" (readFile (home-manager + "/binfiles/${name}"));
        target = "${targetPath}/${name}";
    };

    # mkITermDynamicProfile: Add iTerm dynamic profiles (JSON).
    mkITermDynamicProfile = username: name: {
        ${if stringLength username > 0 then "text" else null} = replaceStrings ["@USERNAME@"] [username] (readFile (apps + "/iterm/dynamic-profiles/${name}"));
        # source gets set automatically if text is set
        # <https://nix-community.github.io/home-manager/options.xhtml#opt-home.file._name_.source>
        ${if stringLength username == 0 then "source" else null} = apps + "/iterm/dynamic-profiles/${name}";
        target = "Library/Application Support/iTerm2/DynamicProfiles/${name}";
    };
}
