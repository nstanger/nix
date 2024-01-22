# Copy this template to appname.sh and configure the settings accordingly.

# Settings
# The name of the application, e.g., "Finder".
appname="Finder"

# The corresponding defaults domain, e.g., "com.apple.finder".
appdefaults="com.apple.finder"

# Is this configuration enabled?
enabled=0

# Quit the app? This may not always be possible or appropriate.
quitapp=1

if [ $enabled -ne 0 ]; then
    echo "    [$appname]"

    apprunning=$(osascript -e 'tell application "System Events" to (name of processes) contains "'$appname'"')
    if [ $quitapp -ne 0 -a $apprunning = "true" ]; then
        osascript -e 'tell application "'$appname'" to quit'
    fi

    # set view preferences, but it doesn't seem to stick :(
    defaults write $appdefaults DesktopViewSettings -dict-add IconViewSettings \
        '{ arrangeBy = kind; backgroundColorBlue = 1; backgroundColorGreen = 1; backgroundColorRed = 1; backgroundType = 0; gridOffsetX = 0; gridOffsetY = 0; gridSpacing = 54; iconSize = 128; labelOnBottom = 1; showIconPreview = 1; showItemInfo = 1; textSize = 12; viewOptionsVersion = 1; }'

    if [ $quitapp -ne 0 -a $apprunning = "true" ]; then
        open -a $appname
    fi
fi
