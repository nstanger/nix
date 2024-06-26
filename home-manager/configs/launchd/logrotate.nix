username: {
    enable = true;
    config = {
        ProgramArguments = [
            "/opt/homebrew/sbin/logrotate"
            "-s"
            "/Users/${username}/.logrotate.status"
            "/Users/${username}/.config/logrotate/logrotate.conf"
        ];
        StartCalendarInterval = [
            {
                Hour = 23;
                Minute = 30;
            }
        ];
    };
}
