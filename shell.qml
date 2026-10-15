import Quickshell
import QtQuick

import "modules/Bar/"
import "modules/Launcher/"
import "modules/WorkspaceSwitcher/"
import "modules/Notification/"
import qs.modules.SettingsMenu
import qs.modules.Lockscreen

ShellRoot {
    Scope {
        AppLauncher {}
        Bar {}
        WorkspaceSwitcher {}
        SettingsMenu {}
        Notifications {}
        Lockscreen {}
    }
}
