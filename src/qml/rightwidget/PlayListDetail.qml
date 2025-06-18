import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQml
import "../com/HttpClient.js" as Http

Rectangle {
    id: playlistdetail

    property string name
    property string coverImgId
    property string coverImgUrl
    property string description
    property list<string> tags
    property list<var> tracks

    Component.onCompleted: {
        console.log(`tracks len: ${tracks.length}`)
    }


    /*
      id
      name
      al_picUrl
      dt 时长 ms
      pop 人气

      */
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        // 顶部信息不变
        Label {
            text: name !== "" ? name : "（无歌单名称）"
            font.pixelSize: 20
            font.bold: true
            wrapMode: Text.WordWrap
        }

        Label {
            Layout.maximumHeight: 100

            text: description !== "" ? description : "（无简介）"
            color: "#666"
            wrapMode: Text.WordWrap
            font.pixelSize: 14
            elide: Text.ElideRight
        }

        // 使用 ListView 替代 ScrollView
        GridView {
            id: trackListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            cellHeight: 110
            cellWidth: parent.width / 3
            model: playlistdetail.tracks
            // spacing: 8
            clip: true
            delegate: Rectangle {
                width: trackListView.cellWidth
                height: trackListView.cellHeight
                color: "white"
                radius: 6
                border.color: "#dddddd"
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10

                    // 图片部分
                    Item {
                        Layout.preferredWidth: 80
                        Layout.preferredHeight: 80
                        Image {
                            id: coverImage
                            anchors.fill: parent
                            source: (modelData.al
                                     && modelData.al.picUrl) ? modelData.al.picUrl : ""
                            fillMode: Image.PreserveAspectFit
                            MouseArea {
                                property bool hovered: false
                                onEntered: hovered = true
                                onExited: hovered = false
                                hoverEnabled: true
                                cursorShape: hovered ? Qt.PointingHandCursor : Qt.ArrowCursor
                                layer.enabled: hovered
                                layer.effect: ColorOverlay {
                                    color: "#80ffffff"
                                }
                                anchors.fill: parent
                                onClicked: {
                                    console.log("点击歌单：")

                                    Http.fetch(`/song/url?id=${modelData.id}`).then(result => {
                                                                                        try {
                                                                                            let json = JSON.parse(result)
                                                                                            if (json.code === 200 && json.data && json.data.length > 0) {
                                                                                                let song = json.data[0]
                                                                                                // console.log("soururlpage.name: ",
                                                                                                //             modelData.name)
                                                                                                stackView.push("./SongUrlPage.qml", {
                                                                                                                   "songId": song.id,
                                                                                                                   "url": song.url,
                                                                                                                   "br": song.br,
                                                                                                                   "time": song.time,
                                                                                                                   "type": song.type,
                                                                                                                   "level": song.level,
                                                                                                                   "sr": song.sr,
                                                                                                                   "name": modelData.name,
                                                                                                                   "picurl": modelData.al.picUrl
                                                                                                               })
                                                                                                // console.log("modelData: ",
                                                                                                //             JSON.stringify(modelData))
                                                                                            } else {
                                                                                                console.error("接口返回数据异常")
                                                                                            }
                                                                                        } catch (e) {
                                                                                            console.error("error: ", e)
                                                                                        }
                                                                                    }).error((error, url) => {
                                                                                                 console.error("获取数据失败", error, url)
                                                                                             })
                                }
                            }
                        }

                        Rectangle {
                            anchors.fill: parent
                            color: coverImage.source === "" ? "#eee" : "transparent"
                            visible: coverImage.source === ""
                            Label {
                                anchors.centerIn: parent
                                text: "No Image"
                                color: "#aaa"
                                font.pixelSize: 10
                            }
                        }
                    }

                    // 信息部分
                    ColumnLayout {
                        spacing: 4
                        // width: parent.width - 100
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Label {
                            text: modelData.name !== undefined ? modelData.name : "未知歌曲"
                            font.pixelSize: 16
                            font.bold: true
                            elide: Text.ElideRight
                        }

                        Label {
                            text: "🆔 " + (modelData.id !== undefined ? modelData.id : "未知ID")
                            font.pixelSize: 12
                            color: "#555"
                        }

                        Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                        }

                        Label {
                            text: "⏱ 时长: " + formatDuration(
                                      modelData.dt)
                            font.pixelSize: 12
                            color: "#555"
                        }
                    }
                    Label {
                        Layout.alignment: Qt.AlignBottom | Qt.AlignRight
                        text: "📈 人气: " + (modelData.pop !== undefined ? modelData.pop : "?")
                        font.pixelSize: 12
                        color: "#555"
                    }
                }
            }
        }
    }

    function formatDuration(ms) {
        if (typeof ms !== "number"
                || ms <= 0)
            return "未知时长"
        var totalSec = Math.floor(
                    ms / 1000)
        var min = Math.floor(
                    totalSec / 60)
        var sec = totalSec % 60
        return min + ":" + (sec < 10 ? "0" + sec : sec)
    }
}
