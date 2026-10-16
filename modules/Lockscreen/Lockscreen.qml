pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pam
import QtQuick.Controls

import qs.services as Services
import qs.config as Config

Scope {
    id: root
    // VARIABLES
    property bool timedOut: false
    property bool unlockInProgress: false
    property bool showFailure: false
    //TODO get rid of the variable below
    property bool pamActivated: false

    WlSessionLock {
        id: lock
        locked: Services.Lock.locked
        WlSessionLockSurface {
            id: lockSurface
            color: Config.Theme.colBg
            readonly property alias pamResponseRequired: pam.responseRequired
            Rectangle {
                id: rect
                anchors.centerIn: parent
                implicitWidth: 300
                implicitHeight: 40
                color: Config.Theme.colMuted

                TextInput {
                    id: passwordInput
                    anchors.fill: parent
                    text: ""
                    echoMode: TextInput.Password
                    color: "white"
                    font.family: Config.Theme.fontFamily
                    font.pixelSize: Config.Theme.fontSize + 10
                    onAccepted: lockSurface.requestUnlock()
                }
            }
            BusyIndicator {
                id: control
                running: pam.active
                anchors.right: rect.right
                anchors.verticalCenter: rect.verticalCenter

                contentItem: Item {
                    implicitWidth: 40
                    implicitHeight: 40

                    Item {
                        id: item
                        x: parent.width / 2 - 20
                        y: parent.height / 2 - 20
                        width: 40
                        height: 40
                        opacity: control.running ? 1 : 0

                        Behavior on opacity {
                            OpacityAnimator {
                                duration: 250
                            }
                        }

                        RotationAnimator {
                            target: item
                            running: control.visible && control.running
                            from: 0
                            to: 360
                            loops: Animation.Infinite
                            duration: 1250
                        }

                        Repeater {
                            id: repeater
                            model: 6

                            Rectangle {
                                id: delegate
                                x: item.width / 2 - width / 2
                                y: item.height / 2 - height / 2
                                implicitWidth: 10
                                implicitHeight: 10
                                radius: 5
                                color: "white"

                                required property int index

                                transform: [
                                    Translate {
                                        y: -Math.min(item.width, item.height) * 0.5 + 5
                                    },
                                    Rotation {
                                        angle: delegate.index / repeater.count * 360
                                        origin.x: 5
                                        origin.y: 5
                                    }
                                ]
                            }
                        }
                    }
                }
            }
            Text {
                anchors.top: rect.bottom
                anchors.horizontalCenter: rect.horizontalCenter
                color: "white"
                //TODO make the text be an error from pam
            }
            PamContext {
                id: pam
                signal onMessage
                onCompleted: result => {
                    if (root.timedOut) {
                        return;
                    }
                    if (result == PamResult.Success) {
                        root.unlockInProgress = false;
                        root.pamActivated = false;
                        passwordInput.text = "";
                        Services.Lock.locked = false;
                    } else if (result == PamResult.MaxTries) {
                        //Do smth to make it so that you cannot put any more tries in
                    } else {
                        passwordInput.text = "";
                        root.showFailure = true;
                        root.unlockInProgress = false;
                        root.pamActivated = false;
                    }
                }
                onPamMessage: () => {
                    lockSurface.respondToPam(passwordInput.text);
                }
            }
            Timer {
                id: timeoutTimer
                interval: 30000
                repeat: false
                onTriggered: lockSurface.cancelPam()
            }

            function cancelPam() {
                timeoutTimer.stop();
                root.timedOut = true;
                if (pam.active)
                    pam.abort();
                root.pamActivated = false;
                root.unlockInProgress = false;
                root.showFailure = false;
            }

            function tryUnlock() {
                if (root.unlockInProgress)
                    return;
                root.unlockInProgress = true;
                root.showFailure = false;
                pam.start();
            }

            function requestUnlock() {
                if (root.unlockInProgress || root.pamActivated)
                    return;
                root.pamActivated = true;
                root.timedOut = false;
                root.showFailure = false;
                timeoutTimer.restart();
                tryUnlock();
            }

            function respondToPam(response) {
                if (pam.responseRequired) {
                    root.unlockInProgress = true;
                    timeoutTimer.restart();
                    pam.respond(response);
                }
            }
        }
    }
}
