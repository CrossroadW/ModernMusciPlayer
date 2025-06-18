import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Popup {
    id: hotSearchPopup

    property list<string> ghostlist

    signal clicked(string text)
    width: 300
    height: col.implicitHeight + col.spacing

    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    background: Item {
        anchors.fill: parent
        Rectangle {
            id: shadowTarget
            anchors.fill: parent
            radius: 10
            color: "#ffffff"
            border.color: "#cccccc"
            border.width: 1
        }

        DropShadow {
            anchors.fill: shadowTarget
            horizontalOffset: 0
            verticalOffset: 2
            radius: 10
            samples: 16
            color: "#44000000"
            source: shadowTarget
        }
    }

    ColumnLayout {
        id: col
        width: parent.width
        spacing: 12

        Text {
            text: "热搜榜"
            font.pixelSize: 14
            font.bold: true
        }

        Repeater {

            model: ghostlist
            delegate: Text {
                text: (index + 1) + ". " + modelData
                color: "#555"
                font.pixelSize: 16
                wrapMode: Text.Wrap
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        hotSearchPopup.clicked(modelData)
                    }
                }
            }
        }
    }
}
