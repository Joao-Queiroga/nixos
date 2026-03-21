pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Hyprland
import QtQuick
import "../common/"

Repeater {
  id: root
  model: 9
  required property ShellScreen monitor
  property HyprlandMonitor mon: Hyprland.monitors.values.find(m => m.name === monitor.name)

  Rectangle {
    required property int index
    property HyprlandMonitor mon: root.mon
    property int wid: index + ((mon ? mon.id : 0) * 10) + 1
    property HyprlandWorkspace ws: Hyprland.workspaces.values.find(w => w.id === wid)
    property bool isActive: mon.activeWorkspace.id === wid

    color: isActive ? Config.purple : (ws ? Config.blue : Config.comment)
    implicitWidth: isActive ? 18 : 10
    implicitHeight: 10
    radius: 5

    Behavior on implicitWidth {
      NumberAnimation {
        duration: 150
        easing.type: Easing.InOutQuad
      }
    }

    MouseArea {
      anchors.fill: parent
      onClicked: Hyprland.dispatch("workspace " + parent.wid)
    }
  }
}
