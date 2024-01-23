# Copy this template to appname.sh and configure the settings accordingly.

# Settings
# The name of the application, e.g., "Finder".
appname="ForkLift"

# The corresponding defaults domain, e.g., "com.apple.finder".
appdefaults="com.binarynights.ForkLift"

# Is this configuration enabled?
enabled=1

# Quit the app? This may not always be possible or appropriate.
quitapp=1

if [ $enabled -ne 0 ]; then
    echo "    [$appname]"

    apprunning=$(osascript -e 'tell application "System Events" to (name of processes) contains "'$appname'"')
    if [ $quitapp -ne 0 -a $apprunning = "true" ]; then
        osascript -e 'tell application "'$appname'" to quit'
    fi

    defaults write $appdefaults TerminalApplication -int 1 # iTerm
    defaults write $appdefaults alwaysShowTabbar -int 1
    defaults write $appdefaults applicationDeleter -int 0
    defaults write $appdefaults cloudSync -int 0
    defaults write $appdefaults connectViewProtocol -string "smb"
    defaults write $appdefaults connectViewShowAdvanced -int 1
    defaults write $appdefaults hidePathBar -int 0
    defaults write $appdefaults hideTitleBar -int 0
    defaults write $appdefaults infoMode -int 0
    # Sticks but does seems to reset the appearance to non-alternating?
    # defaults write $appdefaults listViewAlternatingBackground -int 1
    defaults write $appdefaults pdfAutoScales -int 0
    defaults write $appdefaults pdfDisplayMode -int 0
    defaults write $appdefaults pdfScaleFactor -int 1
    defaults write $appdefaults previewDividerPosition -int 300
    defaults write $appdefaults recursiveSearch -int 0
    defaults write $appdefaults remoteSearchMode -int 0
    defaults write $appdefaults searchMode -int 0
    defaults write $appdefaults showDeviceInfo -int 1

    # toolbar configuration
    defaults write $appdefaults "NSToolbar Configuration com.apple.NSColorPanel" -dict \
        "TB Is Shown" -int 1

    # defaults can't write complex nested structures using the
    # provided command line options. The only way seems to be to
    # provide a "legacy plist string", which may break at some
    # future point?
    # cat with heredoc into xargs seems to be the best wrt readability,
    # but note " must be quoted, and requires xargs from GNU findutils
    cat <<EOF |
        \"TB Display Mode\" = 2;
        \"TB Icon Size Mode\" = 1;
        \"TB Is Shown\" = 1;
        \"TB Size Mode\" = 1;
        \"TB Item Identifiers\" = (
            backForward,
            NSToolbarFlexibleSpaceItem,
            groupBy,
            toggleHiddenFiles,
            NSToolbarSpaceItem,
            favorites,
            actions,
            NSToolbarSpaceItem,
            sync,
            teminal,
            compare,
            scm,
            NSToolbarSpaceItem,
            activities,
            NSToolbarSpaceItem,
            search
        );
EOF
tr -d '\n' | xargs --replace=PLIST defaults write $appdefaults "NSToolbar Configuration Toolbar" 'PLIST'
#    printf "'%s; %s; %s; %s; %s;'" \
#        '"TB Display Mode" = 2' \
#        '"TB Icon Size Mode" = 1' \
#        '"TB Is Shown" = 1' \
#        '"TB Size Mode" = 1' \
#        '"TB Item Identifiers" = (backForward, NSToolbarFlexibleSpaceItem, groupBy, toggleHiddenFiles, NSToolbarSpaceItem, favorites, actions, NSToolbarSpaceItem, sync, teminal, compare, scm, NSToolbarSpaceItem, activities, NSToolbarSpaceItem, search)' \
#    | xargs defaults write $appdefaults "NSToolbar Configuration Toolbar"

    if [ $quitapp -ne 0 -a $apprunning = "true" ]; then
        open -a $appname
    fi
fi
