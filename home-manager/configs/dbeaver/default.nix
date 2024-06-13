username: {
    "org.eclipse.ui.editors.prefs" = {
        # Just in case we need to create the file.
        "eclipse.preferences.version" = 1;

        # Editors > Text Editors > show line numbers
        "lineNumberRuler" = "true";

        # Editors > Text Editors > Insert spaces for tabs
        # This also appears independently under Editors > SQL Editor > Formatting but the settings don't appear to be connected?
        "spacesForTabs" = "true";
    };

    "org.eclipse.ui.workbench.prefs" = {
        "eclipse.preferences.version" = 1;

        # User Interface > Appearance > Colors and Fonts > DBeaver Fonts > Main font > Monospace font
        "org.jkiss.dbeaver.dbeaver.ui.fonts.monospace" = "1|Hack Nerd Font|13.0|0|COCOA|1|HackNF-Regular;";
    };

    "org.jkiss.dbeaver.core.prefs" = {
        "eclipse.preferences.version" = 1;

        # Editors > Data Editor > Data Formats
        #   > Locale
        #       > Country
        "dataformat.profile.country" = "NZ";
        #       > Language
        "dataformat.profile.language" = "en";
        #       > Locale - should be "en_NZ" but doesn't appear in the prefs files?)
        #   > Format > Numbers > Use grouping
        "dataformat.type.number.useGrouping" = "false";

        # Editors > Data Editor > Binary Editor > HEX Editor > Font selection
        "hex.font.name" = "Hack Nerd Font";
        "hex.font.size" = 13;

        # Editors > Data Editor
        #   > Use column names instead of column labels
        "resultset.column.label.ignore" = "true";
        #   > Activate advanced datetime editor
        "resultset.datetime.editor" = "true";

        # General > Usage Statistics > Send usage statistics
        "show-database-statistics" = "false";

        # Editors > SQL Editor
        #   > Formatting
        #       > Indent substatements in parentheses
        "sql.format.break.before.close.bracket" = "true";
        #       > Formatter
        "sql.format.formatter" = "COMPACT";
        #       > Insert delimiters in empty lines
        "sql.format.insert.delimiters.in.empty_lines" = "true";
        #       > Keyword case
        "sql.format.keywordCase" = "LOWER";
        #   > Code Completion > Insert table aliases (in FROM clause)
        "sql.proposals.insert.table.alias" = "NONE";
        #   > Open output viewer on new messages
        "SQLEditor.outputPanel.autoShow" = "false";

        # User Interface > Automatic updates check
        "ui.auto.update.check" = "false";

        # Drivers
        #   > Drivers location
        "ui.drivers.home" = "/Users/${username}/Library/DBeaverData/drivers";
        #   > Check for new driver versions
        "ui.drivers.version.update" = "true";

        # Editors > Booleans > Display mode
        "ui.render.boolean.style.checked.align" = "CENTER";
        "ui.render.boolean.style.mode" = "ICON";
        "ui.render.boolean.style.null.align" = "CENTER";
        "ui.render.boolean.style.unchecked.align" = "CENTER";

        # Show tip of the day (set in the "Tip of the day" dialog)
        "ui.show.tip.of.the.day.on.startup" = "false";

        # Metadata > Show row count for tables - should be true but doesn’t appear in the prefs files?
    };

    "org.jkiss.dbeaver.erd.ui.prefs" = {
        "eclipse.preferences.version" = 1;

        # Editors > Diagram Editor > Notation type
        # No, that's not a typo!
        "erd.notation.type" = "org.jkiss.dbeaver.erd.notaion.crowsfoot";
    };

    "org.jkiss.dbeaver.ui.statistics.prefs" = {
        "eclipse.preferences.version" = 1;

        # I think this suppresses asking about usage statistics on startup?
        "feature.tracking.skipConfirmation" = "true";
    };
}
