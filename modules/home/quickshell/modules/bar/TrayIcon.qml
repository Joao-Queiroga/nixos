pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Controls
import "../common/"

Item {
  id: root

  required property SystemTrayItem trayItem
  property alias iconSize: icon.implicitSize

  implicitWidth: icon.implicitWidth
  implicitHeight: icon.implicitHeight

  IconImage {
    id: icon
    implicitSize: 20
    source: root.trayItem.icon
    MouseArea {
      anchors.fill: parent
      acceptedButtons: Qt.LeftButton | Qt.RightButton
      onClicked: mouse => {
        if (mouse.button === Qt.RightButton)
          trayPopup.active = !trayPopup.active;
        else
          root.trayItem.activate();
      }
    }
  }
  HoverHandler {
    id: iconHover
  }

  TrayPopup {
    id: trayPopup
    hoverTarget: root
    targetHover: iconHover
    menu: root.trayItem.menu
  }
}
