import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import "../common/"
import "../services/"

Item {
  id: root
  required property DesktopEntry entry
  signal launched(DesktopEntry entry)

  onLaunched: entry => {
    AppSearch.recordUsage(entry.id);
  }

  Keys.onReturnPressed: {
    launch();
  }

  function launch() {
    if (entry.runInTerminal) {
      Quickshell.execDetached({
        command: ["app2unit", "--", "xdg-terminal-exec", ...entry.command],
        workingDirectory: entry.workingDirectory
      });
    } else {
      Quickshell.execDetached({
        command: ["app2unit", "--", ...entry.command],
        workingDirectory: entry.workingDirectory
      });
    }
    launched(entry);
  }

  implicitHeight: 56
  width: ListView.view.width

  Rectangle {
    id: card
    anchors.fill: parent
    radius: 8
    color: root.ListView.isCurrentItem && root.ListView.view.activeFocus ? Config.bg_highlight : "transparent"
    border.color: root.ListView.isCurrentItem && root.ListView.view.activeFocus ? Config.blue : "transparent"
    Row {
      spacing: 8
      anchors.verticalCenter: parent.verticalCenter
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right

      IconImage {
        id: icon
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.margins: 5
        implicitSize: 48
        source: Quickshell.iconPath(root.entry.icon, "application-x-executable")
      }

      Column {
        anchors.top: parent.top
        anchors.left: icon.right
        anchors.right: parent.right
        anchors.topMargin: 4
        Text {
          id: name
          text: root.entry.name
          color: Config.fg
          font.bold: true
          font.pixelSize: 18
        }
        Text {
          id: desc
          text: root.entry.comment
          color: Config.fg
          font.pixelSize: 12
          wrapMode: Text.WordWrap
          width: parent.width
        }
      }
    }
    MouseArea {
      anchors.fill: parent
      onClicked: {
        root.launch();
      }
    }
  }
}
