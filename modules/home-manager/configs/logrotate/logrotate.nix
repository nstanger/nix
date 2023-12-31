# see "man logrotate" for details
# Rotate log files weekly.
weekly

# Keep 4 weeks worth of backlogs.
rotate 4

# Create new (empty) log files after rotating old ones.
create

# Use date as a suffix of the rotated file.
dateext

# Compress log files.
compress

# Add your logrotate scripts to this directory for convenient inclusion.
include ~/.config/logrotate/logrotate.d
