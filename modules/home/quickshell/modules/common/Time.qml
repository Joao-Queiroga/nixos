pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root
  readonly property string time: {
    Qt.locale().toString(clock.date, "  ddd dd/MM/yyyy hh:mm");
  }

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }
}
