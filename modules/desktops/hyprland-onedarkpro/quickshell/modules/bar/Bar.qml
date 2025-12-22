import Quickshell

import qs.modules.bar.widgets

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            aboveWindows: false
            color: "transparent"

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 34

            Clock {}
        }
    }
}
