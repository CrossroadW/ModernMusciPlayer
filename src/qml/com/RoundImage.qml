//MusicBorderImage.qml
import QtQuick 2.12
import QtQuick.Controls 2.5
import Qt5Compat.GraphicalEffects

Rectangle {
    id: root
    required property string source
    property int borderRadius: 5
    property bool isRotating: false
    property real rotationAngel: 0.0
    property alias status: image.status
    property alias img: image
    radius: borderRadius

    gradient: Gradient {
        GradientStop {
            position: 0.0
            color: "#101010"
        }
        GradientStop {
            position: 0.5
            color: "#a0a0a0"
        }
        GradientStop {
            position: 1.0
            color: "#505050"
        }
    }
    Image {
        id: image
        anchors.centerIn: parent
        source: root.source
        smooth: true
        visible: false
        width: parent.width * 0.92
        height: parent.height * 0.92
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
        id: maskImage
        anchors.fill: image
        source: image
        maskSource: mask
        visible: true
        antialiasing: true
    }

    NumberAnimation {
        running: isRotating
        loops: Animation.Infinite
        target: maskImage
        from: rotationAngel
        to: 360 + rotationAngel
        property: "rotation"
        duration: 100000
        onStopped: {
            rotationAngel = maskImage.rotation
        }
    }
}
