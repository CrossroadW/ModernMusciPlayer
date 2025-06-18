//MusicRoundImage.qml
import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

Item {
    property string imgSrc: "qrc:/img/record.webp"
    property int borderRadius: 5

    Image {
        id: image
        anchors.centerIn: parent
        source: imgSrc
        smooth: true
        visible: false
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectCrop
        antialiasing: true
    }

    Rectangle {
        id: mask
        color: "black"
        anchors.fill: parent
        radius: borderRadius
        visible: false
        smooth: true
        antialiasing: true
    }

    OpacityMask {
        anchors.fill: image
        source: image
        maskSource: mask
        visible: true
        antialiasing: true
    }
}
