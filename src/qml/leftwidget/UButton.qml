import QtQuick
import QtQuick.Controls

Rectangle {
    id: uButton

    required property string txt

    property bool isSelected: false
    property bool hovered: false

    signal clicked

    color: isSelected ? "#e84f50" : (hovered ? "#f3f3f3" : "#27272d")

    Connections {
        target: leftWidget
        function onClicked(sender) {
            if (sender !== uButton) {
                isSelected = false
            }
        }
    }

    Label {
        id: textLabel
        text: txt
        color: !hovered ? "white" : "black"
        font.pixelSize: 20
        font.family: gConfig.commFont
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        anchors.margins: 10
        hoverEnabled: true
        onEntered: {
            parent.hovered = true
            cursorShape = Qt.PointingHandCursor
        }
        onExited: {
            parent.hovered = false
            cursorShape = Qt.ArrowCursor
        }
        onClicked: {
            if (uButton.isSelected) {
                return
            }
            uButton.isSelected = true
            uButton.clicked()
            leftWidget.clicked(uButton)
        }
    }
}
