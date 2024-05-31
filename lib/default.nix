# Based on <https://github.com/thexyno/nixos-config>

{ inputs, lib, paths, pkgs, ... }:

let
    inherit (lib) makeExtensible attrValues foldr;
    inherit (modules) mapModules;

    modules = import ./modules.nix {
        inherit lib;
        self.attrs = import ./attrs.nix { inherit lib; self = { }; };
    };

    files = import ./files.nix {
        inherit paths pkgs;
    #     self.attrs = import ./attrs.nix { inherit lib; self = { }; };
    };

    mylib = makeExtensible (self:
        with self; mapModules ./.
            # ALSO ADD ATTRIBUTES INHERITED BY ANY OF THE ABOVE HERE!
            (file: import file { inherit self paths pkgs lib inputs; }));
in
    mylib.extend (self: super:
        foldr (a: b: a // b) { } (attrValues super))
