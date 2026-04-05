import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Services.System
import qs.Widgets

Item {
	id: root
	property var pluginApi: null

	readonly property var geometryPlaceholder: panelContainer
	readonly property bool allowAttach: true
	property real contentPreferredWidth: 300 * Style.uiScaleRatio
	property real contentPreferredHeight: 300 * Style.uiScaleRatio

	anchors.fill: parent

	readonly property bool isRotating: pluginApi?.mainInstance?.isRotating ?? false
	readonly property real cpuUsage: pluginApi?.mainInstance?.cpuUsage ?? 0

	property int currentFrame: 0
	readonly property int totalFrames: 215

	Timer {
		id: animationTimer
		interval: root.isRotating ? Math.max(10, 70 - root.cpuUsage * 0.6) * (root.currentFrame % 2 == 0?3:4) / 3 : 1000
		running: true
		repeat: true
		onTriggered: {
			if (root.isRotating) {
				root.currentFrame = (root.currentFrame + 1) % root.totalFrames
			}
		}
	}

	Rectangle {
		id: panelContainer
		anchors.fill: parent
		color: "transparent"

		Rectangle {
			anchors.fill: parent
			anchors.margins: Style.marginL
			color: Color.mSurface
			radius: Style.radiusL
			border.color: Color.mOutline
			border.width: Style.borderS

			ColumnLayout {
				anchors.centerIn: parent
				spacing: Style.marginL

				Item {
					id: bigFumoItem
					Layout.preferredWidth: 128 * Style.uiScaleRatio
					Layout.preferredHeight: 128 * Style.uiScaleRatio
					Layout.alignment: Qt.AlignHCenter

					AnimatedImage {
						id: bigFumoImage
						anchors.fill: parent
						source: Qt.resolvedUrl("assets/fumo.gif")
						fillMode: Image.PreserveAspectFit
						smooth: true
						mipmap: true
						currentFrame: root.currentFrame
					}
				}

				Text {
					Layout.alignment: Qt.AlignHCenter
					text: "CPU: " + Math.round(root.cpuUsage) + "%"
					font.pointSize: Style.fontSizeXL
					font.weight: Font.Bold
					color: Settings.data.colorSchemes.darkMode ? "white" : "black"
				}
			}
		}
	}
}
