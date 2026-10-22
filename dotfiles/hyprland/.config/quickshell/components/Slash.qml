pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Shapes

import qs.settings

// A "disabled" line drawn diagonally across a `size` square centered on its
// parent (the same size everywhere by default, so crossed-out icons match): a line over a wider one in the background color, which cuts a gap
// through what's beneath so the line stays visible across it.
Shape {
  id: root

  property real size: Config.bar.statusIconSize
  property color color: Config.theme.active
  // What the icon sits on, for the gap around the line.
  property color background: Config.theme.bg

  anchors.centerIn: parent
  width: size
  height: size
  preferredRendererType: Shape.CurveRenderer

  // Proportions on a 24-unit square, scaled to `size`.
  component Line: ShapePath {
    fillColor: "transparent"
    capStyle: ShapePath.RoundCap
    startX: root.size * 3 / 24
    startY: root.size * 3 / 24

    PathLine { x: root.size * 21 / 24; y: root.size * 21 / 24 }
  }

  Line {
    strokeWidth: root.size * 5 / 24
    strokeColor: root.background
  }

  Line {
    strokeWidth: root.size * 2 / 24
    strokeColor: root.color
  }
}
