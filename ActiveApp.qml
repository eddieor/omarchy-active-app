import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Ui
import "Model.js" as Model

BarWidget {
  id: root
  moduleName: "eddieor.active-app"

  readonly property var toplevel: ToplevelManager.activeToplevel
  readonly property var appLibrary: bar && bar.shell ? bar.shell.appLibrary : null
  readonly property var desktopEntries: {
    if (appLibrary && typeof appLibrary.sortedEntries === "function")
      return appLibrary.sortedEntries("")
    return DesktopEntries.applications ? DesktopEntries.applications.values : []
  }
  readonly property string label: {
    if (!toplevel) return ""
    return Model.friendlyAppName(toplevel.appId, toplevel.title, desktopEntries)
  }
  readonly property int maxLabelWidth: Number(setting("maxWidth", 220))

  visible: label !== "" && !vertical
  implicitWidth: visible ? Math.min(maxLabelWidth, nameText.implicitWidth) + Style.space(10) : 0
  implicitHeight: barSize

  Behavior on implicitWidth {
    NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
  }

  Text {
    id: nameText
    anchors.verticalCenter: parent.verticalCenter
    anchors.left: parent.left
    anchors.leftMargin: Style.space(2)
    width: Math.min(root.maxLabelWidth, implicitWidth)
    text: root.label
    color: root.bar ? root.bar.barForeground : Color.foreground
    font.family: root.bar ? root.bar.fontFamily : Style.font.family
    font.pixelSize: Style.font.body
    font.weight: Font.DemiBold
    elide: Text.ElideRight
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
    cursorShape: Qt.PointingHandCursor
    onClicked: function(mouse) {
      if (!root.toplevel) return
      if (mouse.button === Qt.LeftButton) root.toplevel.activate()
      else root.toplevel.close()
    }
    onEntered: if (root.bar && root.toplevel) root.bar.showTooltip(root, root.toplevel.title || root.label)
    onExited: if (root.bar) root.bar.hideTooltip(root)
  }
}
