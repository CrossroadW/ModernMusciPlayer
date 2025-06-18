import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "com"

Drawer {
    id: queueDrawer

    property var playbackQueueModel: ListModel {// ListElement {\
        //     uid : "songid"
        //     name: "name"
        //     audiourl: "audiourl"
        //     duration: "duration"
        //     imgurl: "imgurl"
        // }
    }

    function pushAudio(songId, name, audiourl, duration, imgurl) {
        playbackQueueModel.append({
                                      "uid": songId,
                                      "name": name,
                                      "audiourl": audiourl,
                                      "duration": duration,
                                      "imgurl": imgurl
                                  })
    }

    Rectangle {
        id: content
        anchors.fill: parent
        anchors.topMargin: 20
        anchors.bottomMargin: 20
        anchors.leftMargin: 10
        anchors.rightMargin: 10

        // border.color: "green"
        ListView {
            anchors.fill: parent
            id: playQueue
            model: playbackQueueModel
            delegate: Item {
                width: content.width
                height: 64
                anchors.margins: 10
                Rectangle {
                    anchors.fill: parent
                    radius: 8
                    color: "#ffffff"
                    border.color: "#dddddd"

                    RowLayout {
                        id: row
                        anchors.fill: parent
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.margins: 8
                        spacing: 10

                        RoundImage {
                            id: img
                            source: model.imgurl
                            Layout.preferredWidth: 48
                            Layout.preferredHeight: 48
                        }

                        // 封面图
                        // Image {
                        //     id: img
                        //     source: model.imgurl
                        //     Layout.preferredWidth: 48
                        //     Layout.preferredHeight: 48
                        //     fillMode: Image.PreserveAspectFit
                        //     smooth: true
                        // }

                        // 名称和时长
                        ColumnLayout {
                            Layout.alignment: Qt.AlignRight
                            spacing: 4

                            Label {
                                text: model.name
                                font.pixelSize: 14
                                color: "#2c3e50"
                                Layout.preferredWidth: 50
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }

                            Label {
                                text: model.duration
                                font.pixelSize: 12
                                Layout.preferredWidth: 30
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                                color: "#7f8c8d"
                            }
                        }

                        // 播放按钮（可选）
                        Button {
                            text: "▶"
                            Layout.preferredWidth: 32
                            Layout.preferredHeight: 32
                            onClicked: {
                                // 播放逻辑
                                console.log("点击播放:",
                                            model.name)
                                bottmwidget.playAudio(model.uid, model.audiourl, model.duration, model.imgurl, model.name)
                            }
                        }
                    }
                }
            }
        }
    }
}
