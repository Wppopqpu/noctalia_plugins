import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Modules.DesktopWidgets
import qs.Widgets
import qs.Services.System

DraggableDesktopWidget {
    id: root
    property var pluginApi: null

    implicitWidth: 200
    implicitHeight: 80

    showBackground: !(root.pluginApi?.mainInstance?.hideBackground ?? false)

    readonly property bool isRotating: root.pluginApi?.mainInstance?.isRotating ?? false
    readonly property string gifPath: root.pluginApi?.mainInstance?.gifPath || "assets/fumo.gif"
    readonly property real cpuUsage: root.pluginApi?.mainInstance?.cpuUsage ?? 0

    property url currentGifSource: gifPath ? Qt.resolvedUrl(gifPath) : ""

    RowLayout {
        anchors.fill: parent
        spacing: 5

        AnimatedImage {
            id: fumoImage
            source: root.currentGifSource
            Layout.fillHeight: true
            Layout.preferredWidth: height

            sourceSize.height: height
            sourceSize.width: width

            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: false
            paused: !root.isRotating
        }

        Text {
            text: Math.round(root.cpuUsage) + "%"
            color: Settings.data.colorSchemes.darkMode ? "white" : "black"
            font.bold: true
            font.pixelSize: 40
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
