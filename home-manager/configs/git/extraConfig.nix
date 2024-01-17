{
    color = {
        ui = true;
        branch = "auto";
        diff = "auto";
        interactive = "auto";
        status = "auto";
    };
    core = {
        autocrlf = "input";
    };
    credential = {
        helper = "osxkeychain";
        useHttpPath = true;
    };
    init.defaultBranch = "main";
    push.default = "simple";
    pull.rebase = "false";
}
