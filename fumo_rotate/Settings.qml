import QtQuick
import QtQuick.Layouts
import qs.Widgets
import qs.Commons

ColumnLayout {
    id: root

    property var pluginApi: null

    spacing: Style.marginM

    NLabel {
        label: pluginApi.tr("panel.title")
    }
}
