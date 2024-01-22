# Copy this template to appname.sh and configure the settings accordingly.

# Settings
# The name of the application, e.g., "Finder".
appname="MsgFiler"

# The corresponding defaults domain, e.g., "com.apple.finder".
appdefaults="com.atow.msgfiler"

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

    # repeat as needed...
    # defaults write $appdefaults key value
    #
    # A more readable way to install a complex plist value (requires
    # findutils xargs installed as a system package):
    cat <<EOF |
        characters = \"\";
        keyCode = 99;
        modifierFlags = 8650752;
EOF
tr -d '\n' | xargs --replace=PLIST defaults write $appdefaults "MsgFilerShortcut" 'PLIST'

    if [ $quitapp -ne 0 -a $apprunning = "true" ]; then
        open -a $appname
    fi
 fi
