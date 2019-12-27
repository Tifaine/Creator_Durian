import QtQuick 2.0
import QtQuick.Controls 2.12

Item {
    id: element
    width: 1500
    height: 800

    Image {
        id: name
        anchors.leftMargin: 50
        anchors.rightMargin: 550
        anchors.bottomMargin: 100
        anchors.topMargin: 100
        anchors.fill: parent

        source: "file:///" + applicationDirPath + "/data/table.png"


        MouseArea
        {
            anchors.fill: parent
            hoverEnabled: true

            onMouseXChanged:
            {
                textX.text = "X : "+ Math.round( (mouseX * 3000 / 900) - 1500 )
            }
            onMouseYChanged:
            {
                textY.text = "Y : "+Math.round( mouseY * 2000 / 600)
            }
            onPressAndHold:
            {
                console.log("hold")
            }
        }

        Etape
        {
            x: 100
            y: 100
        }
    }

    Text {
        id: textX
        width: 80
        color:"white"
        text: qsTr("X : -1500")
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.top: parent.top
        anchors.topMargin: 25
        font.pixelSize: 15
    }

    Text {
        id: textY
        width: 80
        color:"white"
        text: qsTr("Y : 2000")
        anchors.left: textX.right
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 25
        font.pixelSize: 15
    }
}

/*##^##
Designer {
    D{i:3;anchors_x:30;anchors_y:25}D{i:4;anchors_x:111;anchors_y:28}
}
##^##*/
