{
    _FXSortFoldersFirst = true;
    # Seems like you have to specify ALL the values plus relaunch the
    # Finder for them to stick (cf. iTerm).
    DesktopViewSettings = {
        IconViewSettings = {
            arrangeBy = "kind";
            backgroundColorBlue = 1;
            backgroundColorGreen = 1;
            backgroundColorRed = 1;
            backgroundType = 0;
            gridOffsetX = 0;
            gridOffsetY = 0;
            gridSpacing = 54;
            iconSize = 64;
            labelOnBottom = 1;
            showIconPreview = 1;
            showItemInfo = 1;
            textSize = 12;
            viewOptionsVersion = 1;
        };
    };
    # show tab bar
    "NSWindowTabbingShoudShowTabBarKey-com.apple.finder.TBrowserWindow" = 1;
    # new windows default to user home
    NewWindowTarget = "PfHm";
    ShowExternalHardDrivesOnDesktop = true;
    ShowHardDrivesOnDesktop = true;
    ShowMountedServersOnDesktop = true;
    ShowRecentTags = false;
    SidebarTagsSctionDisclosedState = 0;
    StandardViewSettings = {
        ExtendedListViewSettingsV2 = {
            calculateAllSizes = 1;
            columns = [
                {
                    ascending = 1;
                    identifier = "name";
                    visible = 1;
                    width = 300;
                }
                {
                    ascending = 0;
                    identifier = "ubiquity";
                    visible = 0;
                    width = 35;
                }
                {
                    ascending = 0;
                    identifier = "dateModified";
                    visible = 1;
                    width = 181;
                }
                {
                    ascending = 0;
                    identifier = "dateCreated";
                    visible = 0;
                    width = 181;
                }
                {
                    ascending = 0;
                    identifier = "size";
                    visible = 1;
                    width = 97;
                }
                {
                    ascending = 1;
                    identifier = "kind";
                    visible = 1;
                    width = 115;
                }
                {
                    ascending = 1;
                    identifier = "label";
                    visible = 0;
                    width = 100;
                }
                {
                    ascending = 1;
                    identifier = "version";
                    visible = 0;
                    width = 75;
                }
                {
                    ascending = 1;
                    identifier = "comments";
                    visible = 0;
                    width = 300;
                }
                {
                    ascending = 0;
                    identifier = "dateLastOpened";
                    visible = 0;
                    width = 200;
                }
                {
                    ascending = 0;
                    identifier = "shareOwner";
                    visible = 0;
                    width = 200;
                }
                {
                    ascending = 0;
                    identifier = "shareLastEditor";
                    visible = 0;
                    width = 200;
                }
                {
                    ascending = 0;
                    identifier = "dateAdded";
                    visible = 0;
                    width = 181;
                }
                {
                    ascending = 0;
                    identifier = "invitationStatus";
                    visible = 0;
                    width = 210;
                }
            ];
            iconSize = 16;
            showIconPreview = 1;
            sortColumn = "name";
            textSize = 13;
            useRelativeDates = 1;
            viewOptionsVersion = 1;
        };
        GalleryViewSettings = {
            arrangeBy = "name";
            iconSize = 48;
            showIconPreview = 1;
            viewOptionsVersion = 1;
        };
        IconViewSettings = {
            arrangeBy = "name";
            backgroundColorBlue = 1;
            backgroundColorGreen = 1;
            backgroundColorRed = 1;
            backgroundType = 0;
            gridOffsetX = 0;
            gridOffsetY = 0;
            gridSpacing = 54;
            iconSize = 64;
            labelOnBottom = 1;
            showIconPreview = 1;
            showItemInfo = 1;
            textSize = 12;
            viewOptionsVersion = 1;
        };
        ListViewSettings = {
            calculateAllSizes = 1;
            columns = {
                comments = {
                    ascending = 1;
                    index = 7;
                    visible = 0;
                    width = 300;
                };
                dateCreated = {
                    ascending = 0;
                    index = 2;
                    visible = 0;
                    width = 181;
                };
                dateLastOpened = {
                    ascending = 0;
                    index = 8;
                    visible = 0;
                    width = 200;
                };
                dateModified = {
                    ascending = 0;
                    index = 1;
                    visible = 1;
                    width = 181;
                };
                kind = {
                    ascending = 1;
                    index = 4;
                    visible = 1;
                    width = 115;
                };
                label = {
                    ascending = 1;
                    index = 5;
                    visible = 0;
                    width = 100;
                };
                name = {
                    ascending = 1;
                    index = 0;
                    visible = 1;
                    width = 300;
                };
                size = {
                    ascending = 0;
                    index = 3;
                    visible = 1;
                    width = 97;
                };
                version = {
                    ascending = 1;
                    index = 6;
                    visible = 0;
                    width = 75;
                };
            };
            iconSize = 16;
            showIconPreview = 1;
            sortColumn = "name";
            textSize = 13;
            useRelativeDates = 1;
            viewOptionsVersion = 1;
        };
        SettingsType = "StandardViewSettings";
    };
    TrashViewSettings = {
        CustomViewStyleVersion = 1;
        ExtendedListViewSettingsV2 = {
            calculateAllSizes = 1;
            columns = [
                {
                    ascending = 1;
                    identifier = "name";
                    visible = 1;
                    width = 307;
                }
                {
                    ascending = 0;
                    identifier = "ubiquity";
                    visible = 0;
                    width = 35;
                }
                {
                    ascending = 0;
                    identifier = "dateModified";
                    visible = 1;
                    width = 181;
                }
                {
                    ascending = 0;
                    identifier = "dateCreated";
                    visible = 0;
                    width = 181;
                }
                {
                    ascending = 0;
                    identifier = "size";
                    visible = 1;
                    width = 97;
                }
                {
                    ascending = 1;
                    identifier = "kind";
                    visible = 1;
                    width = 115;
                }
                {
                    ascending = 1;
                    identifier = "label";
                    visible = 0;
                    width = 100;
                }
                {
                    ascending = 1;
                    identifier = "version";
                    visible = 0;
                    width = 75;
                }
                {
                    ascending = 1;
                    identifier = "comments";
                    visible = 0;
                    width = 300;
                }
                {
                    ascending = 0;
                    identifier = "dateLastOpened";
                    visible = 0;
                    width = 200;
                }
                {
                    ascending = 0;
                    identifier = "shareOwner";
                    visible = 0;
                    width = 200;
                }
                {
                    ascending = 0;
                    identifier = "shareLastEditor";
                    visible = 0;
                    width = 200;
                }
                {
                    ascending = 0;
                    identifier = "dateAdded";
                    visible = 0;
                    width = 181;
                }
                {
                    ascending = 0;
                    identifier = "invitationStatus";
                    visible = 0;
                    width = 210;
                }
            ];
            iconSize = 16;
            scrollPositionX = 0;
            scrollPositionY = 0;
            showIconPreview = 1;
            sortColumn = "name";
            textSize = 13;
            useRelativeDates = 1;
            viewOptionsVersion = 1;
        };
        ListViewSettings = {
            calculateAllSizes = 0;
            columns = {
                comments = {
                    ascending = 1;
                    index = 7;
                    visible = 0;
                    width = 300;
                };
                dateCreated = {
                    ascending = 0;
                    index = 2;
                    visible = 0;
                    width = 181;
                };
                dateLastOpened = {
                    ascending = 0;
                    index = 8;
                    visible = 0;
                    width = 200;
                };
                dateModified = {
                    ascending = 0;
                    index = 1;
                    visible = 1;
                    width = 181;
                };
                kind = {
                    ascending = 1;
                    index = 4;
                    visible = 1;
                    width = 115;
                };
                label = {
                    ascending = 1;
                    index = 5;
                    visible = 0;
                    width = 100;
                };
                name = {
                    ascending = 1;
                    index = 0;
                    visible = 1;
                    width = 307;
                };
                size = {
                    ascending = 0;
                    index = 3;
                    visible = 1;
                    width = 97;
                };
                version = {
                    ascending = 1;
                    index = 6;
                    visible = 0;
                    width = 75;
                };
            };
            iconSize = 16;
            scrollPositionX = 0;
            scrollPositionY = 0;
            showIconPreview = 1;
            sortColumn = "name";
            textSize = 13;
            useRelativeDates = 1;
            viewOptionsVersion = 1;
        };
        WindowState = {
            ContainerShowSidebar = 1;
            ShowSidebar = 1;
            ShowStatusBar = 1;
            ShowTabView = 0;
            ShowToolbar = 1;
        };
    };
    WarnOnEmptyTrash = false;
}
