import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ListView {
  required property var displayModel
  required property StackView stackView

  id: listView
  model: displayModel
  clip: true
  spacing: 8

  delegate: Rectangle {
    width: listView.width
    height: 100
    color: "#ffffff"
    radius: 10
    border.color: "#dddddd"
    border.width: 1
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.margins: 8

    RowLayout {
      anchors.fill: parent
      anchors.margins: 10
      spacing: 12

      Image {
        source: model.picUrl // ⚠️ 注意是 picUrl，不是 picurl
        width: 80
        height: 80
        Layout.preferredWidth: 80
        Layout.preferredHeight: 80
        fillMode: Image.PreserveAspectCrop
        smooth: true
      }

      ColumnLayout {
        spacing: 6
        Layout.fillWidth: true

        Text {
          text: model.name || "未知歌曲"
          font.bold: true
          font.pixelSize: 16
          elide: Text.ElideRight
          color: "#333"
        }

        Text {
          text: `音质: ${model.br} kbps   采样率: ${model.sr} Hz`
          font.pixelSize: 13
          color: "#666"
        }

        Text {
          text: `类型: ${model.type}  时长: ${Math.floor(
                  model.time / 1000)} 秒`
          font.pixelSize: 13
          color: "#666"
        }
      }

      Button {
        text: "▶"
        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        onClicked: {
          stackView.push(
                "qrc:/src/qml/rightwidget/SongUrlPage.qml",
                {
                  "songId": Number(
                              model.songId),
                  "url": model.url,
                  "br": model.br,
                  "time": model.time,
                  "type": model.type,
                  "level": model.level,
                  "sr": model.sr,
                  "name": model.name,
                  "picurl": model.picUrl // 注意字段统一
                })
        }
      }
    }

    MouseArea {
      anchors.fill: parent
      hoverEnabled: true
      onClicked: {
        stackView.push(
              "qrc:/src/qml/rightwidget/SongUrlPage.qml",
              {
                "songId": Number(
                            model.songId),
                "url": model.url,
                "br": model.br,
                "time": model.time,
                "type": model.type,
                "level": model.level,
                "sr": model.sr,
                "name": model.name,
                "picurl": model.picUrl
              })
      }
    }
  }
}
