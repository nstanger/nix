pkgs: {
    makelatex = "latexmk -shell-escape -synctex=1 -interaction=nonstopmode -file-line-error -pdflua";
    saxon-b = "${pkgs.saxonb}/bin/saxonb";
}
