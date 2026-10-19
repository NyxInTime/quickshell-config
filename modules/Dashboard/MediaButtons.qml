import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris

import qs.config as Config
import qs.services as Services

//TODO make it work with the current player and not activeSpotifyPlayer
RowLayout {

    Text {
        id: back
        text: "󰒮"
        color: "white"
        font.family: Config.Theme.fontFamily
        font.pixelSize: Config.Theme.fontSize
        MouseArea {
            anchors.fill: parent
            onClicked: Services.MediaPlayer.activePlayer.previous()
        }
    }
    Text {
        id: pausePlay
        text: Services.MediaPlayer.activePlayer.isPlaying ? "󰏤" : "󰐊"
        color: "white"
        font.family: Config.Theme.fontFamily
        font.pixelSize: Config.Theme.fontSize
        MouseArea {
            anchors.fill: parent
            onClicked: Services.MediaPlayer.activePlayer.isPlaying === true ? Services.MediaPlayer.activePlayer.pause() : Services.MediaPlayer.activePlayer.play()
        }
    }
    Text {
        id: next
        text: "󰒭"
        color: "white"
        font.family: Config.Theme.fontFamily
        font.pixelSize: Config.Theme.fontSize
        MouseArea {
            anchors.fill: parent
            onClicked: Services.MediaPlayer.activePlayer.next()
        }
    }
    function nothing() {
    }
}
