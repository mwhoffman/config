pragma Singleton
import Quickshell
import Quickshell.Services.Mpris
import QtQuick

// MPRIS media players (Spotify, browsers, mpv, ...).
//
// `player` is the one to control:
//   1. the most recently started player, if it is still playing;
//   2. else any player that is playing;
//   3. else the most recently started player (so play resumes it);
//   4. else the first player found.
Singleton {
  id: root

  readonly property var players: Mpris.players.values
  property MprisPlayer lastStarted: null

  readonly property MprisPlayer player: {
    if (lastStarted?.isPlaying) return lastStarted
    return players.find(p => p.isPlaying) ?? lastStarted ?? players[0] ?? null
  }

  // Sends MPRIS PlayPause so the player toggles from its own state.
  // (MprisPlayer.togglePlaying() sends Play or Pause based on the state last
  // reported, which can be stale.)
  function playPause() {
    if (!player?.canTogglePlaying) return
    Quickshell.execDetached(["busctl", "--user", "call", player.dbusName,
      "/org/mpris/MediaPlayer2", "org.mpris.MediaPlayer2.Player", "PlayPause"])
  }

  function next() {
    if (player?.canGoNext) player.next()
  }

  function previous() {
    if (player?.canGoPrevious) player.previous()
  }

  // Remember whichever player most recently started playing.
  Instantiator {
    model: Mpris.players

    Connections {
      required property MprisPlayer modelData
      target: modelData

      function onIsPlayingChanged() {
        if (modelData.isPlaying) root.lastStarted = modelData
      }
    }
  }
}
