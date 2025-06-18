// NewSongsView.qml
import QtQuick.Layouts
import QtQuick
import QtQuick.Controls
import "../com/HttpClient.js" as Http
import "../com"

Item {
    id: root

    property int columns: 3 // 每行展示歌曲数
    property int rows: 3 // 可设置显示行数
    property int pageSize: columns * rows
    property int currentPage: 0
    property alias allmodel: fullModel
    ListModel {
        id: fullModel
    }

    ListModel {
        id: pagedModel
    }

    function updatePage() {
        pagedModel.clear()
        const start = currentPage * pageSize
        const end = Math.min(
                      fullModel.count,
                      start + pageSize)
        for (var i = start; i < end; ++i)
            pagedModel.append(
                        fullModel.get(
                            i))
    }

    Rectangle {
        anchors.fill: parent
        color: "#f9f9f9"
        radius: 4
        border.color: "#ccc"

        Column {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 10
            Row {
                id: pagerow
                spacing: 10
                anchors.right: parent.right

                Button {
                    icon.source: "qrc:/img/previous.png"
                    rotation: 180
                    width: 30
                    height: 30
                    enabled: currentPage > 0
                    onClicked: {
                        currentPage--
                        updatePage()
                    }
                }

                Button {
                    icon.source: "qrc:/img/previous.png"
                    width: 30
                    height: 30
                    enabled: (currentPage + 1) * pageSize
                             < fullModel.count
                    onClicked: {
                        currentPage++
                        updatePage()
                    }
                }
            }

            Grid {
                id: grid
                columns: root.columns
                spacing: 10
                anchors.horizontalCenter: parent.horizontalCenter

                Repeater {
                    model: pagedModel
                    delegate: RowLayout {
                        width: Math.floor(
                                   root.width / root.columns) - grid.spacing
                        spacing: 5

                        Image {
                            id: defaultimg
                            Layout.preferredHeight: 80
                            Layout.preferredWidth: 80
                            visible: img.status !== Image.Ready
                            source: "qrc:/img/noimg.png"
                        }

                        RoundImage {
                            id: img
                            source: model.cover
                            visible: status === Image.Ready
                            Layout.preferredHeight: 80
                            Layout.preferredWidth: 80
                        }

                        ColumnLayout {

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                            }

                            Text {
                                text: model.name
                                font.pixelSize: 16
                                elide: Text.ElideRight
                            }
                            Item {}
                            Text {
                                text: model.arname
                                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                                font.pixelSize: 13
                                elide: Text.ElideRight
                            }
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                    }
                }
            }
        }
    }
}
