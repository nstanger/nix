# Copy this template to appname.sh and configure the settings accordingly.

# Settings
# The name of the application, e.g., "Finder".
appname="Mail"

# The corresponding defaults domain, e.g., "com.apple.finder".
appdefaults="com.apple.mail"

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

    # Display emails in threaded mode, sorted by date (newest at the top)
    # defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
    # defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "no"
    # defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

    # Enable plugins.
    # The following line will cease to work at some stage, but plugins
    # will probably also be gone by then anyway.
    sudo defaults write "/Library/Preferences/com.apple.mail.plist" EnableBundles 1

    if [ $quitapp -ne 0 -a $apprunning = "true" ]; then
        sleep 2
        open -a $appname
    fi
fi
