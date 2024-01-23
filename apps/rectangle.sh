# Copy this template to appname.sh and configure the settings accordingly.

# Settings
# The name of the application, e.g., "Finder".
appname="Rectangle"

# The corresponding defaults domain, e.g., "com.apple.finder".
appdefaults="com.knollsoft.Rectangle"

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
        almostMaximize = {
            keyCode = 82;
            modifierFlags = 1966080;
        };
        bottomHalf = {
            keyCode = 84;
            modifierFlags = 1835008;
        };
        bottomLeft = {
            keyCode = 83;
            modifierFlags = 1835008;
        };
        bottomRight = {
            keyCode = 85;
            modifierFlags = 1835008;
        };
        center = {
            keyCode = 75;
            modifierFlags = 1835008;
        };
        centerHalf = {
            keyCode = 87;
            modifierFlags = 1835008;
        };
        larger = {
            keyCode = 69;
            modifierFlags = 1835008;
        };
        leftHalf = {
            keyCode = 86;
            modifierFlags = 1835008;
        };
        maximize = {
            keyCode = 82;
            modifierFlags = 1835008;
        };
        maximizeHeight = {
            keyCode = 126;
            modifierFlags = 1835008;
        };
        restore = {
            keyCode = 71;
            modifierFlags = 1835008;
        };
        rightHalf = {
            keyCode = 88;
            modifierFlags = 1835008;
        };
        smaller = {
            keyCode = 78;
            modifierFlags = 1835008;
        };
        topHalf = {
            keyCode = 91;
            modifierFlags = 1835008;
        };
        topLeft = {
            keyCode = 89;
            modifierFlags = 1835008;
        };
        topRight = {
            keyCode = 92;
            modifierFlags = 1835008;
        };
EOF
tr -d '\n' | xargs --replace=PLIST defaults write $appdefaults 'PLIST'

    if [ $quitapp -ne 0 -a $apprunning = "true" ]; then
        open -a $appname
    fi
fi
