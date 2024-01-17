builtins.concatStringsSep ":" [
    # permissions: read
    "ur=0"          # black
    "gr=33"         # yellow
    "tr=31"         # red
    # permissions: write
    "uw=0"
    "gw=33"
    "tw=31"
    # permissions: execute
    "ux=0"
    "ue=0"
    "gx=33"
    "tx=31"
    # permissions: setuid, setgid, sticky
    "su=31;1"       # bold red
    "sf=31;1"
    # file size: value
    "nb=0"
    "nk=0"
    "nm=38;5;172"   # orange
    "ng=38;5;160"   # pink
    "nt=31"         # red
    # file size: units
    "ub=0"
    "uk=0"
    "um=38;5;172"
    "ug=38;5;160"
    "ut=31"
    # user and group membership
    "uu=32"         # green
    "gu=32"
    # header row
    "hd=0;1;0;4"    # bold underline
    # "punctuation"
    "xx=0"
    # file modification date
    "da=0"
]
