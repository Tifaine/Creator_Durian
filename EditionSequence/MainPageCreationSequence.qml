import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "Components"

import action 1.0

Item {
    id: element
    width: 1500
    height: 800

    PannelAction {
        id: pannelAction
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        onCreerAction:sequenceEnCours.addAction(indiceAction)

    }

    PageBoutons {
        id: pageBoutons
        x: 484
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: pannelAction.right
        anchors.leftMargin: 0
        onAddSequence:listOnglet.append({"_nom":"new"})
        onSave:sequenceEnCours.save(nomFile)
        onOpen:
        {
            listOnglet.set(stackLayout.currentIndex,{ "_nom": nomFile})
            sequenceEnCours.open(nomFile)
        }

    }

    ListModel
    {
        id:listOnglet
        ListElement{ _nom:"Deplacement"}
    }

    TabBar {
        id: bar
        z:0
        height: 40
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: pannelAction.right
        anchors.leftMargin: 10
        anchors.top: pageBoutons.bottom
        anchors.topMargin: 1
        clip:true

        background: Rectangle{
            anchors.fill: parent
            color:"transparent"
        }

        Repeater {
            model: listOnglet

            TabButton {
                text: _nom
                width: bar.width / 8

            }
        }
    }

    property var sequenceEnCours : -1
    StackLayout {
        id:stackLayout
        anchors.leftMargin: 1
        anchors.top: bar.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: pannelAction.right
        anchors.topMargin: 1
        currentIndex: bar.currentIndex
        onCurrentIndexChanged: sequenceEnCours = repeaterOnglet.itemAt(currentIndex)

        Repeater {
            id:repeaterOnglet
            model: listOnglet

            Sequence {
                id: sequence
                Component.onCompleted: sequenceEnCours = sequence

            }
        }
    }
}

/*##^##
Designer {
    D{i:1;anchors_x:315;anchors_y:280}
}
##^##*/
