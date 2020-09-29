import QtQuick 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import QtQuick.Dialogs 1.2
import "../ElementQML"
import etape 1.0
import Qt.labs.folderlistmodel 2.12

Item {
    id: element
    width: 1500
    height: 800
    property bool comefromXTf       : false
    property bool comefromYTf       : false
    property bool isStepShowed      : true
    property bool isPositionShowed  : false

    Image {
        id: imageTable
        anchors.leftMargin: 15
        anchors.rightMargin: 585
        anchors.bottomMargin: 100
        anchors.topMargin: 100
        anchors.fill: parent
        source: fileRoot + applicationDirPath + "/data/table.png"
    }

    Component.onCompleted:
    {
        updateEtape()
    }


    SelecteurOngletVertical
    {
        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.top: parent.top
        anchors.topMargin: 0
        onChangeAffichage:
        {
            switch(nb)
            {
            case 0:
                isStepShowed        = true
                isPositionShowed    = false
                break;
            case 1:
                isStepShowed        = false
                isPositionShowed    = true
                break;
            case 2:
                isStepShowed        = true
                isPositionShowed    = true
                break;
            }

            pageParametreEtape.updateVisibility(isStepShowed)
            pageParametrePosition.updateVisibility(isPositionShowed)
        }
    }   

    PageEditionStrat
    {
        id:pageEditionStrat
        visible:true
        isStepShowed: parent.isStepShowed
        isPositionShowed: parent.isPositionShowed
        isPositionModeOn: pageParametrePosition.isModePositionOn
        anchors.fill: imageTable
        onEtapeSelectedChanged:
        {
            pageParametreEtape.updateParam(pageEditionStrat.etapeSelected)
            pageParametrePosition.updateParam(pageEditionStrat.positionSelected)
            pageParametreEtape.updateVisibility(isStepShowed)
        }
        onPositionSelectedChanged:
        {
            pageParametreEtape.updateParam(pageEditionStrat.etapeSelected)
            pageParametrePosition.updateParam(pageEditionStrat.positionSelected)
            pageParametrePosition.updateVisibility(isPositionShowed)
        }
    }

    Button
    {
        id:buttonExport
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10
        text: "Exporter"
        onClicked:
        {
            gestStrat.exportStrat()
        }
    }

    Button
    {
        id:buttonImport
        anchors.right: buttonExport.left
        anchors.rightMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10
        text: "Importer"
        onClicked:
        {
            popupLoad.open()
        }
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

            FolderListModel
            {
                id: folderModel
                folder:fileRoot+applicationDirPath+"/data/Strategie/"
                nameFilters: ["*.json"]
                showDirs: false
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
                    gestStrat.openStrat(folderModel.get(controlLoad.currentIndex, "fileName"))
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

    PageParametrePosition
    {
        id:pageParametrePosition
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: imageTable.right
        anchors.leftMargin: 0
        anchors.top: buttonExport.bottom
        anchors.topMargin: 10
    }

    PageParametreEtape
    {
        id:pageParametreEtape
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: imageTable.right
        anchors.leftMargin: 0
        anchors.top: buttonExport.bottom
        anchors.topMargin: 10
    }



    ListModel
    {
        id:listRepeaterEtapeGenerique
        ListElement{ _nom:"Canasson" ; index : 0; _color:"#000000ff"; colorEtape: "blue"; _dateMax:50;
            _deadLine : 12; _nbPoints : 45; _sequenceName: "test"; _tempsMax : 10; _tempsMoyen : 20}
    }

    Button
    {
        id:buttonAddPosition
        x: 377
        width: 150
        z:2
        text: "Ajouter position"
        anchors.right: parent.right
        anchors.rightMargin: 585
        visible:isPositionShowed
        font.pointSize: 11
        font.bold: true
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.top: imageTable.bottom
        anchors.topMargin: 10
        onClicked: pageEditionStrat.addPosition(100,100)
    }

    function updateEtape()
    {
        listRepeaterEtapeGenerique.clear();
        for(var i = 0; i < gestEtape.getNbEtape(); i++)
        {
            listRepeaterEtapeGenerique.append({"_nom" : gestEtape.getEtape(i).nomEtape, "index" : listRepeaterEtapeGenerique.count,
                                                  "_color" : "#000000ff", "colorEtape" : gestEtape.getEtape(i).color,
                                                  "_dateMax" : gestEtape.getEtape(i).dateMax, "_deadLine" : gestEtape.getEtape(i).deadline,
                                                  "_nbPoints" : gestEtape.getEtape(i).nbPoints, "_sequenceName": gestEtape.getEtape(i).nameSequence,
                                                  "_tempsMax" : gestEtape.getEtape(i).tempsMax, "_tempsMoyen": gestEtape.getEtape(i).tempsMoyen})
        }
    }

    Flickable
    {
        clip:true
        id: flickable
        height: 100
        flickableDirection: Flickable.HorizontalFlick
        anchors.left: parent.left
        anchors.leftMargin: 15
        anchors.top: imageTable.bottom
        anchors.topMargin: 0
        anchors.right: buttonAddPosition.left
        anchors.rightMargin: 5
        contentWidth: 5000; contentHeight: 100
        contentX: 0
        contentY: 0

        ScrollBar.horizontal: ScrollBar {
            parent: flickable.parent
            anchors.left: flickable.left
            anchors.right: flickable.right
            anchors.bottom: flickable.bottom
        }

        Rectangle
        {
            id:rectangleRepeaterEtapeGenerique
            anchors.fill: parent
            color:"transparent"
            property int behaviorSelected:-1

            function updateColor(indice)
            {

                listRepeaterEtapeGenerique.setProperty(indice,"_color","#300000");
                if(behaviorSelected !== -1 && behaviorSelected !== indice)
                {
                    listRepeaterEtapeGenerique.setProperty(behaviorSelected,"_color","#00ffffff");
                }

                behaviorSelected = indice
            }

            Repeater
            {

                id:repeaterEtapeGenerique
                model:listRepeaterEtapeGenerique
                anchors.fill: parent
                Rectangle
                {
                    visible:isStepShowed
                    id:rect
                    height:40
                    width:90
                    color:_color
                    radius: 10
                    border.color: "#ffffff"
                    border.width: 1
                    anchors.left: repeaterEtapeGenerique.left
                    anchors.leftMargin: (index%2)==1?(index==1?0:(Math.floor(index/2))*100)+5:((index/2)*100)+5
                    anchors.top: repeaterEtapeGenerique.top
                    anchors.topMargin:(index%2)==1?50:5
                    Rectangle
                    {
                        color: _color//"#0cfdfdfd"
                        radius: 10
                        anchors.right: parent.right
                        anchors.rightMargin: 3
                        anchors.left: parent.left
                        anchors.leftMargin: 3
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 3
                        anchors.top: parent.top
                        anchors.topMargin: 3
                        Text {
                            id: nomComportement
                            text: _nom
                            color:"white"
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        }

                        Etape
                        {
                            id:papaStep
                            color:colorEtape
                            nomEtape: _nom
                            dateMax:  _dateMax
                            deadline: _deadLine
                            nbPoints: _nbPoints
                            nameSequence: _sequenceName
                            tempsMax: _tempsMax
                            tempsMoyen: _tempsMoyen
                        }

                        MouseArea
                        {
                            anchors.fill: parent
                            z:1
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked:
                            {
                                rectangleRepeaterEtapeGenerique.updateColor(index)
                                if(mouse.button === Qt.RightButton)
                                {
                                    contextMenu.popup()
                                }
                            }

                            Menu
                            {
                                id: contextMenu
                                MenuItem
                                {
                                    text: "Ajouter étape"
                                    onClicked:
                                    {
                                        //etapeEnCours = -1
                                        pageEditionStrat.addEtape(25,100,
                                                                  papaStep.color,papaStep.nomEtape,papaStep.dateMax,
                                                                  papaStep.deadline, papaStep.nbPoints, papaStep.nameSequence,
                                                                  papaStep.tempsMax, papaStep.tempsMoyen)

                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:9;anchors_width:300;anchors_x:377;anchors_y:706}
}
##^##*/
