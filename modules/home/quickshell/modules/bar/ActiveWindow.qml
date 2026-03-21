import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../common/"
import "../common/Functions/"

RowLayout {
  required property ShellScreen monitor
  property Toplevel win: ToplevelManager.toplevels.values.filter(w => w.screens[0] === monitor).find(w => w.activated)
  visible: win != null && win.activated
  IconImage {
    implicitSize: 20
    source: Utils.guessIconPath(parent.win.appId || parent.win.title)
  }
  Text {
    text: parent.win.title
    Layout.maximumWidth: 400
    elide: Text.ElideRight
    color: Config.fg
  }
}
