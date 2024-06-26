username: {
    enable = true;
    config = {
        ProgramArguments = [ "/etc/profiles/per-user/${username}/bin/task" "sync" ];
        # run every 10 minutes
        StartInterval = 600;
    };
}
