// RecentPlayListModel.qml
import QtQuick 2.15
import QtCore
import "com/HttpClient.js" as Http

Item {
    id: recentPlayManager

    // 最多保留多少首歌
    property int maxSongs: 100

    // 内部原始 id 列表（用于本地存储）
    property var songIdList: []

    // 可用于 ListView 展示的模型
    property ListModel displayModel: ListModel {}

    // 本地存储
    Settings {
        id: settings
        category: "RecentPlay"
        property var savedSongIds: []
    }

    // 初始化加载
    Component.onCompleted: {
        songIdList = settings.savedSongIds
                || []
        for (let id of songIdList) {
            fetchAndAppend(id)
        }
    }

    // 添加新播放记录（去重 + 前置）
    function add(songId) {
        if (!songId || songId <= 0)
            return

        let index = songIdList.indexOf(
                songId)
        if (index !== -1) {
            songIdList.splice(index, 1)
            displayModel.remove(index)
        }

        songIdList.unshift(songId)
        if (songIdList.length > maxSongs) {
            songIdList.pop()
            displayModel.remove(
                        displayModel.count - 1)
        }

        settings.savedSongIds = songIdList
        fetchAndPrepend(songId)
    }

    // 获取播放地址 + 图片并插入到模型头部
    function fetchAndPrepend(songId) {
        Http.fetch(`/song/url?id=${songId}`).then(
                    result => {
                        let json = JSON.parse(
                            result)
                        if (json.code !== 200
                            || !json.data
                            || json.data.length === 0)
                        return

                        let song = json.data[0]

                        Http.songDetail(
                            songId,
                            function (imgUrl) {
                                displayModel.insert(0, {
                                                        "songId": songId,
                                                        "name": songId.toString(),
                                                        "url"// 可替换为真实歌名
                                                        : song.url,
                                                        "picUrl": imgUrl,
                                                        "br": song.br,
                                                        "time": song.time,
                                                        "type": song.type,
                                                        "level": song.level,
                                                        "sr": song.sr
                                                    })
                            },
                            function () {
                                console.error("获取封面失败")
                            })
                    }).error(
                    (err, url) => {
                        console.error(
                            `获取播放链接失败: ${url}`,
                            err)
                    })
    }

    // 可选：用于初始化时直接展示旧数据
    function fetchAndAppend(songId) {
        Http.fetch(`/song/url?id=${songId}`).then(
                    result => {
                        let json = JSON.parse(
                            result)
                        if (json.code !== 200
                            || !json.data
                            || json.data.length === 0)
                        return

                        let song = json.data[0]

                        Http.songDetail(
                            songId,
                            function (imgUrl) {
                                displayModel.append({
                                                        "songId": songId,
                                                        "name": songId.toString(),
                                                        "url": song.url,
                                                        "picUrl": imgUrl,
                                                        "br": song.br,
                                                        "time": song.time,
                                                        "type": song.type,
                                                        "level": song.level,
                                                        "sr": song.sr
                                                    })
                            },
                            function () {
                                console.error("获取封面失败")
                            })
                    }).error(
                    (err, url) => {
                        console.error(
                            `获取播放链接失败: ${url}`,
                            err)
                    })
    }
}
