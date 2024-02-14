{
    # br = branch
    # ci = commit
    # co = checkout
    discard = "checkout --";
    freeze = "update-index --assume-unchanged";
    frozen = "!git ls-files -v | grep ^[[:lower:]]";
    last = "log -1 HEAD";
    lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
    lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
    ls = ''log --pretty=format:"%C(yellow) %h %C(blue) %ad%C(red) %d %C(reset) %s%C(green) [%cn]%C(reset)" --decorate --date=short'';
    nuke = ''!sh -c "git filter-branch --force --index-filter 'git rm --cached --ignore-unmatch -r "$*"' --prune-empty --tag-name-filter cat -- --all" -'';
    recover = ''!git checkout $(git rev-list -n 1 HEAD -- "$1")^ -- "$1"'';
    # st = status
    skip = "update-index --skip-worktree";
    skipped = "!git ls-files -v | grep '^S'";
    subpull = ''!sh -c "git subtree pull --prefix $1 --squash $1 master"'';
    thaw = "update-index --no-assume-unchanged";
    # undo = "reset --soft HEAD^";
    unskip = "update-index --no-skip-worktree";
    unstage = "reset HEAD --";
}
