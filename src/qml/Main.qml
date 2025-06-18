import QtQuick
import QtQuick.Controls
import "com"
import QtQuick.Layouts

ApplicationWindow {
    id: app

    color: "transparent"
    width: Screen.width * 0.8
    height: Screen.height * 0.8
    visible: true

    RecentPlayListModel {
        id: gPlayListModel
    }

    Config {
        id: gConfig
    }

    URectangle {

        anchors.fill: parent
        color: gConfig.mainBgColor
    }
    LeftWidget {
        id: leftwidget
        border.color: "#ccc"

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 240
    }

    ColumnLayout {
        anchors.left: leftwidget.right
        anchors.top: parent.top
        anchors.bottom: bottmwidget.top
        anchors.right: parent.right
        Button {
            icon.source: "qrc:/img/previous.png"
            rotation: 180
            Layout.preferredWidth: 45
            Layout.preferredHeight: 45
            onClicked: {
                stackView.pop()
            }
        }
        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
            StackView {
                id: stackView
                anchors.fill: parent
                anchors.margins: 15
                clip: true
                // anchors.left: leftwidget.right
                // anchors.top: parent.top
                // anchors.bottom: bottmwidget.top
                // anchors.right: parent.right
                initialItem: RightWidget {
                    id: rightwidget
                    color: gConfig.rightBgColor
                }
            }
        }
    }

    BottomWidget {
        id: bottmwidget

        color: gConfig.bottomBgColor
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 100
        z: 100
    }

    MusicPage {
        id: musicpage
        width: parent.width
        height: parent.height - 100
        y: height
        Connections {
            target: bottmwidget
            function onOpenMusicPage(current, isswitch) {

                if (isswitch === true) {
                    if (musicpage.y !== 0) {
                        musicpage.y = 0
                    } else {
                        musicpage.y = musicpage.height
                    }
                }
                musicpage.onOpen(
                            current)
            }
            function onUpdateCurrentMs(ms) {
                musicpage.currenttime = ms
            }
            function onPausedChanged(isPause) {
                musicpage.isRotating = !isPause
            }
        }
    }

    PlayListQueue {
        id: queueDrawer
        width: 300
        height: parent.height - bottmwidget.height
        bottomMargin: bottmwidget.height
        edge: Qt.RightEdge
        modal: false // 是否点击遮罩关闭
        dragMargin: 0
    }
}
