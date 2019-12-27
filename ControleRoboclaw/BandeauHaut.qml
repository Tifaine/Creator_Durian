import QtQuick 2.0
import QtQuick.Controls 2.13

Item {
    id: element1
    height:150
    width:1500

    Connections
    {
        target: gestRoboclaw
        onInitDone:
        {
            textValueCodeurG.text = "0"
            textValueCodeurD.text = "0"
            textValueVG.text = "0"
            textValueVD.text = "0"
        }
        onCodeurGaucheChanged:
        {
            textValueCodeurG.text = value
        }
        onCodeurDroitChanged:
        {
            textValueCodeurD.text = value
        }
        onVitesseGaucheChanged:
        {
            textValueVG.text = value
        }
        onVitesseDroitChanged:
        {
            textValueVD.text = value
        }
    }

    Text {
        id: textCodeurG
        color: "#ffffff"
        text: qsTr("Codeur gauche : ")
        anchors.left: parent.left
        anchors.leftMargin: 50
        anchors.top: parent.top
        anchors.topMargin: 65
        font.bold: true
        font.pixelSize: 13
    }

    Text {
        id: textValueCodeurG
        color: "#ffffff"
        text: qsTr("999999999")
        anchors.left: parent.left
        anchors.leftMargin: 165
        anchors.top: parent.top
        anchors.topMargin: 65
        font.pixelSize: 13
    }

    Text {
        id: vitesseG
        x: -9
        y: -9
        color: "#ffffff"
        text: qsTr("Vitesse gauche : ")
        font.pixelSize: 13
        anchors.leftMargin: 50
        anchors.topMargin: 5
        font.bold: true
        anchors.top: textCodeurG.bottom
        anchors.left: parent.left
    }

    Text {
        id: textValueVG
        x: -9
        y: -9
        color: "#ffffff"
        text: qsTr("999999999")
        font.pixelSize: 13
        anchors.leftMargin: 165
        anchors.topMargin: 5
        anchors.top: textValueCodeurG.bottom
        anchors.left: parent.left
    }

    Text {
        id: textCodeurD
        x: -8
        y: -8
        color: "#ffffff"
        text: qsTr("Codeur droit : ")
        font.pixelSize: 13
        anchors.leftMargin: 250
        anchors.topMargin: 65
        font.bold: true
        anchors.top: parent.top
        anchors.left: parent.left
    }

    Text {
        id: textValueCodeurD
        x: -8
        y: -8
        color: "#ffffff"
        text: qsTr("999999999")
        font.pixelSize: 13
        anchors.leftMargin: 365
        anchors.topMargin: 65
        anchors.top: parent.top
        anchors.left: parent.left
    }

    Text {
        id: vitesseD
        x: -17
        y: -17
        color: "#ffffff"
        text: qsTr("Vitesse droit : ")
        anchors.leftMargin: 250
        font.pixelSize: 13
        anchors.topMargin: 5
        font.bold: true
        anchors.top: textCodeurG.bottom
        anchors.left: parent.left
    }

    Text {
        id: textValueVD
        x: -17
        y: -17
        color: "#ffffff"
        text: qsTr("999999999")
        anchors.leftMargin: 365
        font.pixelSize: 13
        anchors.topMargin: 5
        anchors.top: textValueCodeurG.bottom
        anchors.left: parent.left
    }

    Button {
        id: buttonConnect
        x: 1345
        text: qsTr("Connexion robot")
        anchors.right: parent.right
        anchors.rightMargin: 55
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 55
        anchors.top: parent.top
        anchors.topMargin: 55
        onClicked:
        {
            if(gestRoboclaw.connectToRobot() === 0 )
            {
                rectangle.color = "#00ff00"
            }else
            {
                rectangle.color = "#ff0000"
            }
        }
    }

    Rectangle {
        id: rectangle
        width: 15
        color: "#ff0000"
        radius: 8
        anchors.left: buttonConnect.right
        anchors.leftMargin: 6
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 67
        anchors.top: parent.top
        anchors.topMargin: 68

    }
}

/*##^##
Designer {
    D{i:1;anchors_x:211;anchors_y:8}D{i:2;anchors_x:346;anchors_y:9}D{i:3;anchors_x:211;anchors_y:8}
D{i:4;anchors_x:346;anchors_y:9}D{i:5;anchors_x:211;anchors_y:8}D{i:6;anchors_x:346;anchors_y:9}
D{i:7;anchors_x:211;anchors_y:8}D{i:8;anchors_x:346;anchors_y:9}D{i:9;anchors_y:54}
D{i:10;anchors_height:10;anchors_width:10;anchors_x:1371;anchors_y:181}
}
##^##*/
