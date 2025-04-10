pkgs: with pkgs; [
    # SOFTWARE
    dmg2img
    entr
    ffmpeg
    gawk
    gradle_7
    graphviz-nox
    gron
    imgcat
    imagemagick
    mkcert
    # neovide
    # Need node to shut up the VS Code Sonarlint extension.
    nodejs-slim_22
    nodePackages.tiddlywiki
    p7zip
    plantuml
    poppler_utils
    proselint
    ps2eps
    # R seems to be thoroughly broken, switch to Homebrew :(
    # R
    saxonb_9_1
    svgcleaner
    tmux
    vimv-rs
    visidata
    watch
    xq-xml
    yq-go

    /*  PYTHON
        Package names are not interpolatable, so it's not possible to
        factor out things like the Python version. However, given that
        Nix only provides Python "applications" as packages and not
        modules, this probably isn't an issue. It is a bit annoying,
        however that there is only a "python3xxPackages" (specfic
        Python version, e.g., "311"), not a "python3Packages".
    */
    python312Full
    python312Packages.virtualenvwrapper
    python312Packages.pygments

    # FONTS
    symbola # not in Homebrew
]
