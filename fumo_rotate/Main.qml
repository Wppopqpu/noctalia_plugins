import QtQuick
import qs.Services.System

Item {
	id: root

	property var pluginApi: null

	readonly property real minimumThreshold: 10

	property real cpuUsage: SystemStatService.cpuUsage
	readonly property bool isRotating: cpuUsage >= minimumThreshold

	property int currentFrame: 0
	readonly property int totalFrame: 215


	Timer {
		id: animationTimer
		interval: (70 - root.cpuUsage * 0.6) * (root.currentFrame % 2 == 0?3:4) / 3
		running: isRotating
		repeat: true
		onTriggered: {
			root.currentFrame = (root.currentFrame + 1) % root.totalFrames
		}
	}

}
