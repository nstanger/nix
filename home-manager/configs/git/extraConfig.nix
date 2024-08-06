{
    color = {
        ui = true;
        branch = "auto";
        diff = "auto";
        interactive = "auto";
        status = {
            branch = "black bold ul";
            untracked = "black dim bold italic";
            added = "green bold";
            updated = "blue bold";
            changed = "red bold";
            deleted = "brightred bold italic";
        };
    };
    core = {
        editor = "code --wait --new-window";
        autocrlf = "input";
    };
    credential = {
        helper = "osxkeychain";
        useHttpPath = false;
    };
    diff = {
        tool = "vscode";
        exif.textconv = "exiftool";
        word.textconv = "strings";
    };
    difftool = {
        prompt = false;
        vscode.cmd = ''code --wait --new-window --diff "$LOCAL" "$REMOTE"'';
    };
    filter = {
        media = {
            required = true;
            clean = "git media clean %f";
            smudge = "git media smudge %f";
        };
        lfs = {
            clean = "git-lfs clean -- %f";
            smudge = "git-lfs smudge -- %f";
            process = "git-lfs filter-process";
        };
    };
    init.defaultBranch = "main";
    merge.tool = "vscode";
    mergetool = {
        prompt = false;
        vscode.cmd = ''code --wait --new-window "$MERGED"'';
    };
    push.default = "simple";
    pull.rebase = false;
}
