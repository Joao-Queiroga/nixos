import QtQuick
import Quickshell
import Quickshell.Wayland
import "../common"

LazyLoader {
  id: root

  property Item hoverTarget
  property HoverHandler targetHover
  property QsMenuHandle menu

  component: PopupWindow {
    anchor.window: root.hoverTarget?.QsWindow?.window
    anchor.rect.x: root.hoverTarget?.QsWindow?.window.itemRect(root.hoverTarget).x ?? 0
    anchor.rect.y: (root.hoverTarget?.QsWindow?.window.itemRect(root.hoverTarget).y ?? 0) + (root.hoverTarget?.height ?? 0)
    implicitWidth: trayMenuContent.implicitWidth + 20
    implicitHeight: trayMenuContent.implicitHeight + 20
    color: "transparent"
    visible: true
    HoverHandler {
      id: popupHover
    }

    onVisibleChanged: if (!visible)
      root.active = false

    Timer {
      interval: 300
      running: !popupHover.hovered && !root.targetHover.hovered
      onTriggered: root.active = false
    }

    Rectangle {
      anchors.fill: parent
      anchors.margins: 4
      color: Config.bg
      radius: 8
      border {
        color: Config.bg_highlight
        width: 1
      }
      TrayMenu {
        id: trayMenuContent
        anchors.centerIn: parent
        trayItem: root.menu
      }
    }
  }
}
