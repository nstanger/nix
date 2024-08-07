username: {
    Profiles = [
        {
            Name = "Other SSH: General";
            Guid = "a883ff38-8912-540c-a39b-60624fd8583f";
            "Use Custom Window Title" = false;
            "Background Color" = {
                "Red Component" = 1.0;
                "Color Space" = "sRGB";
                "Blue Component" = 0.4745098039;
                "Alpha Component" = 1;
                "Green Component" = 0.9882352941;
            };
            "Tags" = [
                "SSH"
            ];
        }
        {
            Name = "nzougorg@nzoug.org";
            Guid = "nzougorg@nzoug.org";
            "Dynamic Profile Parent Name" = "Other SSH: General";
            "Custom Command" = "Yes";
            Command = "/usr/bin/ssh nzougorg@nzoug.org";
            "Use Custom Window Title" = true;
            "Custom Window Title" = "nzougorg@nzoug.org";
            "Keyboard Map" = {
                "0xf702-0x280000" = {
                    Action = 10;
                    Text = "b";
                };
                "0xf703-0x280000" = {
                    Action = 10;
                    Text = "f";
                };
                "0x7f-0x80000-0x33" = {
                    Action = 10;
                    Text = builtins.fromJSON ''"\u007f"'';
                };
                "0xf728-0x80000-0x75" = {
                    Action = 10;
                    Text = "D";
                };
            };
            "Tags" = [
                "SSH"
                "NZOUG"
            ];
            "Bound Hosts" = [
                "nzoug.org"
            ];
        }
    ];
}
