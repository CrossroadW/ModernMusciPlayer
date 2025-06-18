// PlayerControls.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import "com"

URectangle {
    id: playerBar
    width: parent.width
    radius: 5
    // border.color: "green"
    signal prevClicked
    signal nextClicked

    signal openMusicPage(var current, bool isswitch)
    signal updateCurrentMs(int ms)
    signal pausedChanged(bool ispause)
    property var currentAudio: ({
                                    "songId": 0,
                                    "name": "",
                                    "audioUrl": "",
                                    "duration": 0,
                                    "imgurl": ""
                                })

    function setAudio(songId, audioUrl, duration, imgurl, name) {
        mediaPlayer.source = audioUrl
        progressSlider.to = duration
        img.source = imgurl
        currentAudio = {
            "songId": songId,
            "name": name,
            "audioUrl": audioUrl,
            "duration": duration,
            "imgurl": imgurl
        }
        gPlayListModel.add(songId)
        // console.log("setAudio: ", name, audioUrl, duration, imgurl)
    }
    function playAudio(songId, audioUrl, duration, imgurl, name) {
        mediaPlayer.source = audioUrl
        progressSlider.to = duration
        img.source = imgurl
        currentAudio = {
            "songId": songId,
            "name": name,
            "audioUrl": audioUrl,
            "duration": duration,
            "imgurl": imgurl
        }
        gPlayListModel.add(songId)
        mediaPlayer.play()
        playerBar.openMusicPage(
                    currentAudio, false)
    }

    // 内部状态
    property bool isUserSeeking: false

    MediaPlayer {
        id: mediaPlayer
        audioOutput: audioOut
        onPositionChanged: position => {
                               if (!isUserSeeking)
                               progressSlider.value
                               = position
                               updateCurrentMs(
                                   position)
                           }
        onPlaybackStateChanged: playbackState => {
                                    if (playbackState === MediaPlayer.PlayingState)

                                    playButton.checked = true
                                    else
                                    playButton.checked = false
                                    pausedChanged(
                                        !playButton.checked)
                                }
    }

    AudioOutput {
        id: audioOut
        volume: volumeSlider.value
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 20
        MyRoundImage {
            id: img
            Layout.leftMargin: 5
            Layout.preferredHeight: 70
            Layout.preferredWidth: 70
            source: "qrc:/img/noimg.png"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (currentAudio.songId <= 0) {
                        playerBar.openMusicPage(
                                    undefined,
                                    true)
                        return
                    }

                    playerBar.openMusicPage(
                                currentAudio,
                                true)
                }
            }
        }

        Button {
            text: "⏮"
            onClicked: playerBar.prevClicked()
        }

        Button {
            id: playButton
            checkable: true
            text: checked ? "⏸" : "▶"
            onClicked: {
                if (!currentAudio.audioUrl) {
                    console.error(
                                "no audiourl")
                    return
                }

                if (checked) {
                    mediaPlayer.play()
                    queueDrawer.pushAudio(
                                currentAudio.songId,
                                currentAudio.name,
                                currentAudio.audioUrl,
                                currentAudio.duration,
                                currentAudio.imgurl)
                } else
                    mediaPlayer.pause()
            }
        }

        Button {
            text: "⏭"
            onClicked: playerBar.nextClicked()
        }

        Label {
            text: formatTime(
                      progressSlider.value)
            font.pixelSize: 12
        }

        Slider {
            id: progressSlider
            Layout.fillWidth: true
            from: 0
            to: mediaPlayer.duration
            value: 0

            onMoved: {
                mediaPlayer.position = value
            }
        }

        Label {
            text: formatTime(
                      mediaPlayer.duration)
            font.pixelSize: 12
        }

        Slider {
            id: volumeSlider
            width: 100
            from: 0
            to: 1
            value: 0.8
            onValueChanged: audioOut.volume = value
            Component.onCompleted: {
                audioOut.volume = value
            }
        }
        Button {
            id: queueButton
            text: "📄" // 或使用 "队列"、"List"、"≡"
            Layout.preferredWidth: 50
            font.pixelSize: 16
            onClicked: {
                queueDrawer.visible = !queueDrawer.visible
            }
            ToolTip.text: "播放队列"
            ToolTip.visible: hovered
        }
    }

    function formatTime(ms) {
        let seconds = Math.floor(
                ms / 1000)
        let min = Math.floor(
                seconds / 60)
        let sec = seconds % 60
        return `${min}:${sec < 10 ? "0" + sec : sec}`
    }
}
