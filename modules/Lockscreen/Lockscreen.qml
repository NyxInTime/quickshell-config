pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pam

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
            Text {
                text: "unlock"
                color: Config.Theme.colFg
                MouseArea {
                    anchors.fill: parent
                    onClicked: Services.Lock.locked = false
                }
            }
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
            Text {
                id: test
                text: ""
                color: Config.Theme.colFg
                anchors.top: rect.bottom
            }
            Text {
                id: variables
                text: "timed out " + root.timedOut + " uip " + root.unlockInProgress + " pamactive " + root.pamActivated + " failure " + root.showFailure + " timer " + timeoutTimer.running
                anchors.top: test.bottom
                color: Config.Theme.colFg
                anchors.horizontalCenter: rect.horizontalCenter
            }
            PamContext {
                id: pam
                signal onMessage
                onCompleted: result => {
                    test.text = "Uh we got a completion";
                    if (root.timedOut) {
                        return;
                    }
                    if (result == PamResult.Success) {
                        test.text = "the completion is good";
                        root.unlockInProgress = false;
                        root.pamActivated = false;
                        passwordInput.text = "";
                        Services.Lock.locked = false;
                    } else if (result == PamResult.MaxTries) {
                        test.text = "max tries";
                        //Do smth to make it so that you cannot put any more tries in
                    } else {
                        test.text = "Auth failed";
                        passwordInput.text = "";
                        root.showFailure = true;
                        root.unlockInProgress = false;
                        root.pamActivated = false;
                    }
                }
                onPamMessage: () => {
                    test.text = "got message";
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
                test.text = "trying unlock";
                if (root.unlockInProgress)
                    return;
                root.unlockInProgress = true;
                root.showFailure = false;
                pam.start();
                test.text = "back from pam start";
            }

            function requestUnlock() {
                test.text = "requesting unlock";
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
