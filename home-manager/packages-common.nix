pkgs: with pkgs; [
    # SOFTWARE
    dmg2img
    entr
    ffmpeg
    gawk
    # gnumeric # marked as broken on Darwin + aarch64
    gradle_7
    graphviz-nox
    gron
    imgcat
    imagemagick
    mkcert
    # neovide
    nodePackages.tiddlywiki
    p7zip
    plantuml
    proselint
    ps2eps
    R
    saxonb_9_1
    svgcleaner
    vimv-rs
    visidata
    watch
    xq-xml
    yq-go

    # PYTHON
    # Package names are not interpolatable, so it's not possible to
    # factor out things like the Python version. However, given that
    # Nix only provides Python "applications" as packages and not
    # modules, this probably isn't an issue. It is a bit annoying,
    # however that there is only a "python3xxPackages" (specfic
    # Python version, e.g., "311"), not a "python3Packages".
    python311Full
    python311Packages.virtualenvwrapper
    python311Packages.pygments

    # FONTS
    symbola # not in Homebrew
]
