{
    AutoHideTmuxClientSession = 1;
    DimBackgroundWindows = 1;
    DisableWindowSizeSnap = 1;
    EnableProxyIcon = 1;
    HideTab = 0; # always show tab bar
    NoSyncSuppressDownloadConfirmation = 1;
    "NoSyncSuppressDownloadConfirmation_selection" = 0;
    NoSyncTurnOffBracketedPasteOnHostChange = 1;
    NoSyncTurnOffFocusReportingOnHostChange = 1;
    NoSyncTurnOffMouseReportingOnHostChange = 1;
    OpenFileInNewWindows = 1;
    SeparateWindowTitlePerTab = 0;
    ShowFullScreenTabBar = 1;
    # Can't remember whether "Show per-pane title bar with split panes" was
    # enabled but default, but I can't find it in defaults anyway :/.
    # It should be enabled.
    StatusBarPosition = 1;
    SUEnableAutomaticChecks = 1;
    SUSendProfileInfo = 0;
    SwapFindNextPrevious = 0;

    # profiles
    "New Bookmarks" = [
        (import ./default-profile.nix)
    ];
}
