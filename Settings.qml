import QtQuick
import QtQuick.Layouts
import qs.Widgets
import qs.Commons

ColumnLayout {
    id: root

    property var pluginApi: null

    spacing: Style.marginM

    Text {
        text: "Fumo Rotate"
        font.bold: true
        font.pointSize: 16
    }

    Text {
        text: "CPU Threshold: 10%"
    }

    Text {
        text: "GIF: assets/fumo.gif"
    }
}
