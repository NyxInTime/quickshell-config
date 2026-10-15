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
    property bool pamActivated: false

    readonly property alias pamResponseRequired: pam.responseRequired
    WlSessionLock {
        id: lock
        locked: Services.Lock.locked
        WlSessionLockSurface {
            color: Config.Theme.colBg
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
                    onAccepted: root.requestUnlock()
                    Connections {
                        target: pam
                        function onPamResponseRequired() {
                            test.text = "giving response";
                            if (pam.responseRequired) {
                                root.respondToPam(passwordInput.text);
                            }
                        }
                    }
                }
            }
            Text {
                id: test
                text: ""
                color: Config.Theme.colFg
                anchors.top: rect.bottom
            }
            PamContext {
                id: pam
                onCompleted: result => {
                    test.text = "Uh we got a completion";
                    if (root.timedOut) {
                        return;
                    }
                    if (result == PamResult.Success) {
                        Services.Lock.lock = false;
                    }
                }
            }

            Timer {
                id: timeoutTimer
                interval: 30000
                repeat: false
                onTriggered: root.cancelPam()
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

    PamContext {
        id: oldpam
        onCompleted: result => {
            test.text = "Uh we got a completion";
            if (root.timedOut) {
                return;
            }
            if (result == PamResult.Success) {
                Services.Lock.lock = false;
            }
        }
    }

    Timer {
        id: timeoutTimer
        interval: 30000
        repeat: false
        onTriggered: root.cancelPam()
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
