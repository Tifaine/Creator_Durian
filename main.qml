import QtQuick 2.12
import QtQuick.Window 2.12
import QtGraphicalEffects 1.0
import "ElementQML"
import "ControleRoboclaw"
import "EditionStrategie"
import "EditionSequence"
import "ControleDyna"

Item {
    visible: true
    width: 1600
    height: 800

    Rectangle
    {
        id: rectangle
        anchors.fill: parent
        LinearGradient {
            anchors.right: parent.right
            anchors.rightMargin: parent.width/2
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            start: Qt.point(0, 0)
            end: Qt.point(parent.width/2, parent.height)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#0d0d0d" }
                GradientStop { position: 1.0; color: "#262626" }
            }
        }

        LinearGradient {
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: parent.width/2
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            start: Qt.point(parent.width/2, 0)
            end: Qt.point(0, parent.height)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#0d0d0d" }
                GradientStop { position: 1.0; color: "#262626" }
            }
        }


        SelecteurOnglet
        {
            id:choixOngletSide
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            onChangeAffichage:
            {
                switch(nb)
                {
                case 0:
                    mainPageRoboclaw.visible=false
                    mainPageEditionStrat.visible=true
                    editeurEtape.visible=false
                    mainPageCreationAction.visible=false
                    mainPageCreationSequence.visible = false
                    mainPageCreationDyna.visible = false
                    break;
                case 1:
                    mainPageRoboclaw.visible=false
                    mainPageEditionStrat.visible=false
                    editeurEtape.visible=true
                    mainPageCreationAction.visible=false
                    mainPageCreationSequence.visible = false
                    mainPageCreationDyna.visible = false
                    break;
                case 2:
                    mainPageRoboclaw.visible=false
                    mainPageEditionStrat.visible=false
                    editeurEtape.visible=false
                    mainPageCreationAction.visible=false
                    mainPageCreationSequence.visible = true
                    mainPageCreationDyna.visible = false
                    break;
                case 3:
                    mainPageRoboclaw.visible=false
                    mainPageEditionStrat.visible=false
                    editeurEtape.visible=false
                    mainPageCreationAction.visible=true
                    mainPageCreationSequence.visible = false
                    mainPageCreationDyna.visible = false
                    break;
                case 4:
                    mainPageRoboclaw.visible=true
                    mainPageEditionStrat.visible=false
                    editeurEtape.visible=false
                    mainPageCreationAction.visible=false
                    mainPageCreationSequence.visible = false
                    mainPageCreationDyna.visible = false
                    break;
                case 5:
                    mainPageRoboclaw.visible=false
                    mainPageEditionStrat.visible=false
                    editeurEtape.visible=false
                    mainPageCreationAction.visible=false
                    mainPageCreationSequence.visible = false
                    mainPageCreationDyna.visible = true
                    break;
                }
            }

        }

        MainPageRoboclaw {
            id: mainPageRoboclaw
            visible: false
            anchors.left: choixOngletSide.right
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            anchors.leftMargin: 0
        }

        MainPageEditionStrat {
            id: mainPageEditionStrat
            anchors.right: rectangle.right
            anchors.rightMargin: 0
            visible: true
            anchors.left: choixOngletSide.right
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            anchors.leftMargin: 0
        }

        EditeurEtape {
            id: editeurEtape
            anchors.right: rectangle.right
            anchors.rightMargin: 0
            visible: false
            anchors.left: choixOngletSide.right
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            anchors.leftMargin: 0
        }

        PageCreationAction {
            id: mainPageCreationAction
            visible: false
            anchors.left: choixOngletSide.right
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            anchors.leftMargin: 0
        }

        MainPageCreationSequence {
            id: mainPageCreationSequence
            visible: false

            anchors.left: choixOngletSide.right
            anchors.leftMargin: 0

            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
        }

        MainPageCreationDyna {
            id: mainPageCreationDyna
            visible: false

            anchors.left: choixOngletSide.right
            anchors.leftMargin: 0

            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
        }

    }
}
