pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import "../common/"

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: root
      required property ShellScreen modelData
      screen: modelData

      anchors {
        top: true
        left: true
        right: true
      }
      implicitHeight: 24
      color: Config.bg

      RowLayout {
        anchors {
          left: parent.left
          verticalCenter: parent.verticalCenter
          leftMargin: 2
        }
        Workspaces {
          monitor: root.modelData
        }
        ActiveWindow {
          monitor: root.modelData
        }
      }
      RowLayout {
        anchors.centerIn: parent

        ClockWidget {
          color: Config.orange
          font {
            bold: true
          }
        }
      }
      RowLayout {
        anchors {
          right: parent.right
          verticalCenter: parent.verticalCenter
          rightMargin: 2
        }
        Rectangle {
          implicitWidth: trayRow.implicitWidth + 20
          implicitHeight: trayRow.implicitHeight + 4
          color: Config.blue7
          radius: 8
          RowLayout {
            id: trayRow
            anchors {
              centerIn: parent
              margins: 8
            }
            Repeater {
              model: SystemTray.items
              TrayIcon {
                required property SystemTrayItem modelData
                trayItem: modelData
              }
            }
          }
        }
        VolumeIcon {}
      }
    }
  }
}
