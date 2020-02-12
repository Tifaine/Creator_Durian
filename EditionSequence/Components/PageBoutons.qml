import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import Qt.labs.folderlistmodel 2.12

Item {
    id:element
    width:1350
    height:30
    signal addSequence()
    signal save(string nomFile)
    signal open(string nomFile)

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
        onClicked:
        {
            popup.open()
        }
    }
    Popup {
        id: popup
        x: 550
        y: 350
        width: 200
        height: 100
        modal: true
        focus: true
        background: Rectangle
        {
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
        }
        contentItem:
            Rectangle {
            anchors.fill: parent
            color:"transparent"
            TextField
            {
                id:tfSaveName
                text:"Strat"
                height:40
                anchors.top: parent.top
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.right: parent.right
                anchors.rightMargin: 15
                color: "white"
                background: Rectangle {
                    color:"#22ffffff"
                    radius: 10
                    anchors.fill: parent
                    implicitWidth: 100
                    implicitHeight: 24
                    border.color: "#333"
                    border.width: 1
                }
            }
            Button
            {
                id:validButton
                text:"Enregistrer"
                anchors.top: tfSaveName.bottom
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: parent.width/2 + 5
                anchors.right: parent.right
                anchors.rightMargin: 15
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                onClicked:
                {
                    save(tfSaveName.text)
                    popup.close()
                }
            }
            Button
            {
                id:closeButton
                text:"Annuler"
                anchors.top: tfSaveName.bottom
                anchors.topMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.right: parent.right
                anchors.rightMargin: parent.width/2 + 5
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                onClicked:
                {
                    popup.close()
                }
            }
        }
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
        onClicked:
        {
            popupLoad.open()
        }
    }


    FolderListModel
    {
        id: folderModel
        folder:"file:///"+applicationDirPath+"/data/Sequence/"
        nameFilters: ["*.json"]
        showDirs: false
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

    Popup {
        id: popupLoad
        x: 500
        y: 300
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
                model: folderModel
                currentIndex: 0

                delegate: ItemDelegate {
                    width: controlLoad.width
                    contentItem: Text {
                        text: fileName
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
                        onPressedChanged: canvasLoad.requestPaint()
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
                    text: folderModel.count > 0 ? folderModel.get(controlLoad.currentIndex, "fileName") : ""
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
                    open(folderModel.get(controlLoad.currentIndex, "fileName"))
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
}

/*##^##
Designer {
    D{i:1;anchors_y:0}D{i:2;anchors_y:"-10"}D{i:3;anchors_y:"-5"}D{i:4;anchors_x:133;anchors_y:"-5"}
D{i:5;anchors_width:200;anchors_x:380;anchors_y:126}
}
##^##*/
