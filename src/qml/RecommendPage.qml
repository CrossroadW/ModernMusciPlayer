import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "recommonpage"
import "com/HttpClient.js" as Http
import "com"

Item {
    id: recommend
    MusicBannerView {
        id: bannerview
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 200
        Component.onCompleted: {
            Http.fetch("banner").then(
                        result => {
                            try {
                                let banners = JSON.parse(
                                    result).banners
                                let imageUrls = banners.map(
                                    banner => banner.imageUrl)

                                bannerview.bannerList
                                = banners
                            } catch (e) {
                                console.error(
                                    "error: ",
                                    e)
                            }
                        }).error(
                        (err, url) => {
                            console.error(
                                `获取失败: ${err} ${url}`)
                        })
        }
    }

    ScrollView {
        id: scrollview
        anchors.top: bannerview.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        contentWidth: parent.width
        contentHeight: 2000
        Column {
            id: col
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            Label {
                text: "每日推荐歌曲:"
                // font.bold: true
                font.pixelSize: 18
                font.family: "Segoe UI"
            }

            NewSongsView {
                id: songview
                width: parent.width
                height: rows * 120
                Component.onCompleted: {
                    Http.fetch('/recommend/songs').then(
                                result => {
                                    let songs = JSON.parse(result).data.dailySongs
                                    for (let song of songs) {
                                        let name = song.name
                                        let id = song.id
                                        let img = song.al.picUrl
                                        let arname = song.ar[0].name
                                        songview.allmodel.append({
                                                                     "name": name,
                                                                     "cover": img,
                                                                     "arname": arname
                                                                 })
                                    }
                                    songview.updatePage()
                                }).error(
                                (result, err) => {
                                    console.log(
                                        `获取失败: ${result}
                                        ${err}`)
                                })
                }
            }

            Label {
                id: recommtxt
                text: "每日推荐歌单:"
                font.pixelSize: 18
                font.family: "Segoe UI"
            }

            Rectangle {
                anchors.top: recommtxt.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: recommrect.implicitHeight
                color: "#f9f9f9"
                // color: "red"
                radius: 4
                border.color: "#ccc"
                Item {
                    id: recommrect
                    anchors.top: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 15
                    // width: parent.width
                    height: songGrid.implicitHeight
                    GridLayout {
                        id: songGrid
                        columns: 6
                        columnSpacing: 10
                        rowSpacing: 10
                        width: parent.width
                        flow: GridLayout.LeftToRight
                        clip: true
                        Repeater {

                            model: ListModel {
                                id: fullModel
                            }
                            Component.onCompleted: {
                                Http.fetch("/recommend/resource").then(result => {
                                                                           fullModel.clear()
                                                                           const resources = JSON.parse(result).recommend
                                                                           for (const song of resources) {
                                                                               fullModel.append({
                                                                                                    "songid": song.id,
                                                                                                    "name": song.name,
                                                                                                    "cover": song.picUrl || "qrc:/img/noimg.png"
                                                                                                })
                                                                           }
                                                                       }).error((result, url) => {
                                                                                    console.log(`获取失败: ${result}\n${url}`)
                                                                                })
                            }
                            Rectangle {
                                width: (songGrid.width - songGrid.columnSpacing * 5) / 6

                                height: colcontent.implicitHeight
                                radius: 5
                                color: "transparent"
                                ColumnLayout {
                                    id: colcontent
                                    width: parent.width
                                    height: parent.height
                                    spacing: 5

                                    Image {
                                        id: defaultimg
                                        Layout.preferredHeight: parent.width
                                        Layout.preferredWidth: parent.width - colcontent.spacing
                                        Layout.alignment: Qt.AlignHCenter

                                        visible: img.status !== Image.Ready

                                        source: "qrc:/img/noimg.png"
                                    }
                                    RoundImage {
                                        id: img
                                        Layout.preferredHeight: parent.width
                                        Layout.preferredWidth: parent.width - colcontent.spacing
                                        Layout.alignment: Qt.AlignHCenter

                                        visible: status === Image.Ready
                                        source: model.cover
                                    }
                                    Text {
                                        text: model.name
                                        font.pixelSize: 14
                                        wrapMode: Text.WordWrap
                                        elide: Text.ElideRight
                                        maximumLineCount: 1
                                        // Layout.preferredHeight: 70
                                        Layout.preferredWidth: parent.width - colcontent.spacing
                                        verticalAlignment: Text.AlignHCenter
                                        Layout.alignment: Qt.AlignHCenter
                                        width: 150
                                        // height: 70
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
