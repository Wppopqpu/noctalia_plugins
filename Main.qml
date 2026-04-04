import QtQuick
import qs.Services.System

Item {
    id: root

    property var pluginApi: null

    readonly property real minimumThreshold: 10

    property real cpuUsage: SystemStatService.cpuUsage
    readonly property bool isRotating: cpuUsage >= minimumThreshold
}
