import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQml.Models
import Quickshell.Io

import qs.config as Config

Scope {
    id: root
    property bool centerOpen: false
    property var history: ListModel {
        id: history
    }

    NotificationServer {
        id: server
        actionsSupported: true
        bodySupported: true
        imageSupported: true
        /*ListModel {
            id: history
    }*/

        onNotification: n => {
            history.insert(0, {
                summary: n.summary,
                body: n.body,
                appName: n.appName,
                urgency: n.urgency,
                time: Qt.formatDateTime(new Date(), "HH:mm")
            });
            n.tracked = true;
        }
    }

    IpcHandler {
        target: "notifications"
        function toggle(): void {
            root.centerOpen = !root.centerOpen;
        }
        function show(): void {
            root.centerOpen = true;
        }
        function hide(): void {
            root.centerOpen = false;
        }
    }

    PanelWindow {
        anchors {
            top: true
            right: true
        }
        margins {
            top: 12
            right: 12
        }

        implicitWidth: 380
        implicitHeight: Math.max(1, column.implicitHeight)
        color: "transparent"

        exclusionMode: ExclusionMode.Auto
        visible: !root.centerOpen

        ColumnLayout {
            id: column
            width: parent.width
            spacing: 10

            Repeater {
                model: server.trackedNotifications

                Rectangle {
                    id: card
                    required property var modelData

                    Timer {
                        running: card.modelData.urgency !== NotificationUrgency.Critical
                        interval: Config.Theme.notifTimeout
                        onTriggered: card.modelData.dismiss()
                    }

                    Layout.fillWidth: true
                    Layout.preferredHeight: layout.implicitHeight + 20
                    radius: 8
                    color: Config.Theme.colBg
                    border.width: 2
                    border.color: modelData.urgency === NotificationUrgency.Critical ? Config.Theme.error : Config.Theme.colPurple

                    RowLayout {
                        id: layout
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10
                        Image {
                            Layout.preferredHeight: 36
                            Layout.preferredWidth: 36
                            Layout.alignment: Qt.AlignTop
                            fillMode: Image.PreserveAspectFit
                            visible: source.toString() !== ""
                            source: card.modelData.image || card.modelData.appIcon || ""
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                Layout.fillWidth: true
                                text: card.modelData.summary
                                color: Config.Theme.colCyan
                                font.family: Config.Theme.fontFamily
                                font.pixelSize: Config.Theme.fontSize
                                font.bold: true
                                elide: Text.ElideRight
                            }

                            Text {
                                Layout.fillWidth: true
                                visible: text !== ""
                                text: card.modelData.body
                                color: Config.Theme.colFg
                                font.family: Config.Theme.fontFamily
                                font.pixelSize: Config.Theme.fontSize - 1
                                wrapMode: Text.WordWrap
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: card.modelData.dismiss()
                    }
                }
            }
        }
    }
    PanelWindow {
        visible: root.centerOpen
        color: "transparent"
        anchors {
            top: true
            right: true
        }
        margins {
            top: 12
            right: 12
        }
        implicitWidth: 380
        implicitHeight: Math.min(centerColumn.implicitHeight + 24, 600)
        exclusionMode: ExclusionMode.Auto

        Rectangle {
            anchors.fill: parent
            color: Config.Theme.colBg
            radius: 10
            border.width: 2
            border.color: Config.Theme.colPurple
            ScrollView {
                id: scrollContainer
                anchors.fill: parent
                Layout.fillWidth: true
                ScrollBar.vertical: ScrollBar {
                    interactive: true
                    policy: ScrollBar.AlwaysOff
                }
                clip: true
                leftPadding: 12
                rightPadding: 12
                topPadding: 12
                bottomPadding: 12
                ColumnLayout {
                    id: centerColumn
                    spacing: 10
                    //anchors.fill: parent
                    width: scrollContainer.availableWidth
                    anchors.margins: 12

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        Text {
                            Layout.fillWidth: true
                            text: "Notifications"
                            color: Config.Theme.colCyan
                            font.family: Config.Theme.fontFamily
                            font.pixelSize: Config.Theme.fontSize + 2
                            font.bold: true
                            elide: Text.ElideRight
                        }
                        Text {
                            text: "Clear All"
                            visible: history.count > 0
                            color: Config.Theme.colRed
                            font.family: Config.Theme.fontFamily
                            font.pixelSize: Config.Theme.fontSize - 1
                            MouseArea {
                                anchors.fill: parent
                                //TODO remove urgent notifications from the other part when this is clicked Not sure its doable
                                onClicked: history.clear()
                            }
                        }
                    }
                    Repeater {
                        model: root.history
                        Rectangle {
                            id: centerCard
                            required property var modelData
                            required property var index
                            Layout.fillWidth: true
                            Layout.preferredHeight: centerLayout.implicitHeight + 20
                            radius: 8
                            color: Config.Theme.colBg
                            border.width: 2
                            border.color: modelData.urgency === NotificationUrgency.Critical ? Config.Theme.error : Config.Theme.colPurple
                            //TODO add more text such as time and origin
                            RowLayout {
                                id: centerLayout
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 10

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 2

                                    RowLayout {

                                        Text {
                                            Layout.fillWidth: true
                                            text: centerCard.modelData.summary
                                            color: Config.Theme.colCyan
                                            font.family: Config.Theme.fontFamily
                                            font.pixelSize: Config.Theme.fontSize
                                            font.bold: true
                                            elide: Text.ElideRight
                                        }
                                        Text {
                                            text: centerCard.modelData.time
                                            color: Config.Theme.colMuted
                                            font.family: Config.Theme.fontFamily
                                            font.pixelSize: Config.Theme.fontSize - 3
                                        }
                                        Text {
                                            text: "x"
                                            color: Config.Theme.colMuted
                                            font.family: Config.Theme.fontFamily
                                            font.pixelSize: Config.Theme.fontSize - 1
                                            MouseArea {
                                                onClicked: root.history.remove(centerCard.index)
                                                anchors.fill: parent
                                            }
                                        }
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        visible: text !== ""
                                        text: centerCard.modelData.body
                                        color: Config.Theme.colFg
                                        font.family: Config.Theme.fontFamily
                                        font.pixelSize: Config.Theme.fontSize - 1
                                        wrapMode: Text.WordWrap
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
