import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "com"
import "com/HttpClient.js" as Http

Rectangle {
    id: musicRoot

    y: parent.height

    property string songid
    property string imgurl
    property list<string> lyric
    property list<int> times
    property int currenttime: 0
    property bool isRotating: false
    function onOpen(current) {
        if (current === undefined) {
            console.log("not current")
            return
        }
        imgurl = current.imgurl
        songid = current.songId

        Http.fetch(`/lyric?id=${songid}`).then(
                    result => {
                        let text = JSON.parse(
                            result).lrc.lyric

                        // console.log(
                        //     text)
                        let lines = text.split(
                            "\n")
                        lyric = []
                        times = []

                        for (let line of lines) {
                            // 匹配 [mm:ss.xxx]，例如：[01:03.001]
                            let match = line.match(
                                /\[(\d{2}):(\d{2})\.(\d{2,3})]/)
                            if (match) {
                                let min = parseInt(
                                    match[1])
                                let sec = parseInt(
                                    match[2])
                                let msec = parseInt(
                                    match[3].padEnd(
                                        3, '0')) // 补齐成毫秒

                                let totalMs = min * 60
                                * 1000 + sec * 1000 + msec
                                let content = line.replace(
                                    /\[.*\]/g,
                                    "").trim()

                                times.push(
                                    totalMs)
                                lyric.push(
                                    content.length > 0 ? content : "♪")
                            }
                        }
                    }).error(
                    (err, url) => {
                        console.log(
                            `❌ error: ${err} ${url}`)
                    })
    }

    Behavior on y {
        NumberAnimation {
            duration: 100
        }
    }
    Image {
        id: bgImage
        source: "qrc:/img/record.webp"
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectCrop
        visible: false
        GaussianBlur {
            anchors.fill: parent
            source: bgImage
            radius: 32
            samples: 16 // 越高越精细，性能更高
        }
    }

    // 模糊图（真正显示的是这个）
    gradient: Gradient {
        orientation: Gradient.Vertical
        GradientStop {
            position: 0
            color: "#28333a"
        }
        GradientStop {
            position: 1
            color: "#181c1f"
        }
    }
    // Row {
    //     id: ctlrow
    //     anchors.top: parent.top
    //     anchors.left: parent.left
    //     anchors.topMargin: parent.height / 25
    //     anchors.leftMargin: parent.width / 8

    //     spacing: 20

    //     Rectangle {
    //         width: 50
    //         height: 50
    //         radius: 5
    //         color: "#2d373d"
    //         border.width: 1
    //         border.color: "#3a4449"
    //         Label {
    //             anchors.centerIn: parent
    //             text: "∨"
    //             font.family: "黑体"
    //             font.pixelSize: 24
    //             color: "white"
    //         }
    //         MouseArea {
    //             anchors.fill: parent
    //             onClicked: {
    //                 musicRoot.y = musicRoot.parent.height
    //             }
    //         }
    //     }
    // }
    Item {
        anchors.fill: parent
        RowLayout {
            anchors.fill: parent
            spacing: 0

            Item {
                id: leftPanel
                Layout.preferredWidth: parent.width * 0.5
                Layout.fillHeight: true

                // Layout.alignment: Qt.AlignCenter
                RoundImage {
                    anchors.centerIn: parent
                    width: 350
                    height: 350
                    source: imgurl !== "" ? imgurl : "qrc:/img/noimg.png"
                    borderRadius: width / 2
                    isRotating: musicRoot.isRotating
                }
            }

            Item {
                id: rightPanel
                Layout.preferredWidth: parent.width * 0.5
                Layout.fillHeight: true
                Layout.topMargin: 80
                Layout.bottomMargin: 80
                Layout.leftMargin: 50
                Layout.rightMargin: 50
                ListView {
                    id: lyricView
                    anchors.fill: parent
                    model: lyric.length
                    property int currentLine: (() => {
                                                   for (var i = 0; i < times.length; i++) {
                                                       if (currenttime < times[i]) {
                                                           return Math.max(0, i - 1)
                                                       }
                                                   }
                                                   return lyric.length - 1
                                               })()
                    delegate: Item {
                        width: lyricView.width
                        height: txt.implicitHeight + 20
                        Text {
                            id: txt
                            text: lyric[index]
                            font.pixelSize: 16
                            color: lyricView.currentLine === index ? "#e74c3c" : "white"
                            horizontalAlignment: Text.AlignHCenter
                            width: parent.width
                        }
                    }

                    onCurrentIndexChanged: {
                        // 自动滚动到当前歌词行
                        lyricView.positionViewAtIndex(
                                    currentIndex,
                                    ListView.Center)
                    }

                    // 自动绑定当前行索引

                    // 用 currentLine 自动更新 currentIndex
                    Component.onCompleted: {
                        lyricView.currentIndex = currentLine
                    }

                    onCurrentLineChanged: {
                        lyricView.currentIndex = currentLine
                    }
                }
            }
        }
    }
}
