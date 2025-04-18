username: {
    Profiles = [
        {
            Name = "Home SSH: General";
            Guid = "bff54482-58db-57fa-a365-fe24e377d117";
            "Use Custom Window Title" = false;
            "Background Color" = {
                "Red Component" = 0.8;
                "Color Space" = "sRGB";
                "Blue Component" = 0.4;
                "Alpha Component" = 1;
                "Green Component" = 1;
            };
            "Tags" = [
                "SSH"
                "Home"
            ];
        }
        {
            Name = "nstanger@klow.stanger.org.nz";
            Guid = "nstanger@klow.stanger.org.nz";
            "Dynamic Profile Parent Name" = "Home SSH: General";
            "Custom Command" = "Yes";
            Command = "/usr/bin/ssh -p 22422 nstanger@klow.stanger.org.nz";
            "Use Custom Window Title" = true;
            "Custom Window Title" = "nstanger@klow.stanger.org.nz";
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
                    # workaround for literal delete character (ASCII 127, U+007f)
                    # see <https://github.com/NixOS/nix/issues/10082#issuecomment-2059228774>
                    Text = builtins.fromJSON ''"\u007f"'';
                };
                "0xf728-0x80000-0x75" = {
                    Action = 10;
                    Text = "D";
                };
            };
            "Bound Hosts" = [
                "klow"
            ];
        }
        {
            Name = "nstanger@sprodj.stanger.org.nz";
            Guid = "nstanger@sprodj.stanger.org.nz";
            "Dynamic Profile Parent Name" = "Home SSH: General";
            "Custom Command" = "Yes";
            Command = "/usr/bin/ssh -p 22423 nstanger@sprodj.stanger.org.nz";
            "Use Custom Window Title" = true;
            "Custom Window Title" = "nstanger@sprodj.stanger.org.nz";
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
                "sprodj"
            ];
        }
        {
            Name = "nstanger@khemikal.stanger.org.nz";
            Guid = "nstanger@khemikal.stanger.org.nz";
            "Dynamic Profile Parent Name" = "Home SSH: General";
            "Custom Command" = "Yes";
            Command = "/usr/bin/ssh nstanger@khemikal.stanger.org.nz";
            "Use Custom Window Title" = true;
            "Custom Window Title" = "nstanger@khemikal.stanger.org.nz";
            "Bound Hosts" = [
                "khemikal"
            ];
        }
        {
            Name = "nstanger@poldavia.stanger.org.nz";
            Guid = "nstanger@poldavia.stanger.org.nz";
            "Dynamic Profile Parent Name" = "Home SSH: General";
            "Custom Command" = "Yes";
            Command = "/usr/bin/ssh nstanger@poldavia.stanger.org.nz";
            "Use Custom Window Title" = true;
            "Custom Window Title" = "nstanger@poldavia.stanger.org.nz";
            "Bound Hosts" = [
                "poldavia"
            ];
        }
        {
            Name = "nstanger@router.stanger.org.nz";
            Guid = "nstanger@router.stanger.org.nz";
            "Dynamic Profile Parent Name" = "Home SSH: General";
            "Custom Command" = "Yes";
            Command = "/usr/bin/ssh -p 22424 nstanger@router.stanger.org.nz";
            "Use Custom Window Title" = true;
            "Custom Window Title" = "nstanger@router.stanger.org.nz";
            "Bound Hosts" = [
                "router3"
            ];
        }
        {
            Name = "root@router3.stanger.org.nz";
            Guid = "root@router3.stanger.org.nz";
            "Dynamic Profile Parent Name" = "Home SSH: General";
            "Custom Command" = "Yes";
            Command = "/usr/bin/ssh -p 22425 root@router3.stanger.org.nz";
            "Use Custom Window Title" = true;
            "Custom Window Title" = "root@router3.stanger.org.nz";
            "Bound Hosts" = [
                "router3"
            ];
        }
        {
            Name = "nstanger@sondonesia.stanger.org.nz";
            Guid = "nstanger@sondonesia.stanger.org.nz";
            "Dynamic Profile Parent Name" = "Home SSH: General";
            "Custom Command" = "Yes";
            Command = "/usr/bin/ssh nstanger@sondonesia.stanger.org.nz";
            "Use Custom Window Title" = true;
            "Custom Window Title" = "nstanger@sondonesia.stanger.org.nz";
            "Bound Hosts" = [
                "sondonesia"
            ];
        }
        {
            Name = "nstanger@syldavia.stanger.org.nz";
            Guid = "nstanger@syldavia.stanger.org.nz";
            "Dynamic Profile Parent Name" = "Home SSH: General";
            "Custom Command" = "Yes";
            Command = "/usr/bin/ssh nstanger@syldavia.stanger.org.nz";
            "Use Custom Window Title" = true;
            "Custom Window Title" = "nstanger@syldavia.stanger.org.nz";
            "Bound Hosts" = [
                "syldavia"
            ];
        }
    ];
}
