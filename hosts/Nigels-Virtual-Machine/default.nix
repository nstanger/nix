{ pkgs, inputs, ... }:
{
    users.users.nstanger = {
        home = "/Users/nstanger";
        shell = pkgs.zsh;
        openssh.authorizedKeys.keyFiles = [
            ./ssh/home_laptop.pub
        ];
    };
}
