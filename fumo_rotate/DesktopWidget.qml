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

	showBackground: true

	readonly property bool isRotating: pluginApi?.mainInstance?.isRotating ?? false
	readonly property real cpuUsage: pluginApi?.mainInstance?.cpuUsage ?? 0

	RowLayout {
		anchors.fill: parent
		spacing: 5

		AnimatedImage {
			id: fumoImage
			source: Qt.resolvedUrl("assets/fumo.gif")
			Layout.fillHeight: true
			Layout.preferredWidth: height

			sourceSize.height: height
			sourceSize.width: width

			fillMode: Image.PreserveAspectFit
			smooth: true
			mipmap: false
			speed: 0.03 * root.cpuUsage
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
