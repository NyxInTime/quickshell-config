import QtQuick

import qs.config as Config

Rectangle {
    anchors.fill: parent
    color: "transparent"
    Text {
        text: "Spotify is not open"
        color: "white"
        font.family: Config.Theme.fontFamily
        font.pixelSize: Config.Theme.fontSize
        anchors.centerIn: parent
    }
}
