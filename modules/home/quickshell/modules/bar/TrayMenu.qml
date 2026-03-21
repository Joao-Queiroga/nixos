pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import Quickshell.DBusMenu
import QtQuick
import QtQuick.Controls
import "../common"

StackView {
  id: root

  required property QsMenuHandle trayItem

  implicitWidth: currentItem.implicitWidth
  implicitHeight: currentItem.implicitHeight

  initialItem: SubMenu {
    handle: root.trayItem
  }

  pushEnter: NoAnim {}
  pushExit: NoAnim {}
  popEnter: NoAnim {}
  popExit: NoAnim {}

  component NoAnim: Transition {
    NumberAnimation {
      duration: 0
    }
  }

  component SubMenu: Column {
    id: menu

    required property QsMenuHandle handle
    property bool isSubMenu
    property bool shown

    padding: 6
    spacing: 2

    opacity: shown ? 1 : 0
    scale: shown ? 1 : 0.8

    Component.onCompleted: shown = true
    StackView.onActivating: shown = true
    StackView.onDeactivating: shown = false
    StackView.onRemoved: destroy()

    Behavior on opacity {
      NumberAnimation {
        duration: 150
        easing.type: Easing.InOutQuad
      }
    }
    Behavior on scale {
      NumberAnimation {
        duration: 150
        easing.type: Easing.InOutQuad
      }
    }

    QsMenuOpener {
      id: menuOpener
      menu: menu.handle
    }

    Rectangle {
      visible: menu.isSubMenu
      implicitWidth: 200
      implicitHeight: backRow.implicitHeight + 4
      radius: height / 2
      color: Config.bg_highlight

      Row {
        id: backRow
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.margins: 6
        spacing: 4

        Text {
          text: "‹"
          color: Config.fg
          anchors.verticalCenter: parent.verticalCenter
        }
        Text {
          text: qsTr("Back")
          color: Config.fg
          anchors.verticalCenter: parent.verticalCenter
        }
      }

      MouseArea {
        anchors.fill: parent
        onClicked: root.pop()
      }
    }

    Repeater {
      model: menuOpener.children.values

      Rectangle {
        id: item

        required property QsMenuEntry modelData

        implicitWidth: 200
        implicitHeight: modelData.isSeparator ? 1 : itemContent.implicitHeight + 4

        radius: height / 2
        color: modelData.isSeparator ? Config.comment : "transparent"

        Row {
          id: itemContent

          anchors.left: parent.left
          anchors.right: parent.right
          anchors.verticalCenter: parent.verticalCenter
          anchors.margins: 6
          spacing: 4

          visible: !item.modelData.isSeparator

          IconImage {
            visible: item.modelData.icon !== ""
            implicitWidth: 16
            implicitHeight: 16
            source: item.modelData.icon
            anchors.verticalCenter: parent.verticalCenter
          }

          Text {
            text: item.modelData.text
            color: item.modelData.enabled ? Config.fg : Config.comment
            elide: Text.ElideRight
            width: 200 - (item.modelData.icon !== "" ? 22 : 0) - (item.modelData.hasChildren ? 20 : 0) - 12
            anchors.verticalCenter: parent.verticalCenter
          }

          Text {
            visible: item.modelData.hasChildren
            text: "›"
            color: item.modelData.enabled ? Config.fg : Config.comment
            anchors.verticalCenter: parent.verticalCenter
          }
        }

        HoverHandler {
          id: hovered
        }

        Rectangle {
          anchors.fill: parent
          radius: parent.radius
          color: Config.fg
          opacity: hovered.hovered ? 0.1 : 0
          Behavior on opacity {
            NumberAnimation {
              duration: 100
            }
          }
        }

        MouseArea {
          anchors.fill: parent
          enabled: item.modelData.enabled && !item.modelData.isSeparator
          onClicked: {
            if (item.modelData.hasChildren)
              root.push(subMenuComp.createObject(null, {
                handle: item.modelData,
                isSubMenu: true
              }));
            else
              item.modelData.triggered();
          }
        }
      }
    }
  }

  Component {
    id: subMenuComp
    SubMenu {}
  }
}
