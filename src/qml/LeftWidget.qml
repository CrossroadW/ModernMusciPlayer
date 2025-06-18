import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "com"
import "leftwidget"
import "com/HttpClient.js" as Http

URectangle {
    id: leftWidget

    signal clicked(var sender)

    Rectangle {
        id: avatarGroup
        anchors.horizontalCenter: parent.horizontalCenter
        // width: avatarImg.width + userNameText.width + 60
        width: parent.width

        height: width
        radius: 12
        border.color: "#ccc"

        // 添加背景图层
        Image {
            id: bgImage
            anchors.fill: parent
            width: parent.width
            height: parent.width
            source: "qrc:/img/record.webp"
            fillMode: Image.PreserveAspectCrop
            // opacity: 0.6 // 可选：加一点透明度
        }

        // 内容层
        RowLayout {
            anchors.right: bgImage.right
            anchors.bottom: bgImage.bottom
            anchors.bottomMargin: -20
            anchors.horizontalCenter: bgImage.horizontalCenter
            spacing: 10
            Item {
                Layout.fillWidth: true
            }
            Text {
                id: userNameText
                text: "binaryify"
                font.family: "Segoe UI"
                font.pixelSize: 14
                color: "white"
                Layout.alignment: Qt.AlignVCenter
                                  | Qt.AlignRight
                DropShadow {
                    anchors.fill: userNameText
                    source: userNameText
                    horizontalOffset: 1
                    verticalOffset: 1
                    radius: 4
                    samples: 16
                    color: "#000000cc"
                }
            }
            MyRoundImage {
                id: avatarImg
                width: 60
                height: width
                Layout.preferredWidth: width
                Layout.preferredHeight: width
                Layout.rightMargin: 10
                source: "qrc:/img/record.webp"
            }
        }

        Component.onCompleted: {
            Http.fetch('/user/detail?uid=32953014').then(
                        result => {
                            let profile = JSON.parse(
                                result).profile
                            avatarImg.source
                            = profile.avatarUrl
                            userNameText.text
                            = profile.nickname
                            bgImage.source
                            = profile.backgroundUrl
                        }).error(
                        (err, url) => {
                            console.error(
                                `fetch ${url} err: ${err}`)
                        })
        }
    }

    UButton {
        id: recommon
        txt: "为我推荐"
        width: 210
        height: 50
        radius: 10
        anchors.top: avatarGroup.bottom
        anchors.topMargin: 50
        anchors.left: leftWidget.left
        anchors.margins: 20
        anchors.horizontalCenter: leftWidget.horizontalCenter
        onClicked: {
            stackView.push(
                        'qrc:/src/qml/RecommendPage.qml')
        }
    }

    UButton {
        id: jingxuan
        // /top/playlist/highquality
        txt: "精品歌单"
        width: 210
        height: 50
        radius: 10
        anchors.top: recommon.bottom
        // anchors.top: leftWidget.top
        anchors.left: leftWidget.left
        anchors.margins: 20
        anchors.horizontalCenter: leftWidget.horizontalCenter
        isSelected: true // 默认选中
        onClicked: {
            stackView.push(
                        'qrc:/src/qml/RightWidget.qml')
        }
    }

    UButton {
        id: sousuo

        txt: "搜索"
        width: 210
        height: 50
        radius: 10
        anchors.top: jingxuan.bottom
        anchors.left: leftWidget.left
        anchors.margins: 20
        anchors.horizontalCenter: leftWidget.horizontalCenter
        onClicked: {
            stackView.push(
                        'qrc:/src/qml/rightwidget/SearchDetail.qml')
        }
    }

    UButton {
        id: recentlist
        // /top/playlist/highquality
        txt: "最近播放"
        width: 210
        height: 50
        radius: 10
        anchors.top: sousuo.bottom
        // anchors.top: leftWidget.top
        anchors.left: leftWidget.left
        anchors.margins: 20
        anchors.horizontalCenter: leftWidget.horizontalCenter
        onClicked: {
            stackView.push(
                        'qrc:/src/qml/RecentPlayList.qml',
                        {
                            "displayModel": gPlayListModel.displayModel,
                            "stackView": stackView
                        })
        }
    }
}
