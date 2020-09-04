import QtQuick 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import etape 1.0

Item {
    id: element
    width: 1500
    height: 800
    property bool comefromXTf : false
    property bool comefromYTf : false
    property var etapeEnCours : -1


    Component.onCompleted:
    {
        listEtapeSimu.clear()
        gestSimu.clearAll()
    }




    Connections
    {
        target:gestSimu
        function onClearListEtape()
        {
            listEtapeSimu.clear()
            gestSimu.clearAll()
        }

        function onNouvelleEtape()
        {
            listEtapeSimu.append({"_x" : x, "_y" : y, index : listEtapeSimu.count, "_color" : color, "_nom" : nom,
                                     "_dateMax" : dateMax, "_deadLine" : deadLine,
                                     "_nbPoints" : nbPoints,"_sequenceName" : nameSequence,
                                     "_tempsMax" : tempsMax, "_tempsMoyen" : tempsMoyen})
        }
        function onNouveauTaux()
        {
            repeater.itemAt(indice).addTaux(param, cond, value, ratio)
        }
        function onUpdatePosRobot()
        {
            robot.x = ( x + 1500 ) * ( name.width / 3000) - robot.width / 2
            robot.y = ( y * ( name.height / 2000 ) ) - robot.height / 2
        }
    }

    ListModel
    {
        id:listEtapeSimu
        ListElement{ _x:25 ;  _y:100; index : 0; _color : "steelblue"; _nom : "Etape"; _dateMax:0;
            _deadLine : 0; _nbPoints : 0; _sequenceName: ""; _tempsMax : 0; _tempsMoyen : 0}
    }

    Image {
        id: name
        height:(2/3) * width
        anchors.left: parent.left
        anchors.leftMargin: 50
        anchors.right: parent.right
        anchors.rightMargin: 550
        anchors.top:parent.top
        anchors.topMargin: 100
        source: fileRoot + applicationDirPath + "/data/table.png"

        Rectangle
        {
            id:robot
            property bool stepOk : false
            x: 0
            y: 0
            z: 3
            height: 15
            width: 15
            radius: 15
            color:  "steelblue"
        }
        Repeater
        {
            id:repeater
            model:listEtapeSimu
            anchors.fill: parent
            Rectangle
            {
                id:rectEtape
                property bool stepOk : false
                x: ( _x + 1500 ) * ( name.width / 3000) - width / 2
                y: ( _y * ( name.height / 2000 ) ) - height / 2
                z: 3
                height: 15
                width: 15
                radius: 15
                border.color: etapeEnCours===step?"pink":"transparent"
                border.width: 2
                color: _color
                onXChanged:
                {
                    if(stepOk === true)
                    {
                        step.x = Math.round((x + rectEtape.width / 2) * 3000 / name.width - 1500)
                    }
                }
                onYChanged:
                {
                    if(stepOk === true)
                    {
                        step.y = Math.round((y + rectEtape.height / 2) * 2000 / name.height)

                    }
                }

                MouseArea
                {
                    anchors.fill: parent
                    drag.target: parent;
                    propagateComposedEvents:true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onPressed:
                    {
                        console.log(step.x,step.y)
                        etapeEnCours = step
                        if(mouse.button === Qt.RightButton)
                        {
                            contextMenuDeleteEtape.popup()
                        }
                    }

                    Menu
                    {
                        id: contextMenuDeleteEtape
                        MenuItem
                        {
                            text: "Supprimer étape"
                            onClicked:
                            {
                                gestSimu.deleteEtape(step)
                            }
                        }
                    }

                    Etape
                    {
                        id:step
                        color:_color
                        x:_x
                        y:_y
                        nomEtape: _nom
                        dateMax: _dateMax
                        deadline: _deadLine
                        nbPoints: _nbPoints
                        nameSequence: _sequenceName
                        tempsMax: _tempsMax
                        tempsMoyen: _tempsMoyen
                        onHide:
                        {
                            rectEtape.visible = false
                        }

                        Component.onCompleted:
                        {
                            gestSimu.addEtape(step)
                            stepOk = true
                        }

                        onXModified: rectEtape.x = ( x + 1500 ) * ( name.width / 3000) - (rectEtape.width / 2 )
                        onYModified: rectEtape.y = ( y * ( name.height / 2000 ) ) - rectEtape.height / 2
                    }
                }

                function addTaux(param, cond, value, ratio)
                {
                    step.addItemTaux()
                    step.setParamTaux(step.getNbTaux()-1, param)
                    step.setCondTaux(step.getNbTaux()-1, cond)
                    step.setValueTaux(step.getNbTaux()-1, value)
                    step.setRatioTaux(step.getNbTaux()-1, ratio)
                }
            }
        }
    }

    SimuDashBoard
    {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: name.right
        anchors.leftMargin: 0
    }
}
