import QtQuick
import QtQuick.Layouts
import qs.Widgets
import qs.Commons

ColumnLayout {
    id: root

    property var pluginApi: null

    property real valueMinimumThreshold: pluginApi?.mainInstance?.minimumThreshold ?? (pluginApi?.pluginSettings?.minimumThreshold || 10)
    property string valueGifPath: pluginApi?.mainInstance?.gifPath ?? (pluginApi?.pluginSettings?.gifPath || "assets/fumo.gif")
    property bool valueHideBackground: pluginApi?.mainInstance?.hideBackground ?? (pluginApi?.pluginSettings?.hideBackground ?? false)

    spacing: Style.marginM

    Component.onCompleted: {
        Logger.i("FumoRotate", "Settings UI loaded");
    }

    NLabel {
        label: pluginApi?.tr("settings.preview.label") || "Preview"
        description: pluginApi?.tr("settings.preview.description") || "Current fumo animation"
    }

    Rectangle {
        id: previewContainer
        Layout.preferredWidth: 150
        Layout.preferredHeight: 150
        Layout.alignment: Qt.AlignHCenter
        color: Color.mSurfaceVariant
        radius: Style.radiusM
        border.color: Color.mOutline
        border.width: Style.borderS

        AnimatedImage {
            id: previewImage
            anchors.centerIn: parent
            width: 120
            height: 120
            source: root.valueGifPath ? Qt.resolvedUrl(root.valueGifPath) : ""
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
            playing: true
            paused: false
        }
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: Style.marginS

        NLabel {
            label: pluginApi?.tr("settings.minimumThreshold.label") || "Minimum CPU Threshold"
            description: pluginApi?.tr("settings.minimumThreshold.description") || "CPU usage must be above this percentage for fumo to rotate"
        }

        NSlider {
            id: thresholdSlider
            from: 5
            to: 50
            value: root.valueMinimumThreshold
            stepSize: 1
            onValueChanged: {
                root.valueMinimumThreshold = value
            }
        }

        Text {
            text: (pluginApi?.tr("settings.currentThreshold") || "Current threshold: {value}%").replace("{value}", thresholdSlider.value)
            color: Color.mOnSurfaceVariant
            font.pointSize: Style.fontSizeS
        }
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: Style.marginS

        NLabel {
            label: pluginApi?.tr("settings.gifPath.label") || "GIF Path"
            description: pluginApi?.tr("settings.gifPath.description") || "Path to the GIF animation file"
        }

        RowLayout {
            spacing: Style.marginS

            NTextField {
                id: gifPathField
                text: root.valueGifPath
                placeholderText: "assets/fumo.gif"
                Layout.fillWidth: true
                onTextChanged: {
                    root.valueGifPath = text
                }
            }

            NButton {
                text: "..."
                Layout.preferredWidth: 40
                onClicked: {
                    console.log("TODO: Open file picker")
                }
            }
        }
    }

    NToggle {
        label: pluginApi?.tr("settings.hideBackground.label") || "Hide Background"
        description: pluginApi?.tr("settings.hideBackground.description") || "Hide the background of the desktop widget"

        checked: root.valueHideBackground
        onToggled: function(checked) {
            root.valueHideBackground = checked
        }
    }

    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Style.marginM

        NButton {
            text: pluginApi?.tr("settings.resetDefaults") || "Reset to Defaults"
            Layout.horizontalStretch: 1
            onClicked: {
                root.valueMinimumThreshold = 10
                root.valueGifPath = "assets/fumo.gif"
                root.valueHideBackground = false
                thresholdSlider.value = 10
                gifPathField.text = "assets/fumo.gif"
            }
        }
    }

    function saveSettings() {
        if (!pluginApi) {
            Logger.e("FumoRotate", "Cannot save settings: pluginApi is null");
            return;
        }

        pluginApi.pluginSettings.minimumThreshold = root.valueMinimumThreshold;
        pluginApi.pluginSettings.gifPath = root.valueGifPath;
        pluginApi.pluginSettings.hideBackground = root.valueHideBackground;

        pluginApi.saveSettings();

        Logger.i("FumoRotate", "Settings saved successfully");
    }
}
