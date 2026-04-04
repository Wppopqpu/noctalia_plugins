import QtQuick
import qs.Services.System

Item {
    id: root

    property var pluginApi: null

    readonly property real minimumThreshold: pluginApi?.pluginSettings?.minimumThreshold || 10
    readonly property string gifPath: pluginApi?.pluginSettings?.gifPath || "assets/fumo.gif"

    property real cpuUsage: SystemStatService.cpuUsage
    readonly property bool isRotating: cpuUsage >= minimumThreshold
}
