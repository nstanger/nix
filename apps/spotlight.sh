# Copy this template to appname.sh and configure the settings accordingly.

# Settings
# The name of the application, e.g., "Finder".
appname="Spotlight"

# The corresponding defaults domain, e.g., "com.apple.finder".
appdefaults="com.apple.spotlight"

# Is this configuration enabled?
enabled=0

# Quit the app? This may not always be possible or appropriate.
quitapp=0

if [ $enabled -ne 0 ]; then
    echo "    [$appname]"

    apprunning=$(osascript -e 'tell application "System Events" to (name of processes) contains "'$appname'"')
    if [ $quitapp -ne 0 -a $apprunning = "true" ]; then
        osascript -e 'tell application "'$appname'" to quit'
    fi

    # this doesn't seem to stick either :(:(
    defaults write $appdefaults orderedItems -array \
        '{ enabled = 1; name = APPLICATIONS; }' \
        '{ enabled = 0; name = "MENU_SPOTLIGHT_SUGGESTIONS"; }' \
        '{ enabled = 0; name = "MENU_CONVERSION"; }' \
        '{ enabled = 0; name = "MENU_EXPRESSION"; }' \
        '{ enabled = 1; name = "MENU_DEFINITION"; }' \
        '{ enabled = 0; name = "SYSTEM_PREFS"; }' \
        '{ enabled = 1; name = DOCUMENTS; }' \
        '{ enabled = 1; name = DIRECTORIES; }' \
        '{ enabled = 1; name = PRESENTATIONS; }' \
        '{ enabled = 0; name = SPREADSHEETS; }' \
        '{ enabled = 1; name = PDF; }' \
        '{ enabled = 1; name = MESSAGES; }' \
        '{ enabled = 1; name = CONTACT; }' \
        '{ enabled = 1; name = "EVENT_TODO"; }' \
        '{ enabled = 1; name = IMAGES; }' \
        '{ enabled = 0; name = BOOKMARKS; }' \
        '{ enabled = 0; name = MUSIC; }' \
        '{ enabled = 0; name = MOVIES; }' \
        '{ enabled = 0; name = FONTS; }' \
        '{ enabled = 1; name = "MENU_OTHER"; }' \
        '{ enabled = 1; name = SOURCE; }'

    if [ $quitapp -ne 0 -a $apprunning = "true" ]; then
        open -a $appname
    fi
fi
