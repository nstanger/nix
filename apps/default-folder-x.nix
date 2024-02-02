{
    SUAutomaticallyUpdate = 0;
    SUEnableAutomaticChecks = 1;
    SUScheduledCheckInterval = 604800;
    # setting this up front seems to break adding to login items?
    # askedToLaunchAtLogin = 1;
    cloudServicesToIncludeInHistory = 14;
    defaultToDocumentFolder = 1;
    favoritesStaySorted = 0;
    finderClickDesktop = 1;
    menusShowParents = 1;
    menusSortAllSubfoldersByDate = 0;
    menusSortRecentByName = "1";
    menusSortSubfoldersByName = "1";
    openInTerminal = 1;
    openInTerminalApp = 2; # iTerm
    openInTerminalModifiers = 524288;
    toolbarShowAttributesOnOpen = 1;
    toolbarShowAttributesOnSave = 1;
    toolbarStyle = 2;
    welcomeShown = 1;
    keyBindings = [
        {
            action = "groupName:";
            context = 1;
            key = {
            };
            name = "File Dialog Menu Commands";
        }
        {
            action = "finderOpenFolder:";
            context = 1;
            key = {
                characters = "\\U0192";
                charactersIgnoringModifiers = "f";
                keyCode = 3;
                modifierFlags = 1572864;
            };
            name = "Open in Finder";
        }
        {
            action = "createNewFolder:";
            context = 1;
            key = {
                characters = "n";
                charactersIgnoringModifiers = "N";
                keyCode = 45;
                modifierFlags = 1179648;
            };
            name = "New Folder";
        }
        {
            action = "copyPathOfFolder:";
            context = 1;
            key = {
            };
            name = "Copy Folder Path to Clipboard";
        }
        {
            action = "copyNameOfFolder:";
            context = 1;
            key = {
            };
            name = "Copy Folder Name to Clipboard";
        }
        {
            action = "searchWithHoudahSpot:";
            context = 1;
            key = {
            };
            name = "Search Folder with HoudahSpot";
        }
        {
            action = "duplicateSelection:";
            context = 1;
            key = {
            };
            name = "Duplicate";
        }
        {
            action = "renameSelection:";
            context = 1;
            key = {
                characters = "\\U00ae";
                charactersIgnoringModifiers = "r";
                keyCode = 15;
                modifierFlags = 1572864;
            };
            name = "Rename";
        }
        {
            action = "copySelection:";
            context = 1;
            key = {
                characters = "\\U00e7";
                charactersIgnoringModifiers = "c";
                keyCode = 8;
                modifierFlags = 1572864;
            };
            name = "Copy";
        }
        {
            action = "moveSelection:";
            context = 1;
            key = {
                characters = "\\U00b5";
                charactersIgnoringModifiers = "m";
                keyCode = 46;
                modifierFlags = 1572864;
            };
            name = "Move";
        }
        {
            action = "aliasSelection:";
            context = 1;
            key = {
            };
            name = "Make Alias";
        }
        {
            action = "getInfoOnSelection:";
            context = 1;
            key = {
                characters = "i";
                charactersIgnoringModifiers = "i";
                keyCode = 34;
                modifierFlags = 1048576;
            };
            name = "Get Info";
        }
        {
            action = "revealSelection:";
            context = 1;
            key = {
                characters = "r";
                charactersIgnoringModifiers = "r";
                keyCode = 15;
                modifierFlags = 1048576;
            };
            name = "Show in Finder";
        }
        {
            action = "trashSelection:";
            context = 1;
            key = {
                characters = "t";
                charactersIgnoringModifiers = "t";
                keyCode = 17;
                modifierFlags = 1048576;
            };
            name = "Move to Trash";
        }
        {
            action = "copyPathOfSelection:";
            context = 1;
            key = {
            };
            name = "Copy Selected Path to Clipboard";
        }
        {
            action = "copyNameOfSelection:";
            context = 1;
            key = {
            };
            name = "Copy Selected Name to Clipboard";
        }
        {
            action = "zipSelection:";
            context = 1;
            key = {
            };
            name = "Compress";
        }
        {
            action = "unzipSelection:";
            context = 1;
            key = {
            };
            name = "Decompress";
        }
        {
            action = "quicklookSelection:";
            context = 1;
            key = {
            };
            name = "Quicklook";
        }
        {
            action = "showPreferences:";
            context = 1;
            key = {
            };
            name = "Preferences";
        }
        {
            action = "goToDesktop:";
            context = 1;
            key = {
                characters = "d";
                charactersIgnoringModifiers = "d";
                keyCode = 2;
                modifierFlags = 1048576;
            };
            name = "Desktop";
        }
        {
            action = "goToHome:";
            context = 1;
            key = {
                characters = "h";
                charactersIgnoringModifiers = "H";
                keyCode = 4;
                modifierFlags = 1179648;
            };
            name = "Home";
        }
        {
            action = "goToICloud:";
            context = 1;
            key = {
                characters = "i";
                charactersIgnoringModifiers = "I";
                keyCode = 34;
                modifierFlags = 1179648;
            };
            name = "iCloud";
        }
        {
            action = "addToFavorites:";
            context = 1;
            key = {
            };
            name = "Add to Favorites";
        }
        {
            action = "removeFromFavorites:";
            context = 1;
            key = {
            };
            name = "Remove From Favorites";
        }
        {
            action = "switchToApplicationFolder:";
            context = 1;
            key = {
            };
            name = "Go to Application Folder";
        }
        {
            action = "setDefaultFolderForApp:";
            context = 1;
            key = {
            };
            name = "Set Default Folder for Application";
        }
        {
            action = "setDefaultFolderForAppAndType:";
            context = 1;
            key = {
            };
            name = "Set Default Folder for Application &amp; File Type";
        }
        {
            action = "setDefaultFolderForType:";
            context = 1;
            key = {
            };
            name = "Set Default Folder for File Type";
        }
        {
            action = "switchToDefaultFolder:";
            context = 1;
            key = {
                characters = "u";
                charactersIgnoringModifiers = "u";
                keyCode = 32;
                modifierFlags = 1048576;
            };
            name = "Go to Default Folder";
        }
        {
            action = "goToPreviousRecentFile:";
            context = 1;
            key = {
            };
            name = "Previous Recent File";
        }
        {
            action = "goToNextRecentFile:";
            context = 1;
            key = {
            };
            name = "Next Recent File";
        }
        {
            action = "goToPreviousRecentFolder:";
            context = 1;
            key = {
                characters = "\\Uf700";
                charactersIgnoringModifiers = "\\Uf700";
                keyCode = 126;
                modifierFlags = 524288;
            };
            name = "Previous Recent Folder";
        }
        {
            action = "goToNextRecentFolder:";
            context = 1;
            key = {
                characters = "\\Uf701";
                charactersIgnoringModifiers = "\\Uf701";
                keyCode = 125;
                modifierFlags = 524288;
            };
            name = "Next Recent Folder";
        }
        {
            action = "goToPreviousFinderWindow:";
            context = 1;
            key = {
                characters = "\\Uf700";
                charactersIgnoringModifiers = "\\Uf700";
                keyCode = 126;
                modifierFlags = 655360;
            };
            name = "Previous Finder Window";
        }
        {
            action = "goToNextFinderWindow:";
            context = 1;
            key = {
                characters = "\\Uf701";
                charactersIgnoringModifiers = "\\Uf701";
                keyCode = 125;
                modifierFlags = 655360;
            };
            name = "Next Finder Window";
        }
        {
            action = "groupName:";
            context = 1;
            key = {
            };
            name = "File Dialog Menus";
        }
        {
            action = "showUtilityMenu:";
            context = 1;
            key = {
            };
            name = "Show Utility Menu";
        }
        {
            action = "showComputerMenu:";
            context = 1;
            key = {
            };
            name = "Show Computer Menu";
        }
        {
            action = "showFavoritesMenu:";
            context = 1;
            key = {
            };
            name = "Show Favorites Menu";
        }
        {
            action = "showRecentFolderMenu:";
            context = 1;
            key = {
            };
            name = "Show Recent Folder Menu";
        }
        {
            action = "showRecentFileMenu:";
            context = 1;
            key = {
            };
            name = "Show Recent File Menu";
        }
        {
            action = "showFinderWindowMenu:";
            context = 1;
            key = {
            };
            name = "Show Finder Window Menu";
        }
        {
            action = "groupName:";
            context = 1;
            key = {
            };
            name = "File Dialog Actions";
        }
        {
            action = "toggleToolbar:";
            context = 1;
            key = {
            };
            name = "Show / Hide Toolbar";
        }
        {
            action = "selectTagField:";
            context = 1;
            key = {
            };
            name = "Enter Tags";
        }
        {
            action = "selectCommentField:";
            context = 1;
            key = {
            };
            name = "Enter Comments";
        }
        {
            action = "selectFilenameEditField:";
            context = 1;
            key = {
                characters = "l";
                charactersIgnoringModifiers = "l";
                keyCode = 37;
                modifierFlags = 1048576;
            };
            name = "Enter Filename";
        }
        {
            action = "selectFileList:";
            context = 1;
            key = {
            };
            name = "Navigate Files Using Keyboard";
        }
        {
            action = "groupName:";
            context = 1;
            key = {
            };
            name = "Quick Search Actions";
        }
        {
            action = "quickSearchAll:";
            context = 16;
            key = {
                characters = " ";
                charactersIgnoringModifiers = " ";
                keyCode = 49;
                modifierFlags = 1179648;
            };
            name = "Search All";
        }
        {
            action = "quickSearchFiles:";
            context = 16;
            key = {
                characters = "f";
                charactersIgnoringModifiers = "F";
                keyCode = 3;
                modifierFlags = 1179648;
            };
            name = "Search Files";
        }
        {
            action = "quickSearchFolders:";
            context = 16;
            key = {
                characters = "d";
                charactersIgnoringModifiers = "D";
                keyCode = 2;
                modifierFlags = 1179648;
            };
            name = "Search Folders";
        }
        {
            action = "quickSearchApps:";
            context = 16;
            key = {
                characters = "a";
                charactersIgnoringModifiers = "A";
                keyCode = 0;
                modifierFlags = 1179648;
            };
            name = "Search Apps";
        }
        {
            action = "quickSearchRecent:";
            context = 16;
            key = {
                characters = "\\U00ae";
                charactersIgnoringModifiers = "r";
                keyCode = 15;
                modifierFlags = 1572864;
            };
            name = "Search Recent Items";
        }
        {
            action = "quickSearchFavorite:";
            context = 16;
            key = {
                characters = "\\U0192";
                charactersIgnoringModifiers = "f";
                keyCode = 3;
                modifierFlags = 1572864;
            };
            name = "Search Favorites";
        }
        {
            action = "quickSearchFinder:";
            context = 16;
            key = {
                characters = "~";
                charactersIgnoringModifiers = "n";
                keyCode = 45;
                modifierFlags = 1572864;
            };
            name = "Search Finder Windows";
        }
        {
            action = "quickSearchSpotlight:";
            context = 16;
            key = {
                characters = "s";
                charactersIgnoringModifiers = "S";
                keyCode = 1;
                modifierFlags = 1179648;
            };
            name = "Search Using Spotlight";
        }
        {
            action = "groupName:";
            context = 1;
            key = {
            };
            name = "Finder Commands";
        }
        {
            action = "addToFavoritesInFinder:";
            context = 2;
            key = {
            };
            name = "Add to Favorites";
        }
        {
            action = "removeFromFavoritesInFinder:";
            context = 2;
            key = {
            };
            name = "Remove From Favorites";
        }
        {
            action = "switchToDefaultFolderInFinder:";
            context = 2;
            key = {
            };
            name = "Go to Default Folder";
        }
        {
            action = "goToPreviousRecentFileInFinder:";
            context = 2;
            key = {
            };
            name = "Previous Recent File";
        }
        {
            action = "goToNextRecentFileInFinder:";
            context = 2;
            key = {
            };
            name = "Next Recent File";
        }
        {
            action = "goToPreviousRecentFolderInFinder:";
            context = 2;
            key = {
                characters = "\\Uf700";
                charactersIgnoringModifiers = "\\Uf700";
                keyCode = 126;
                modifierFlags = 524288;
            };
            name = "Previous Recent Folder";
        }
        {
            action = "goToNextRecentFolderInFinder:";
            context = 2;
            key = {
                characters = "\\Uf701";
                charactersIgnoringModifiers = "\\Uf701";
                keyCode = 125;
                modifierFlags = 524288;
            };
            name = "Next Recent Folder";
        }
        {
            action = "goToPreviousFinderWindowInFinder:";
            context = 2;
            key = {
                characters = "\\Uf700";
                charactersIgnoringModifiers = "\\Uf700";
                keyCode = 126;
                modifierFlags = 655360;
            };
            name = "Previous Finder Window";
        }
        {
            action = "goToNextFinderWindowInFinder:";
            context = 2;
            key = {
                characters = "\\Uf701";
                charactersIgnoringModifiers = "\\Uf701";
                keyCode = 125;
                modifierFlags = 655360;
            };
            name = "Next Finder Window";
        }
        {
            action = "showMenu:";
            context = 2;
            key = {
                characters = "\\n\\t\\t";
                charactersIgnoringModifiers = "m";
                keyCode = 46;
                modifierFlags = 1835008;
            };
            name = "Show Menu";
        }
        {
            action = "toggleFinderBezel:";
            context = 2;
            key = {
            };
            name = "Show / Hide Finder Drawer";
        }
        {
            action = "groupName:";
            context = 1;
            key = {
            };
            name = "System-Wide Commands";
        }
        {
            action = "switchToPreviousFolderSet:";
            context = 5;
            key = {
            };
            name = "Switch to Previous Folder Set";
        }
        {
            action = "switchToNextFolderSet:";
            context = 5;
            key = {
            };
            name = "Switch to Next Folder Set";
        }
        {
            action = "showMenuSystemWide:";
            context = 4;
            key = {
            };
            name = "Show Menu";
        }
        {
            action = "showKeyboardBezel:";
            context = 4;
            key = {
                characters = "";
                charactersIgnoringModifiers = "";
                # the default key binding (cmd-shift-space) conflicts with
                # 1Password's Quick Access
                keyCode = "-1";
                modifierFlags = 0;
            };
            name = "Show Quick Search Window";
        }
    ];
}
