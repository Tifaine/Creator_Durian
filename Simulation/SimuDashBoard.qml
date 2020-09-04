import QtQuick 2.12
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

Item {
    id: element1
    width: 550
    height: 800

    Text {
        id: elementTitre
        color:"white"
        text: qsTr("Simulation ")
        font.bold: true
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10
        font.pixelSize: 15
    }

    Text {
        id: textChoix
        color:"white"
        text: qsTr("")
        anchors.left: buttonChoix.right
        anchors.leftMargin: 15
        anchors.top: elementTitre.bottom
        anchors.topMargin: 23
        font.pixelSize: 12
    }

    Button {
        id: buttonChoix
        text: qsTr("Fichier à simuler")
        anchors.left: parent.left
        anchors.leftMargin: 30
        anchors.top: elementTitre.bottom
        anchors.topMargin: 10
        onClicked:
        {
            modelLoad.clear()
            gestStrat.updateStrat()
            for(var i = 0; i < gestStrat.getNbStrat(); i++)
            {
                modelLoad.append({"text" : gestStrat.getNameStrat(i)})
            }

            popupLoad.open()
        }
    }

    ListModel {
        id: modelLoad
        ListElement { text: "-" }
    }

    Popup {
        id: popupLoad
        x: buttonChoix.x
        y: buttonChoix.y + buttonChoix.height + 50
        width: 200
        height: 100
        modal: true
        focus: true
        background: Rectangle
        {
            anchors.fill: parent
            radius:25
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
        }


        contentItem:
            Rectangle {
            anchors.fill: parent
            color:"transparent"
            ComboBox {
                id: controlLoad
                height:40
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.right: parent.right
                anchors.rightMargin: 15
                model: modelLoad
                currentIndex: 0
                onCurrentIndexChanged:
                {

                }

                delegate: ItemDelegate {
                    width: controlLoad.width
                    contentItem: Text {
                        text: modelData
                        color: "white"
                        font: controlLoad.font
                        elide: Text.ElideRight
                        verticalAlignment: Text.AlignVCenter
                    }
                    highlighted: controlLoad.highlightedIndex === index
                    background: Rectangle {
                        implicitWidth: 120
                        implicitHeight: 40
                        color:controlLoad.highlightedIndex === index ? "#262626" : "transparent"
                    }
                }

                indicator: Canvas {
                    id: canvasLoad
                    x: controlLoad.width - width - controlLoad.rightPadding
                    y: controlLoad.topPadding + (controlLoad.availableHeight - height) / 2
                    width: 12
                    height: 8
                    contextType: "2d"

                    Connections {
                        target: controlLoad
                        function onPressedChanged()
                        {
                            canvasLoad.requestPaint()
                        }
                    }

                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.reset();
                        ctx.moveTo(0, 0);
                        ctx.lineTo(width, 0);
                        ctx.lineTo(width / 2, height);
                        ctx.closePath();
                        ctx.fillStyle = controlLoad.pressed ? "#4d0000" : "#660000";
                        ctx.fill();
                    }
                }

                contentItem: Text {
                    leftPadding: 10
                    rightPadding: controlLoad.indicator.width + controlLoad.spacing

                    text: controlLoad.displayText
                    font: controlLoad.font
                    color: "white"
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                background: Rectangle {
                    implicitWidth: 120
                    implicitHeight: 40
                    color:"#262626"
                    border.color: controlLoad.pressed ? "#4d0000" : "#66000"
                    border.width: controlLoad.visualFocus ? 2 : 1
                    radius: 2
                }

                popup: Popup {
                    y: controlLoad.height - 1
                    width: controlLoad.width
                    implicitHeight: contentItem.implicitHeight
                    padding: 1

                    contentItem: ListView {
                        clip: true
                        implicitHeight: contentHeight
                        model: controlLoad.popup.visible ? controlLoad.delegateModel : null
                        currentIndex: controlLoad.highlightedIndex

                        ScrollIndicator.vertical: ScrollIndicator { }
                    }

                    background: Rectangle {
                        border.color: "#4d0000"
                        color:"#363636"
                        radius: 2
                    }
                }
            }
            Button
            {
                id:validButtonLoad
                text:"Charger"
                anchors.top: controlLoad.bottom
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: parent.width/2 + 5
                anchors.right: parent.right
                anchors.rightMargin: 15
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                onClicked:
                {
                    textChoix.text = controlLoad.currentText
                    gestSimu.openStrat(controlLoad.currentText)
                    popupLoad.close()
                }
            }


            Button
            {
                id:closeButtonLoad
                text:"Annuler"
                anchors.top: controlLoad.bottom
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.right: parent.right
                anchors.rightMargin: parent.width/2 + 5
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                onClicked:
                {
                    popupLoad.close()
                }
            }
        }
    }

    Button {
        id: buttonGo
        x: 442
        text: qsTr("Lancer simulation")
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.right: parent.right
        anchors.rightMargin: 10
        onClicked:
        {
            gestSimu.lancerSimulation()
        }
    }
}

/*##^##
Designer {
    D{i:3;anchors_x:28;anchors_y:36}D{i:31;anchors_y:40}
}
##^##*/
