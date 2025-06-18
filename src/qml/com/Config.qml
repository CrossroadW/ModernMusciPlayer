import QtQuick

QtObject {
    readonly property real screenWidth: Screen.width //屏幕宽度
    readonly property real screenHeight: Screen.height //屏幕高度
    readonly property string commFont: "微软雅黑 Light" //通用字体
    readonly property color mainBgColor: "#f5f7fa" //界面主背景颜色
    readonly property color leftBgColor: "#f5f7fa" //左侧背景颜色
    readonly property color rightBgColor: "#f5f7fa" //右侧背景颜色
    readonly property color bottomBgColor: "#f5f7fa" //底部背景颜色
    readonly property string hotplaylist: "热门歌单"
    readonly property string searchpage: "搜索"
    Component.onCompleted: {
        console.log(`当前屏幕分辨率是${Screen.width}x${Screen.height}`)
    }
}
