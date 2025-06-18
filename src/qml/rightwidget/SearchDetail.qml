import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../com/HttpClient.js" as Http

// import Http
Rectangle {
    id: root
    objectName: gConfig.searchpage
    color: "#ffffff"

    ListModel {
        id: resultModel
    }
    HotSearchPopup {
        id: hotsearch
        y: input.height
        Component.onCompleted: {
            Http.fetch("search/hot/detail").then(
                        function (result) {
                            console.log("result")
                            let data = JSON.parse(
                                    result).data
                            let words = data.map(
                                    item => item.searchWord)
                            hotsearch.ghostlist = words.slice(0, 10)
                        }).error(
                        function (error) {
                            console.error("请求失败:", error)
                        })
        }
        onClicked: txt => {
                       console.log(
                           "点击了", txt)
                       input.text = txt
                       doSearch()
                   }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        RowLayout {
            spacing: 5
            TextField {
                id: input
                placeholderText: "输入关键词"
                Layout.preferredWidth: root.width
                onAccepted: {
                    doSearch()
                    hotsearch.close()
                }
                onPressed: {
                    console.log("点击或获取焦点了")
                    hotsearch.open()
                }
            }
            Button {
                text: "搜索"
                onClicked: doSearch()
            }
        }

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: resultModel

            delegate: Row {
                height: 120
                spacing: 10
                padding: 5

                Image {
                    id: imageItem
                    source: model.picurl
                    height: 100
                    fillMode: Image.PreserveAspectFit
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (!model.id) {
                                console.log("no id givn")
                                return
                            }
                            Http.fetch(`/song/url?id=${model.id}`).then(result => {
                                                                            try {
                                                                                let json = JSON.parse(result)
                                                                                if (json.code === 200 && json.data && json.data.length > 0) {
                                                                                    let song = json.data[0]
                                                                                    stackView.push("./SongUrlPage.qml", {
                                                                                                       "songId": song.id,
                                                                                                       "url": song.url,
                                                                                                       "br": song.br,
                                                                                                       "time": song.time,
                                                                                                       "type": song.type,
                                                                                                       "level": song.level,
                                                                                                       "sr": song.sr,
                                                                                                       "name": model.name,
                                                                                                       "picurl": model.picurl
                                                                                                   })
                                                                                } else {
                                                                                    console.error("接口返回数据异常")
                                                                                }
                                                                            } catch (e) {
                                                                                console.error("解析错误: ", e)
                                                                            }
                                                                        }).error((error, url) => {
                                                                                     console.error("获取数据失败", error, url)
                                                                                 })
                        }
                    }
                }

                ColumnLayout {
                    height: 100
                    width: listView.width
                    spacing: 4

                    Text {
                        text: `🎵 ${model.name} - ${model.artist}`
                        font.bold: true
                        wrapMode: Text.Wrap
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (!model.id) {
                                    console.log("no id givn")
                                    return
                                }
                                Http.fetch(`/song/url?id=${model.id}`).then(result => {
                                                                                try {
                                                                                    let json = JSON.parse(result)
                                                                                    if (json.code === 200 && json.data && json.data.length > 0) {
                                                                                        let song = json.data[0]
                                                                                        stackView.push("./SongUrlPage.qml", {
                                                                                                           "songId": song.id,
                                                                                                           "url": song.url,
                                                                                                           "br": song.br,
                                                                                                           "time": song.time,
                                                                                                           "type": song.type,
                                                                                                           "level": song.level,
                                                                                                           "sr": song.sr,
                                                                                                           "name": model.name,
                                                                                                           "picurl": model.picurl
                                                                                                       })
                                                                                    } else {
                                                                                        console.error("接口返回数据异常")
                                                                                    }
                                                                                } catch (e) {
                                                                                    console.error("解析错误: ", e)
                                                                                }
                                                                            }).error((error, url) => {
                                                                                         console.error("获取数据失败", error, url)
                                                                                     })
                            }
                        }
                    }
                    Text {
                        text: `📀 专辑：${model.album}`
                        wrapMode: Text.Wrap
                    }
                    Text {
                        text: `⏱ 时长：${Math.floor(
                                  model.duration / 60000)}:${("0" + Math.floor((model.duration % 60000) / 1000)).slice(
                                  -2)}`
                        wrapMode: Text.Wrap
                    }
                    Rectangle {
                        Layout.alignment: Qt.AlignBottom
                        width: parent.width
                        height: 1
                        color: "#ccc"
                    } // 分隔线
                }
            }
        }
    }

    function doSearch() {
        const query = input.text.trim()
        if (!query)
            return

        hotsearch.close()
        Http.fetch(`/search?keywords=${query}`).then(
                    result => {
                        resultModel.clear()
                        try {
                            const json = JSON.parse(
                                result)
                            if (json.result
                                && json.result.songs) {
                                for (let song of json.result.songs) {
                                    Http.songDetail(
                                        song.id, imgurl => {
                                            resultModel.append({
                                                                   "id": song.id,
                                                                   "name": song.name,
                                                                   "artist": song.artists.map(a => a.name).join(", "),
                                                                   "album": song.album.name,
                                                                   "duration": song.duration,
                                                                   "picurl": imgurl
                                                               })
                                        }, function (error, url) {
                                            console.log(`"error: ${error} ${url}"`)
                                            resultModel.append({
                                                                   "id": song.id,
                                                                   "name": song.name,
                                                                   "artist": song.artists.map(a => a.name).join(", "),
                                                                   "album": song.album.name,
                                                                   "duration": song.duration,
                                                                   "picurl": song.album.artist.img1v1Url
                                                               })
                                        })
                                }
                            }
                        } catch (e) {
                            console.error(
                                "JSON 解析失败",
                                e)
                        }
                    }).error(
                    (err, url) => {
                        console.error(
                            "搜索失败",
                            err, url)
                        resultModel.clear()
                    })
    }
}
