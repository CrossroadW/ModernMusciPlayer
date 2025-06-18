import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Rectangle {
    id: songUrlPage
    color: "#f5f7fa"
    radius: 12
    border.color: "#d0d0d0"
    border.width: 1

    // 属性
    property int songId: -1
    property string url: ""
    property int br: 0
    property int time: 0
    property string type: ""
    property string level: ""
    property int sr: 0
    property string name: ""
    property string picurl: ""
    Component.onCompleted: {
        // console.log("setAudio:", name)
        bottmwidget.setAudio(songId,
                             url, time,
                             picurl,
                             name)
        // console.log(`songUrlPage: ${songId} ${url} ${size} ${br} ${type} ${level} ${sr}`)
    }

    DropShadow {
        anchors.fill: songUrlPage
        horizontalOffset: 0
        verticalOffset: 2
        radius: 8
        samples: 17
        color: "#f9eded"
        source: songUrlPage
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 14

        Label {
            text: "🎵 歌曲详情"
            font.pixelSize: 20
            font.bold: true
            color: "#2c3e50"
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
        }
        Image {
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: 200
            Layout.preferredHeight: 200
            Layout.maximumWidth: 300
            Layout.maximumHeight: 300
            fillMode: Image.PreserveAspectFit
            source: picurl
        }

        Rectangle {
            color: "white"
            radius: 8
            border.color: "#dcdcdc"
            Layout.fillWidth: true
            Layout.preferredHeight: content.implicitHeight
                                    + 20
            anchors.margins: 4

            ColumnLayout {
                id: content
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10

                DetailRow {
                    icon: "🎼"
                    label: "音乐 ID"
                    value: String(
                               songId >= 0 ? songId : "未知")
                }
                DetailRow {
                    icon: "🔗"
                    label: "播放地址"
                    value: url !== "" ? url : "暂无音频链接"
                    isMultiline: true
                }
                DetailRow {
                    icon: "🎧"
                    label: "码率"
                    value: String(
                               br > 0 ? br / 1000 + " kbps" : "未知")
                }
                DetailRow {
                    icon: "📦"
                    label: "时长"
                    value: time > 0 ? formatSize(
                                          time) : "未知"
                }
                DetailRow {
                    icon: "🧪"
                    label: "编码类型"
                    value: type !== "" ? type : "未知"
                }
                DetailRow {
                    icon: "📶"
                    label: "音质等级"
                    value: level !== "" ? level : "未知"
                }
                DetailRow {
                    icon: "🔊"
                    label: "采样率"
                    value: String(
                               sr > 0 ? sr + " Hz" : "未知")
                }
            }
        }
    }

    // 格式化字节
    function formatSize(bytes) {
        if (bytes >= 1024 * 1024)
            return (bytes / (1024 * 1024)).toFixed(
                        2) + " MB"
        else if (bytes >= 1024)
            return (bytes / 1024).toFixed(
                        2) + " KB"
        else
            return bytes + " B"
    }

    // 子组件：详情行
    Component {
        id: detailRowComponent
        DetailRow {}
    }

    // 可复用详情行组件
    Item {
        id: detailRowBase
        property alias icon: iconLabel.text
        property alias label: labelText.text
        property alias value: valueText.text
        property bool isMultiline: false

        implicitHeight: isMultiline ? valueText.paintedHeight + 24 : 20
        implicitWidth: parent ? parent.width : 300

        RowLayout {
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 8

            Label {
                id: iconLabel
                font.pixelSize: 14
                color: "#7f8c8d"
            }

            Label {
                id: labelText
                font.pixelSize: 14
                font.bold: true
                color: "#2c3e50"
            }

            Label {
                id: valueText
                Layout.fillWidth: true
                font.pixelSize: 14
                wrapMode: detailRowBase.isMultiline ? Text.WrapAnywhere : Text.NoWrap
                elide: detailRowBase.isMultiline ? Text.ElideNone : Text.ElideRight
                color: "#34495e"
            }
        }
    }
}
