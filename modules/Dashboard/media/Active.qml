import Quickshell
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts

import "../"
import qs.config as Config
import qs.services as Services

Rectangle {
    id: root
    property int currentIndex: 0
    anchors.fill: parent
    color: "transparent"
    RowLayout {
        //visible: activeSpotifyPlayer === null ? false : true
        id: mediaText
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            id: title
            text: Services.MediaPlayer.activePlayer.trackTitle
            color: "white"
            font.family: Config.Theme.fontFamily
            font.pixelSize: Config.Theme.fontSize
        }

        MediaButtons {}
    }

    Rectangle {
        //visible: activeSpotifyPlayer === null ? false : true
        id: cover
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50

        implicitWidth: 60
        implicitHeight: 60

        color: Config.Theme.accentPrimary
        radius: Infinity

        Image {
            id: image

            anchors.fill: parent

            source: Services.MediaPlayer.activePlayer.trackArtUrl ?? ""
            asynchronous: true
            fillMode: Image.PreserveAspectCrop
            sourceSize.width: width
            sourceSize.height: height
        }
    }
    Rectangle {
        id: anchorItem
        anchors.top: cover.bottom
        anchors.horizontalCenter: cover.horizontalCenter
        anchors.topMargin: 10
        height: 30
        width: 60
        color: "purple"
        Text {
            anchors.centerIn: parent
            color: "white"
            text: Services.MediaPlayer.activePlayer.identity
        }
        MouseArea {
            preventStealing: true
            anchors.fill: parent
            onClicked: (popup.visible = !popup.visible)
        }

        PopupWindow {
            id: popup
            implicitHeight: 30 * Services.MediaPlayer.players.length
            visible: false
            anchor.item: anchorItem
            color: "purple"
            MouseArea {
                preventStealing: true
                anchors.fill: parent
            }
            PanelWindow {
                exclusionMode: ExclusionMode.Ignore
                focusable: false
                anchors {
                    top: true
                    left: true
                    right: true
                    bottom: true
                }
                visible: popup.visible
                color: "transparent"
                MouseArea {
                    anchors.fill: parent
                    onClicked: popup.visible = false
                }
            }
            ColumnLayout {
                anchors.fill: parent
                //color: "pink"
                Repeater {
                    model: Services.MediaPlayer.players

                    Rectangle {
                        color: "blue"
                        //property var idk : model
                        required property int index

                        //root.currentIndex: thisIndex

                        //currentIndex : thisIndex
                        height: 30
                        width: 70//parent.width
                        MouseArea {
                            anchors.fill: parent
                            onClicked: switchActivePlayer(Services.MediaPlayer.players[index], index)
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: "white"
                            text: /*"hi hello"*/ Services.MediaPlayer.players[index].identity
                        }
                    }
                }
            }

            /*Rectangle {
                color: "pink"
                height: 30
                width: 30
            }*/
        }
    } //rewrite this to make a media source picker like caelestia. after that is done, refactor the entire above to make active spotify player active player from the player found here. This will probably have to change a value in media player.
    function switchActivePlayer(player, index) {
        console.log("this is players " + player + " and index is " + index);
        Services.MediaPlayer.activePlayer = player;
        console.log("This is " + Services.MediaPlayer.activePlayer.identity);
        popup.visible = false;
    }
}
