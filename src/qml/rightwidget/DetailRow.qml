// DetailRow.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: detailRow
    width: Math.min(contentLayout.implicitWidth + 6, 300)
    implicitHeight: contentLayout.implicitHeight + 10

    // 属性
    property string icon: ""
    property string label: ""
    property string value: ""
    property bool isMultiline: false
    Component.onCompleted: {

        // console.log(`detailRow: ${icon} ${label} ${value}`)
        // console.log("wh wh", width, height, implicitWidth, implicitHeight)
    }
    // Rectangle {
    //     anchors.fill: parent
    //     color: "red"
    // }
    RowLayout {
        id: contentLayout
        anchors.left: parent.left

        anchors.right: parent.right
        spacing: 8

        Label {
            text: icon
            font.pixelSize: 14
            color: "#7f8c8d"
            Layout.alignment: Qt.AlignTop
        }

        Label {
            text: label + ":"
            font.pixelSize: 14
            font.bold: true
            color: "#2c3e50"
            Layout.alignment: Qt.AlignTop
        }

        Label {
            text: value
            font.pixelSize: 14
            color: "#34495e"
            wrapMode: Text.NoWrap
            elide: Text.ElideRight
            Layout.fillWidth: true
            // Rectangle {
            //     anchors.fill: parent
            //     border.color: "red"
            //     color: "transparent"
            // }
        }
    }
}
