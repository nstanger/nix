username: {
    Profiles = [
        {
            Name = "Work SSH: General";
            Guid = "8e2cb10f-243c-58e6-a005-972c1213ec0d";
            "Use Custom Window Title" = false;
            "Background Color" = {
                "Red Component" = 1;
                "Color Space" = "sRGB";
                "Blue Component" = 0.4;
                "Alpha Component" = 1;
                "Green Component" = 0.8;
            };
            "Tags" = [
                "SSH"
                "Work"
            ];
        }
        {
            Name = "stani07p@KGVYYWHLG6.corp.uod.otago.ac.nz";
            Guid = "stani07p@KGVYYWHLG6.corp.uod.otago.ac.nz";
            "Dynamic Profile Parent Name" = "Work SSH: General";
            "Custom Command" = "Yes";
            Command = "/usr/bin/ssh stani07p@KGVYYWHLG6.corp.uod.otago.ac.nz";
            "Use Custom Window Title" = true;
            "Custom Window Title" = "stani07p@KGVYYWHLG6.corp.uod.otago.ac.nz";
            # "Bound Hosts" = [
            #     "KGVYYWHLG6"
            # ];
        }
        {
            Name = "stani07p@isdb.uod.otago.ac.nz";
            Guid = "stani07p@isdb.uod.otago.ac.nz";
            "Dynamic Profile Parent Name" = "Work SSH: General";
            "Custom Command" = "Yes";
            Command = "/usr/bin/ssh stani07p@isdb.uod.otago.ac.nz";
            "Use Custom Window Title" = true;
            "Custom Window Title" = "stani07p@isdb.uod.otago.ac.nz";
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
            "Bound Hosts" = [
                "rtis-infos-db-01"
            ];
        }
    ];
}
