# Copy this template to appname.sh and configure the settings accordingly.

# Settings
# The name of the application, e.g., "Finder".
appname="Preview"

# The corresponding defaults domain, e.g., "com.apple.finder".
appdefaults="com.apple.Preview"

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

    # defaults can't write complex nested structures using the
    # provided command line options. The only way seems to be to
    # provide a "legacy plist string", which may break at some
    # future point?
    # Tried: one huge string (bleh); printf | xargs (less bleh); heredoc (failed).
    printf "'%s; %s; %s; %s; %s;'" \
        '"TB Display Mode" = 2' \
        '"TB Icon Size Mode" = 1' \
        '"TB Is Shown" = 1' \
        '"TB Size Mode" = 1' \
        '"TB Item Identifiers" = (view, inspector, "zoom_and_actual", scale, "zoom_to_fit", share, NSToolbarFlexibleSpaceItem, selection, "edit_banner", markup, rotate, "form_filling", search)' \
    | xargs defaults write $appdefaults "NSToolbar Configuration CommonToolbar_v5.1"

    if [ $quitapp -ne 0 -a $apprunning = "true" ]; then
        open -a $appname
    fi
 fi
