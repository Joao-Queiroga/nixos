//@ pragma UseQApplication

import Quickshell
import Quickshell.Io
import QtQuick
import "./modules/bar/"
import "./modules/applauncher/"

ShellRoot {
  id: root
  LazyLoader {
    active: true
    component: Bar {}
  }
  IpcHandler {
    target: "launcher"
    function toggle() {
      AppLauncher.toggle();
    }
  }
}
