import Http
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "com"
import "com/HttpClient.js" as Http

Rectangle {
    id: rightWidget

    objectName: gConfig.hotplaylist

    property ListModel gplaylists

    gplaylists: ListModel {}

    // property int lastUpdateTime: 0
    GridView {
        id: view
        cellWidth: parent.width / 3
        cellHeight: 110

        function updatePlayListRecursive() {
            if (contentHeight > rightWidget.height)
                return

            updatePlayList()
            Qt.callLater(() => {
                             updatePlayListRecursive()
                         })
        }

        function updatePlayList() {
            // let url = "/top/playlist/highquality?limit=10"
            // if (lastUpdateTime > 0)
            //     url += "&before=" + lastUpdateTime
            let url = "/top/playlist/highquality"
            Http.fetch(url).then(
                        result => {
                            try {
                                let playlists = JSON.parse(
                                    result).playlists

                                for (var i = 0; i < playlists.length; ++i) {
                                    let p = playlists[i]
                                    Qt.callLater(() => {
                                                     gplaylists.append({
                                                                           "id": p.id,
                                                                           "name": p.name,
                                                                           "coverImgUrl": p.coverImgUrl,
                                                                           "description": p.description,
                                                                           "playCount": p.playCount,
                                                                           "creator": p.creator ? p.creator.nickname : ""
                                                                       })
                                                 })
                                }
                            } catch (e) {
                                console.error(
                                    "解析失败: ",
                                    e)
                            }
                        }).error(
                        (error, url) => {
                            console.error(
                                "获取数据失败",
                                error,
                                url)
                        })
        }

        anchors.fill: parent
        model: gplaylists
        Component.onCompleted: {
            updatePlayList()
        }
        onAtYEndChanged: {

        }
        delegate: Item {
            id: row
            height: view.cellHeight
            width: view.cellWidth

            Item {
                anchors.fill: parent
                anchors.margins: 15
                Image {
                    id: defaultimg
                    width: 80
                    height: 80
                    visible: img.status !== Image.Ready
                    source: "qrc:/img/noimg.png"
                }

                RoundImage {
                    id: img
                    visible: status === Image.Ready
                    width: 80
                    height: 80
                    borderRadius: 5
                    source: model.coverImgUrl
                    MouseArea {
                        property bool hovered: false
                        onEntered: hovered = true
                        onExited: hovered = false
                        hoverEnabled: true
                        cursorShape: hovered ? Qt.PointingHandCursor : Qt.ArrowCursor

                        anchors.fill: parent
                        onClicked: {
                            console.log("点击歌单：",
                                        model.name,
                                        "ID:", model.id)

                            Http.fetch(`playlist/detail?id=${model.id}`).then(result => {
                                                                                  try {
                                                                                      let playlist = JSON.parse(result).playlist

                                                                                      let list = stackView.push("qrc:/src/qml/rightwidget/PlayListDetail.qml", {
                                                                                                                    "name": playlist.name,
                                                                                                                    "coverImgId": playlist.coverImgId,
                                                                                                                    "coverImgUrl": playlist.coverImgUrl,
                                                                                                                    "description": playlist.description,
                                                                                                                    "tags": playlist.tags,
                                                                                                                    "tracks": playlist.tracks
                                                                                                                })
                                                                                  } catch (e) {
                                                                                      console.error("error: ", e)
                                                                                  }
                                                                              }).error((error, url) => {
                                                                                           console.error("获取数据失败", error, url)
                                                                                       })
                        }
                    }
                }

                // 歌单详情
                ColumnLayout {
                    spacing: 4
                    anchors.left: img.right
                    anchors.leftMargin: 20
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    Label {
                        text: model.name
                        // font.bold: true
                        font.pixelSize: 14
                        elide: Text.ElideRight
                        wrapMode: Text.WrapAnywhere

                        MouseArea {
                            property bool hovered: false
                            onEntered: hovered = true
                            onExited: hovered = false
                            hoverEnabled: true
                            cursorShape: hovered ? Qt.PointingHandCursor : Qt.ArrowCursor
                            layer.enabled: hovered
                            layer.effect: ColorOverlay {
                                color: "#80ffffff" // 半透明白色覆盖，调节透明度
                            }
                            anchors.fill: parent
                            onClicked: {
                                console.log("点击歌单：",
                                            model.name,
                                            "ID:", model.id)

                                Http.fetch(`playlist/detail?id=${model.id}`).then(result => {
                                                                                      try {
                                                                                          let playlist = JSON.parse(result).playlist

                                                                                          let list = stackView.push("./rightwidget/PlayListDetail.qml", {
                                                                                                                        "name": playlist.name,
                                                                                                                        "coverImgId": playlist.coverImgId,
                                                                                                                        "coverImgUrl": playlist.coverImgUrl,
                                                                                                                        "description": playlist.description,
                                                                                                                        "tags": playlist.tags,
                                                                                                                        "tracks": playlist.tracks
                                                                                                                    })
                                                                                      } catch (e) {
                                                                                          console.error("error: ", e)
                                                                                      }
                                                                                  }).error((error, url) => {
                                                                                               console.error("获取数据失败", error, url)
                                                                                           })
                            }
                        }
                    }

                    Label {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        Layout.maximumWidth: row.width * 3 / 5
                        Layout.maximumHeight: row.height * 2 / 5
                        text: model.description
                              || "无简介"
                        color: "#666"
                        font.pixelSize: 12
                        wrapMode: Text.Wrap
                        maximumLineCount: 2
                        elide: Text.ElideRight
                    }
                }

                Label {
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    text: `播放量:${model.playCount
                          || "未知"}`
                    font.pixelSize: 10
                    color: "#999"
                }
            }
        }
    }
}
