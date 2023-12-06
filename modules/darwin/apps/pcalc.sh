# Copy this template to appname.sh and configure the settings accordingly.

# Settings
# The name of the application, e.g., "Finder".
appname="PCalc"

# The corresponding defaults domain, e.g., "com.apple.finder".
appdefaults="uk.co.tla-systems.pcalc"

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

    # this doesn't work
    defaults write $appdefaults "Variables_V4" 'tax = {"A64" = {length = 8; bytes = 0x0000000000002e40;}; Num = 15;}; tipPeople = 2; tipPercentage = 15;'

    if [ $quitapp -ne 0 -a $apprunning = "true" ]; then
        open -a $appname
    fi
 fi
