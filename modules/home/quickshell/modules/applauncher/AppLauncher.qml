pragma ComponentBehavior: Bound
pragma Singleton
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import "../common/"
import "../services/"

Singleton {
  id: root

  property bool visible: false

  function open() {
    root.visible = true;
  }
  function close() {
    root.visible = false;
  }
  function toggle() {
    root.visible = !root.visible;
  }

  LazyLoader {
    active: root.visible

    PanelWindow {
      id: lwindow
      color: "transparent"
      implicitWidth: 500
      implicitHeight: 500
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
      Keys.onEscapePressed: root.close()

      property list<DesktopEntry> results: AppSearch.search("")

      Rectangle {
        color: Config.bg
        anchors.fill: parent
        radius: 8
        border.color: Config.bg_highlight
        Item {
          anchors.fill: parent
          anchors.margins: 4

          EntryField {
            id: entryField
            anchors {
              top: parent.top
              left: parent.left
              right: parent.right
              margins: 8
            }
            fontSize: 24
            Keys.onEscapePressed: root.close()
            Keys.onTabPressed: listView.forceActiveFocus()
            onTextChanged: lwindow.results = AppSearch.search(text)
          }

          ListView {
            id: listView
            model: lwindow.results
            anchors {
              topMargin: 15
              top: entryField.bottom
              left: parent.left
              right: parent.right
              bottom: parent.bottom
            }
            clip: true
            Keys.onEscapePressed: root.close()
            keyNavigationEnabled: true
            focus: true
            Keys.onPressed: event => {
              if (event.text && event.text.length > 0) {
                entryField.focusInput();
                entryField.text += event.text;
              }
            }

            Keys.onTabPressed: {
              if (currentIndex < count - 1)
                currentIndex++;
              else
                currentIndex = 0;
            }
            Keys.onBacktabPressed: {
              if (currentIndex > 0)
                currentIndex--;
              else
                entryField.focusInput();
            }

            delegate: AppCard {
              required property DesktopEntry modelData
              entry: modelData
              onLaunched: entry => {
                AppSearch.recordUsage(entry.id);
                root.close();
              }
            }
          }
        }
      }
    }
  }
}
