// CustomRoundedImage.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects

Item {
    id: root
    property alias status: image.status
    property alias image: image
    property string source: ""
    property int cornerRadius: 7
    property color borderColor: "#cccccc"
    property int borderWidth: 2
    property bool isRotating: false
    property real rotationAngle: 0.0

    width: 100
    height: 100

    // 背景圆角 + 边框
    Rectangle {
        id: backgroundRect
        anchors.fill: parent
        color: "transparent"
        radius: root.cornerRadius
        border.color: root.borderColor
        border.width: root.borderWidth
    }

    // 遮罩用：黑色圆角区域
    Rectangle {
        id: maskRect
        anchors.fill: backgroundRect
        color: "black"
        radius: root.cornerRadius
        visible: false
        smooth: true
        antialiasing: true
    }

    // 原始图片
    Image {
        id: image
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
        source: root.source
        fillMode: Image.PreserveAspectCrop
        smooth: true
        visible: false
    }

    // 遮罩裁剪效果（真正的圆角图片）
    OpacityMask {
        id: roundedImage
        anchors.fill: image
        source: image
        maskSource: maskRect
        antialiasing: true
    }

    // 可选旋转动画
    NumberAnimation {
        id: rotateAnim
        running: root.isRotating
        loops: Animation.Infinite
        target: roundedImage
        from: root.rotationAngle
        to: 360 + root.rotationAngle
        property: "rotation"
        duration: 100000
        onStopped: {
            root.rotationAngle = roundedImage.rotation
        }
    }
}
