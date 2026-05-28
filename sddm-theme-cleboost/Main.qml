import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15

Rectangle {
    id: container
    width: 1920
    height: 1080
    color: "#1e1e2e"

    Image {
        id: bgImage
        anchors.fill: parent
        source: "assets/background.jpg"
        fillMode: Image.PreserveAspectCrop
        smooth: true
    }

    Rectangle {
        anchors.fill: parent
        color: "#15000000"
    }

    MouseArea {
        anchors.fill: parent
        enabled: powerMenu.visible
        onClicked: {
            powerMenu.visible = false
        }
    }

    Row {
        id: profileRow
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 80
        spacing: 25
        height: 96

        Item {
            width: 96
            height: 96
            anchors.verticalCenter: parent.verticalCenter

            Image {
                id: avatarSource
                anchors.fill: parent
                source: "assets/profile.png"
                fillMode: Image.PreserveAspectCrop
                visible: false
                smooth: true
            }

            Rectangle {
                id: avatarMask
                anchors.fill: parent
                radius: width / 2
                visible: false
            }

            OpacityMask {
                anchors.fill: parent
                source: avatarSource
                maskSource: avatarMask
            }

            Rectangle {
                anchors.fill: parent
                radius: width / 2
                color: "transparent"
                border.color: "#40ffffff"
                border.width: 2
            }
        }

        Text {
            text: "Cleboost"
            font.pixelSize: 36
            font.bold: true
            font.family: "Inter"
            color: "#ffffff"
            anchors.verticalCenter: parent.verticalCenter
            style: Text.Outline
            styleColor: "#40000000"
        }
    }

    Column {
        id: clockContainer
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -120
        spacing: 0

        Text {
            id: clockText
            text: Qt.formatTime(new Date(), "hh:mm")
            font.pixelSize: 240
            font.bold: true
            font.weight: Font.Black
            font.family: "DejaVu Sans"
            color: "#ffffff"
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter

            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: {
                    clockText.text = Qt.formatTime(new Date(), "hh:mm")
                }
            }
        }
    }

    TextField {
        id: passwordInput
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: 0
        anchors.bottomMargin: 80
        width: 320
        height: 60
        placeholderText: ""
        echoMode: TextInput.Password
        focus: true
        font.pixelSize: 46
        font.bold: true
        color: "#ffffff"
        horizontalAlignment: TextInput.AlignHCenter
        verticalAlignment: TextInput.AlignVCenter
        passwordCharacter: "•"

        maximumLength: 12
        validator: RegExpValidator { regExp: /^[0-9]*$/ }

        topPadding: 0
        bottomPadding: 0
        leftPadding: 0
        rightPadding: 0

        cursorDelegate: Item {
            width: 5
            height: passwordInput.height

            Rectangle {
                width: 5
                height: 18
                color: "#ffffff"
                anchors.centerIn: parent
                radius: 1
            }
        }

        background: Rectangle {
            color: "#cc0f111a"
            radius: height / 2
            border.width: 0
        }

        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_Return ||
                event.key === Qt.Key_Enter ||
                event.key === Qt.Key_Backspace ||
                event.key === Qt.Key_Delete ||
                event.key === Qt.Key_Tab ||
                event.key === Qt.Key_Left ||
                event.key === Qt.Key_Right) {
                event.accepted = false;
                return;
            }

            if (event.text.length > 0) {
                if (passwordInput.text.length >= 12) {
                    invalidKeyShake.start()
                    event.accepted = true;
                    return;
                }

                if (!/^[0-9]$/.test(event.text)) {
                    invalidKeyShake.start()
                    event.accepted = true;
                }
            }
        }

        onAccepted: {
            sddm.login(userModel.lastUser, passwordInput.text, sessionModel.currentIndex)
        }
    }

    Rectangle {
        id: powerButton
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 40
        width: 46
        height: 46
        radius: 23
        color: "#cc0f111a"
        border.color: powerMouseArea.containsMouse || powerMenu.visible ? "#ffffff" : "#1affffff"
        border.width: 1.5

        Text {
            anchors.centerIn: parent
            text: "⏻"
            font.pixelSize: 24
            font.bold: true
            color: powerMouseArea.containsMouse || powerMenu.visible ? "#ffffff" : "#ffffff"
        }

        MouseArea {
            id: powerMouseArea
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                powerMenu.visible = !powerMenu.visible
            }
        }
    }

    Rectangle {
        id: powerMenu
        anchors.left: parent.left
        anchors.bottom: powerButton.top
        anchors.leftMargin: 40
        anchors.bottomMargin: 12
        width: 170
        height: 96
        radius: 12
        color: "#eb0f111a"
        border.color: "#1fffffff"
        border.width: 1.5
        visible: false
        clip: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 6
            spacing: 2

            Button {
                id: shutdownBtn
                Layout.fillWidth: true
                Layout.fillHeight: true
                flat: true
                onClicked: sddm.powerOff()

                background: Rectangle {
                    color: shutdownBtn.hovered ? "#1ff38ba8" : "transparent"
                    radius: 8
                }

                contentItem: RowLayout {
                    spacing: 12

                    Item {
                        width: 4
                        height: 1
                    }

                    Text {
                        text: "⏻"
                        font.pixelSize: 15
                        color: shutdownBtn.hovered ? "#f38ba8" : "#cdd6f4"
                    }
                    Text {
                        text: "Éteindre"
                        font.pixelSize: 13
                        font.family: "Inter"
                        font.bold: true
                        color: shutdownBtn.hovered ? "#f38ba8" : "#cdd6f4"
                    }
                }
            }

            Button {
                id: rebootBtn
                Layout.fillWidth: true
                Layout.fillHeight: true
                flat: true
                onClicked: sddm.reboot()

                background: Rectangle {
                    color: rebootBtn.hovered ? "#1f89b4fa" : "transparent"
                    radius: 8
                }

                contentItem: RowLayout {
                    spacing: 12

                    Item {
                        width: 4
                        height: 1
                    }

                    Text {
                        text: "⟲"
                        font.pixelSize: 15
                        color: rebootBtn.hovered ? "#89b4fa" : "#cdd6f4"
                    }
                    Text {
                        text: "Redémarrer"
                        font.pixelSize: 13
                        font.family: "Inter"
                        font.bold: true
                        color: rebootBtn.hovered ? "#89b4fa" : "#cdd6f4"
                    }
                }
            }
        }
    }

    ComboBox {
        id: sessionModel
        visible: false
        model: sessionModel
        currentIndex: sessionModel.lastIndex
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            passwordInput.text = ""
            errorAnim.start()
        }
    }

    SequentialAnimation {
        id: invalidKeyShake
        loops: 1
        PropertyAnimation { target: passwordInput; property: "anchors.horizontalCenterOffset"; to: -10; duration: 40 }
        PropertyAnimation { target: passwordInput; property: "anchors.horizontalCenterOffset"; to: 10; duration: 40 }
        PropertyAnimation { target: passwordInput; property: "anchors.horizontalCenterOffset"; to: -8; duration: 40 }
        PropertyAnimation { target: passwordInput; property: "anchors.horizontalCenterOffset"; to: 8; duration: 40 }
        PropertyAnimation { target: passwordInput; property: "anchors.horizontalCenterOffset"; to: -5; duration: 40 }
        PropertyAnimation { target: passwordInput; property: "anchors.horizontalCenterOffset"; to: 5; duration: 40 }
        PropertyAnimation { target: passwordInput; property: "anchors.horizontalCenterOffset"; to: 0; duration: 40 }
    }

    SequentialAnimation {
        id: errorAnim
        PropertyAnimation { target: passwordInput.background; property: "border.color"; to: "#f38ba8"; duration: 150 }
        PropertyAnimation { target: passwordInput.background; property: "border.color"; to: "#1affffff"; duration: 1000 }
    }
}
