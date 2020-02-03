import QtQuick 2.0
import QtQuick.Controls 2.13

Item {
    id:element
    width:1350
    height:30
    signal addSequence()

    Button {
        id: buttonSave
        x: 1193
        width: 200
        text: qsTr("Sauvegarder séquence")
        font.pointSize: 9
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 2
        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.right: parent.right
        anchors.rightMargin: 5
    }

    Button {
        id: buttonLoad
        x: 898
        width: 200
        text: qsTr("Ouvrir séquence")
        font.pointSize: 9
        anchors.right: buttonSave.left
        anchors.rightMargin: 50
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 2
        anchors.top: parent.top
        anchors.topMargin: 2
    }

    Button {
        id: buttonExport
        x: 759
        width: 200
        text: qsTr("Exporter vers le robot")
        font.pointSize: 9
        anchors.right: buttonLoad.left
        anchors.rightMargin: 50
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 2
        anchors.top: parent.top
        anchors.topMargin: 2
    }

    Button {
        id: buttonNew
        width: 200
        text: qsTr("Nouvelle séquence")
        font.pointSize: 9
        anchors.left: parent.left
        anchors.leftMargin: 150
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 2
        anchors.top: parent.top
        anchors.topMargin: 2
        onClicked:
        {
            addSequence()
        }
    }

    Rectangle {
        id: rectangle
        y: 126
        height: 1
        color: "#ffffff"
        border.color: "#ffffff"
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
    }
}

/*##^##
Designer {
    D{i:1;anchors_y:0}D{i:2;anchors_y:"-10"}D{i:3;anchors_y:"-5"}D{i:4;anchors_x:133;anchors_y:"-5"}
D{i:5;anchors_width:200;anchors_x:380;anchors_y:126}
}
##^##*/
