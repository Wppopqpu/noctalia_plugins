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

	property int currentFrame: 0
	readonly property int totalFrames: 215

	Timer {
		id: animationTimer
		interval: root.isRotating ? Math.max(10, 70 - root.cpuUsage * 0.6) * (root.currentFrame % 2 == 0?3:4) / 7 : 1000
		running: true
		repeat: true
		onTriggered: {
			if (root.isRotating) {
				root.currentFrame = (root.currentFrame + 1) % root.totalFrames
			}
		}
	}

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
			currentFrame: root.currentFrame
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
