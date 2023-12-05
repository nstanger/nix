# Copy this template to appname.sh and configure the settings accordingly.

# Settings
# The name of the application, e.g., "Finder".
appname="Skim"

# The corresponding defaults domain, e.g., "com.apple.finder".
appdefaults="net.sourceforge.skim-app.skim"

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

    defaults write $appdefaults SKDefaultPDFDisplaySettings -dict \
        autoScales 1 \
        displayBox 1 \
        displayDirection 0 \
        displayMode 0 \
        displaysAsBook 1 \
        displaysPageBreaks 1 \
        displaysRTL 0

    # defaults can't write complex nested structures using the
    # provided command line options. The only way seems to be to
    # provide a "legacy plist string", which may break at some
    # future point?
    # Tried: one huge string (bleh); printf | xargs (less bleh); heredoc (failed).
    printf "'%s; %s; %s; %s; %s;'" \
        '"TB Display Mode" = 1' \
        '"TB Icon Size Mode" = 1' \
        '"TB Is Shown" = 1' \
        '"TB Size Mode" = 1' \
        '"TB Item Identifiers" = (SKDocumentToolbarPreviousNextItemIdentifier, SKDocumentToolbarPageNumberItemIdentifier, SKDocumentToolbarBackForwardItemIdentifier, SKDocumentToolbarZoomInActualOutItemIdentifier, SKDocumentToolbarScaleItemIdentifier, SKDocumentToolbarToolModeItemIdentifier, SKDocumentToolbarNewNoteItemIdentifier)' \
    | xargs defaults write $appdefaults "NSToolbar Configuration SKDocumentToolbar"

    if [ $quitapp -ne 0 -a $apprunning = "true" ]; then
        open -a $appname
    fi
fi
