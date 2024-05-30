# Based on <https://github.com/thexyno/nixos-config>

{ inputs, pkgs, lib, ... }:

let
    inherit (lib) makeExtensible attrValues foldr;
    inherit (modules) mapModules;

    modules = import ./modules.nix {
        inherit lib;
        self.attrs = import ./attrs.nix { inherit lib; self = { }; };
    };

    files = import ./files.nix {
        inherit pkgs;
    #     self.attrs = import ./attrs.nix { inherit lib; self = { }; };
    };

    mylib = makeExtensible (self:
        with self; mapModules ./.
            (file: import file { inherit self pkgs lib inputs; }));
in
    mylib.extend (self: super:
        foldr (a: b: a // b) { } (attrValues super))
