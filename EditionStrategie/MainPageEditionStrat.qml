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

        ListModel
        {
            id:listEtape
            ListElement{ _x:100 ; _y:100; _title:"Init"; _indice:0; _type:0 }
        }

        Repeater
        {
            id:repeaterEtape
            model:listEtape

            Etape
            {
                x: _x
                y: _y
                stepName: _title
                onEtapeSelected:
                {
                    pannel.affiche(etape)
                }
            }
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

    Button {
        id: buttonAddEtape
        text: qsTr("Ajouter étape")
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 296
        onClicked:
        {
            listEtape.append({_x:100,_y:100, _title:"Etape",_indice:listEtape.count,_type:1})            
        }
    }

    PanneauEditionStrategie
    {
        id:pannel
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: name.right
        anchors.leftMargin: 0
        anchors.top: name.top
        anchors.topMargin: 0
    }
}
