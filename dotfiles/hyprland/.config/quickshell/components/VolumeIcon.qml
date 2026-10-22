pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Shapes

import qs.settings

// Speaker icon whose three sound waves fill in with the volume, like macOS's.
// Each wave fades from the dim to the normal color across its third of the
// range, so in-between volumes show a partly shaded wave. Muted hides the
// waves and crosses the speaker out. Drawn as vectors (on a 24-unit grid, scaled to `size`), so it stays
// sharp and uses the theme's colors.
Item {
  id: root

  property real volume: 0  // 0 to 1
  property bool muted: false
  property real size: Config.bar.volumeIconSize
  property color color: Config.theme.active
  property color dimColor: Config.theme.inactive
  // What the icon sits on, for the gap around the mute line.
  property color background: Config.theme.bg

  // How filled wave `index` (0 to 2) is, from 0 to 1.
  function fill(index: int): real {
    return Math.max(0, Math.min(1, volume * 3 - index))
  }

  function mix(a: color, b: color, t: real): color {
    return Qt.rgba(a.r + (b.r - a.r) * t, a.g + (b.g - a.g) * t, a.b + (b.b - a.b) * t, a.a + (b.a - a.a) * t)
  }

  implicitWidth: size
  implicitHeight: size

  component Slash: ShapePath {
    fillColor: "transparent"
    capStyle: ShapePath.RoundCap
    startX: 3
    startY: 3

    PathLine { x: 21; y: 21 }
  }

  // An arc centered on the speaker's mouth, spanning 40 degrees either side.
  component Wave: ShapePath {
    id: wave

    required property int index
    // Spaced wider than the line width, so the three waves stay distinct.
    readonly property real radius: 3.5 + 3.75 * index
    readonly property real angle: 40 * Math.PI / 180

    strokeWidth: 2
    strokeColor: root.muted ? "transparent" : root.mix(root.dimColor, root.color, root.fill(index))
    fillColor: "transparent"
    capStyle: ShapePath.RoundCap
    startX: 11 + radius * Math.cos(angle)
    startY: 12 - radius * Math.sin(angle)

    PathArc {
      x: 11 + wave.radius * Math.cos(wave.angle)
      y: 12 + wave.radius * Math.sin(wave.angle)
      radiusX: wave.radius
      radiusY: wave.radius
    }
  }

  Shape {
    width: 24
    height: 24
    scale: root.size / 24
    transformOrigin: Item.TopLeft
    preferredRendererType: Shape.CurveRenderer

    // Speaker: a box with a cone opening to the right.
    ShapePath {
      strokeColor: "transparent"
      fillColor: root.muted ? root.dimColor : root.color

      PathSvg { path: "M 0 8 H 5 L 11 3 V 21 L 5 16 H 0 Z" }
    }

    Wave { index: 0 }
    Wave { index: 1 }
    Wave { index: 2 }

    // Muted: a diagonal line over a wider one in the background color, which
    // cuts a gap through the speaker so the line stays visible across it.
    Slash {
      strokeWidth: 5
      strokeColor: root.muted ? root.background : "transparent"
    }
    Slash {
      strokeWidth: 2
      strokeColor: root.muted ? root.color : "transparent"
    }
  }
}
