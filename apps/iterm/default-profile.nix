# non default value only
{
    "ASCII Anti Aliased" = 1;
    "AWDS Pane Directory" = "";
    "AWDS Pane Option" = "Recycle";
    "AWDS Tab Directory" = "";
    "AWDS Tab Option" = "Recycle";
    "AWDS Window Directory" = "";
    "AWDS Window Option" = "No";
    "Background Color" = {
        "Alpha Component" = 1;
        "Blue Component" = 1;
        "Color Space" = "sRGB";
        "Green Component" = 1;
        "Red Component" = 1;
    };
    "Blinking Cursor" = 1;
    Blur = 1;
    "Blur Radius" = 25;
    "BM Growl" = 0;
    "Bold Color" = {
        "Alpha Component" = 1;
        "Blue Component" = 1;
        "Color Space" = "sRGB";
        "Green Component" = 0;
        "Red Component" = 0;
    };
    "Brighten Bold Text" = 0;
    Columns = 99;
    "Cursor Color" = {
        "Alpha Component" = 1;
        "Blue Component" = 0;
        "Color Space" = "sRGB";
        "Green Component" = 0;
        "Red Component" = 0;
    };
    "Cursor Text Color" = {
        "Alpha Component" = 1;
        "Blue Component" = 0.9999999403953552;
        "Color Space" = "sRGB";
        "Green Component" = 0.9999999403953552;
        "Red Component" = 1;
    };
    "Custom Directory" = "Advanced";
    "Foreground Color" = {
        "Alpha Component" = 1;
        "Blue Component" = 0;
        "Color Space" = "sRGB";
        "Green Component" = 0;
        "Red Component" = 0;
    };
    Description = "Default";
    "Enable Triggers in Interactive Apps" = 0;
    "Flashing Bell" = 1;
    "Initial Use Transparency" = 1;
    # among other things, delete ^2 through ^8 as those are used to
    # switch workspaces
    "Keyboard Map" = {
        "0x2d-0x40000" = {
            Action = 11;
            Text = "0x1f";
        };
        "0x5e-0x60000" = {
            Action = 11;
            Text = "0x1e";
        };
        "0x7f-0x80000-0x33" = {
            Action = 10;
            Label = "";
            Text = "\177";
            Version = 1;
        };
        "0xf700-0x220000" = {
            Action = 10;
            Text = "[A";
        };
        "0xf700-0x240000" = {
            Action = 10;
            Text = "[A";
        };
        "0xf700-0x260000" = {
            Action = 10;
            Text = "[A";
        };
        "0xf700-0x280000" = {
            Action = 10;
            Text = "[A";
        };
        "0xf701-0x220000" = {
            Action = 10;
            Text = "[B";
        };
        "0xf701-0x240000" = {
            Action = 10;
            Text = "[B";
        };
        "0xf701-0x260000" = {
            Action = 10;
            Text = "[B";
        };
        "0xf701-0x280000" = {
            Action = 10;
            Text = "[B";
        };
        "0xf702-0x220000" = {
            Action = 10;
            Text = "[D";
        };
        "0xf702-0x240000" = {
            Action = 10;
            Text = "[5D";
        };
        "0xf702-0x260000" = {
            Action = 11;
            Text = "0x1b 0x1b 0x5b 0x44";
        };
        "0xf702-0x280000" = {
            Action = 10;
            Text = "b";
        };
        "0xf703-0x220000" = {
            Action = 10;
            Text = "[C";
        };
        "0xf703-0x240000" = {
            Action = 10;
            Text = "[5C";
        };
        "0xf703-0x260000" = {
            Action = 10;
            Text = "[C";
        };
        "0xf703-0x280000" = {
            Action = 10;
            Text = "f";
        };
        "0xf708-0x20000" = {
            Action = 10;
            Text = "[25~";
        };
        "0xf709-0x20000" = {
            Action = 10;
            Text = "[26~";
        };
        "0xf70a-0x20000" = {
            Action = 10;
            Text = "[28~";
        };
        "0xf70b-0x20000" = {
            Action = 10;
            Text = "[29~";
        };
        "0xf728-0x80000-0x75" = {
            Action = 10;
            Label = "";
            Text = "(";
            Version = 1;
        };
        "0xf729-0x20000" = {
            Action = 10;
            Text = "[H";
        };
        "0xf729-0x40000" = {
            Action = 5;
            Text = "";
        };
        "0xf72b-0x20000" = {
            Action = 10;
            Text = "[F";
        };
        "0xf72b-0x40000" = {
            Action = 4;
            Text = "";
        };
    };
    "Left Option Key Changeable" = 0;
    "Movement Keys Scroll Outside Interactive Apps" = 1;
    Name = "Default";
    "Normal Font" = "HackNFM-Regular 13";
    Rows = 40;
    "Scrollback Lines" = 2000;
    "Selected Text Color" = {
        "Alpha Component" = 1;
        "Blue Component" = 0;
        "Color Space" = "sRGB";
        "Green Component" = 0;
        "Red Component" = 0;
    };
    "Selection Color" = {
        "Alpha Component" = 1;
        "Blue Component" = 1;
        "Color Space" = "sRGB";
        "Green Component" = 0.5019607843;
        "Red Component" = 1;
    };
    "Show Status Bar" = 1;
    "Show Timestamps" = 2;
    "Status Bar Layout" = {
        components = [
            {
                class = "iTermStatusBarJobComponent";
                configuration = {
                    knobs = {
                        "base: compression resistance" = 1;
                        "base: priority" = 5;
                        maxwidth = "1.797693134862316e+308";
                        minwidth = 0;
                        "shared text color" = {
                            "Alpha Component" = 1;
                            "Blue Component" = 0.25;
                            "Color Space" = "sRGB";
                            "Green Component" = 0.25;
                            "Red Component" = 0.5;
                        };
                    };
                    "layout advanced configuration dictionary value" = {
                        algorithm = 0;
                        "auto-rainbow style" = 0;
                        font = ".AppleSystemUIFont 12";
                        "remove empty components" = 0;
                    };
                };
            }
            {
                class = "iTermStatusBarCPUUtilizationComponent";
                configuration = {
                    knobs = {
                        "base: priority" = 5;
                        "shared text color" = {
                            "Alpha Component" = 1;
                            "Blue Component" = 0.25;
                            "Color Space" = "sRGB";
                            "Green Component" = 0.5;
                            "Red Component" = 0.4087499976158142;
                        };
                    };
                    "layout advanced configuration dictionary value" = {
                        algorithm = 0;
                        "auto-rainbow style" = 0;
                        font = ".AppleSystemUIFont 12";
                        "remove empty components" = 0;
                    };
                };
            }
            {
                class = "iTermStatusBarMemoryUtilizationComponent";
                configuration = {
                    knobs = {
                        "base: priority" = 5;
                        "shared text color" = {
                            "Alpha Component" = 1;
                            "Blue Component" = 0.4325000047683716;
                            "Color Space" = "sRGB";
                            "Green Component" = 0.5;
                            "Red Component" = 0.25;
                        };
                    };
                    "layout advanced configuration dictionary value" = {
                        algorithm = 0;
                        "auto-rainbow style" = 0;
                        font = ".AppleSystemUIFont 12";
                        "remove empty components" = 0;
                    };
                };
            }
        ];
    };
    "Title Components" = 32;
    "Thin Strokes" = 1;
    Transparency = 0.15;
    Triggers = [
        {
            action = "SetHostnameTrigger";
            disabled = 0;
            parameter = "\\\\1";
            partial = 1;
            regex = "([-.\\\\w\\\\d]+)[: ]";
        }
        {
            action = "SetHostnameTrigger";
            disabled = 0;
            parameter = "\\\\1@\\\\2";
            partial = 1;
            regex = "([:punct:\\\\w\\\\d]+)@([-.\\\\w\\\\d]+)[: ]";
        }
        {
            action = "SetDirectoryTrigger";
            parameter = "\\\\1";
            partial = 1;
            regex = "[: ]\\\\[?([^$#%\\\\]]+)";
        }
        {
            action = "iTermShellPromptTrigger";
            partial = 1;
            regex = "^.+[$#] ?$";
        }
    ];
    "Use Non-ASCII Font" = 0;
    "Working Directory" = "";
}
