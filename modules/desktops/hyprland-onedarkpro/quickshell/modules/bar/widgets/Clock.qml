import Quickshell
import QtQuick
import qs

Rectangle {
    readonly property string primaryColor: StylixColors.base07
    readonly property string backgroundColor: StylixColors.base00

    anchors.centerIn: parent

    color: hover.hovered ? primaryColor : backgroundColor

    border {
        width: 2
        color: primaryColor
    }

    property int pad: 10

    implicitWidth: text.implicitWidth + pad * 2
    implicitHeight: parent.height

    Text {
        id: text

        SystemClock {
            id: clock
            precision: SystemClock.seconds
        }

        anchors.centerIn: parent
        text: Qt.formatDateTime(clock.date, "ddd, MMM d, yyyy hh:mm:ss")
        color: hover.hovered ? backgroundColor : primaryColor
        font.weight: 600
        font.pixelSize: 13
    }

    HoverHandler { id: hover }

    Behavior on color {
        ColorAnimation { duration: 100 }
    }

    TapHandler {
        onTapped: {
            console.log('Tapped')
        }
    }
}

