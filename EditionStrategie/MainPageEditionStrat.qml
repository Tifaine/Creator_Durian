import QtQuick 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import "../ElementQML"
import etape 1.0

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

    PageParametrePosition
    {
        id:pageParametrePosition
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: imageTable.right
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
    }

    PageParametreEtape
    {
        id:pageParametreEtape
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: imageTable.right
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

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
