pragma Singleton
import Quickshell
import Quickshell.Hyprland

Singleton {
    property var workspaceCountGreaterThan10: Hyprland.workspaces.values.filter(ws => isUnnamed(ws)).length
    property var workspaceGreaterThan10: Hyprland.workspaces.values.filter(ws => isUnnamed(ws))
    property int workspaceCount: workspaceCountGreaterThan10 + 10

    function isUnnamed(workspace) {
        if (workspace.id > 10) {
            return workspace;
        }
        return false;
    }
}
