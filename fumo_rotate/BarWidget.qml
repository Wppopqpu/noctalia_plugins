import QtQuick
import Quickshell
import qs.Commons
import qs.Modules.Bar.Extras
import qs.Services.UI
import qs.Widgets
import qs.Services.System

Item {
    id: root

    property var pluginApi: null
    property ShellScreen screen
    property string widgetId: ""
    property string section: ""
    property int sectionWidgetIndex: -1
    property int sectionWidgetsCount: 0

    readonly property string screenName: screen?.name ?? ""
    readonly property string barPosition: Settings.getBarPositionForScreen(screenName)
    readonly property bool barIsVertical: barPosition === "left" || barPosition === "right"
    readonly property real capsuleHeight: Style.getCapsuleHeightForScreen(screenName)

    property string tooltipText: {
        if (!pluginApi) return "";
        return root.isRotating ? (pluginApi.tr("tooltip.rotating") || "Rotating") : (pluginApi.tr("tooltip.idle") || "Idle");
    }

    property string tooltipDirection: BarService.getTooltipDirection()
    property bool enabled: true
    property bool allowClickWhenDisabled: false
    property bool hovering: false

    property color colorBg: Color.mSurfaceVariant
    property color colorFg: Color.mPrimary
    property color colorBgHover: Color.mHover
    property color colorFgHover: Color.mOnHover
    property color colorBorder: Color.mOutline
    property color borderHover: Color.mOutline
    property real customRadius: Style.radiusL

    signal entered
    signal exited
    signal clicked
    signal rightClicked
    signal middleClicked
    signal wheel(int angleDelta)

    readonly property real contentWidth: barIsVertical ? capsuleHeight : Math.round(capsuleHeight + Style.marginXS * 2)
    readonly property real contentHeight: capsuleHeight

    implicitWidth: contentWidth
    implicitHeight: contentHeight

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

    function openPanel() {
        if (pluginApi) {
            pluginApi.openPanel(root.screen);
        }
    }

    Rectangle {
        id: visualCapsule
        x: Style.pixelAlignCenter(parent.width, width)
        y: Style.pixelAlignCenter(parent.height, height)
        width: root.contentWidth
        height: root.contentHeight
        opacity: root.enabled ? Style.opacityFull : Style.opacityMedium
        color: mouseArea.containsMouse ? Color.mHover : Style.capsuleColor
        radius: Math.min((customRadius >= 0 ? customRadius : Style.iRadiusL), width / 2)
        border.color: Style.capsuleBorderColor
        border.width: Style.capsuleBorderWidth

        Behavior on color {
            ColorAnimation {
                duration: Style.animationNormal
                easing.type: Easing.InOutQuad
            }
        }

        AnimatedImage {
            id: fumoImage
            x: Style.pixelAlignCenter(parent.width, width)
            y: Style.pixelAlignCenter(parent.height, height)

            width: Style.toOdd(visualCapsule.width - Style.marginXS * 2)
            height: width

            source: Qt.resolvedUrl("assets/fumo.gif")
            sourceSize: Qt.size(width, height)
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: false
            currentFrame: root.currentFrame
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: root.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        hoverEnabled: true
        onEntered: {
            root.hovering = true;
            if (root.tooltipText) {
                TooltipService.show(root, root.tooltipText, root.tooltipDirection);
            }
            root.entered();
        }
        onExited: {
            root.hovering = false;
            if (root.tooltipText) {
                TooltipService.hide();
            }
            root.exited();
        }
        onClicked: function (mouse) {
            if (root.tooltipText) {
                TooltipService.hide();
            }

            if (!root.enabled && !root.allowClickWhenDisabled) {
                return;
            }
            if (mouse.button === Qt.LeftButton) {
                root.openPanel();
                root.clicked();
            } else if (mouse.button === Qt.RightButton) {
                root.openPanel();
                root.rightClicked();
            }
        }
        onWheel: wheel => root.wheel(wheel.angleDelta.y)
    }
}
