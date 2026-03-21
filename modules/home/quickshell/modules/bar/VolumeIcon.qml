import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire

IconImage {
  id: root
  property PwNode sink: Pipewire.defaultAudioSink
  property real volume: sink.audio.volume
  property bool muted: sink.audio.muted
  implicitSize: 20

  PwObjectTracker {
    objects: [root.sink]
  }

  MouseArea {
    anchors.fill: parent
    onClicked: mouse => {
      root.muted = !root.muted;
    }
  }

  function volumeIcon(volume, muted) {
    if (muted)
      return "audio-volume-muted-symbolic";
    if (volume === 0)
      return "audio-volume-off-symbolic";
    if (volume < 0.33)
      return "audio-volume-low-symbolic";
    if (volume < 0.66)
      return "audio-volume-medium-symbolic";
    if (volume <= 1.0)
      return "audio-volume-high-symbolic";
    return "audio-volume-high-warning-symbolic";
  }

  source: Quickshell.iconPath(volumeIcon(volume, muted), true)
}
