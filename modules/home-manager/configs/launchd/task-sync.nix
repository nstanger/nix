# need to make this a function with username as argument
# (see https://nixos.org/manual/nix/stable/language/builtins#builtins-import)
username: {
    enable = true;
    config = {
        ProgramArguments = [ "/etc/profiles/per-user/${username}/bin/task" "sync" ];
        # run every 10 minutes
        StartInterval = 600;
    };
}
