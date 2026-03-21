import Quickshell
import Quickshell.Hyprland
import QtQuick
import "../common/"

Rectangle {
  color: Config.bg_highlight
  radius: 8
  implicitWidth: 300
  implicitHeight: input.implicitHeight + 12
  border.color: input.activeFocus ? Config.blue : "transparent"

  property alias text: input.text
  property alias fontSize: input.font.pixelSize

  function focusInput() {
    input.forceActiveFocus();
  }

  TextInput {
    id: input
    anchors.fill: parent
    anchors.margins: 6
    color: Config.fg
    font.pixelSize: 14
    focus: true

    Text {
      anchors.fill: input
      text: "Pesquisar..."
      color: Config.comment
      font.pixelSize: parent.font.pixelSize
      visible: input.text.length === 0
    }
  }
}
