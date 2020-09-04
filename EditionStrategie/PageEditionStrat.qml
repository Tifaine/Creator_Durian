import QtQuick 2.0
import etape 1.0
import position 1.0

Item {
    width: 900
    height: 600
    id:mainItem
    property var etapeSelected: 0
    property var positionSelected: 0
    property bool isStepShowed      : true
    property bool isPositionShowed  : false
    property bool isPositionModeOn : false
    property bool isDragEnabled : true

    Component.onCompleted:
    {
        listRepeaterEtape.clear()
        listRepeaterPosition.clear()


    }

    function addEtape(x, y, colorEtape, nom, dateMax, deadline,
                      nbPoints, sequenceName, tempsMax, tempsMoyen)
    {
        listRepeaterEtape.append({"_x" : x, "_y" : y, index : listRepeaterEtape.count,
                                     "_color" : colorEtape, "_nom" : nom,
                                     "_dateMax" : dateMax, "_deadLine" : deadline,
                                     "_nbPoints" : nbPoints,"_sequenceName" : sequenceName,
                                     "_tempsMax" : tempsMax, "_tempsMoyen" : tempsMoyen})

    }

    ListModel
    {
        id:listRepeaterEtape
        ListElement{ _x : 100 ; _y : 100 ; _nom:"Deplacement" ; index : 0; _color:"#00ffffff"; colorEtape: "white"; _dateMax:0;
            _deadLine : 0; _nbPoints : 0; _sequenceName: ""; _tempsMax : 0; _tempsMoyen : 0}
    }

    Repeater
    {

        id:repeaterEtape
        model:listRepeaterEtape
        anchors.fill: parent
        Rectangle
        {
            objectName: "Etape"
            x:_x
            y:_y
            visible:isStepShowed===true?true:false
            width:15
            height:15
            radius: 15
            color:_color
            border.width: 1
            border.color:etapeSelected === etape ? "white":"transparent"
            onXChanged:
            {
                for(var i = 0; i < etape.getNbPositionLiee(); i++)
                {
                    etape.getPosition(i).mustUpdateLiaison()
                }
            }
            onYChanged:
            {
                for(var i = 0; i < etape.getNbPositionLiee(); i++)
                {
                    etape.getPosition(i).mustUpdateLiaison()
                }
            }

            Etape
            {
                id:etape
                x:parent.x
                y:parent.y
                color:_color
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
                drag.target: isDragEnabled ? parent : undefined
                propagateComposedEvents:true

                onPressed:
                {
                    if(positionSelected !== 0 && isPositionModeOn)
                    {
                        if(positionSelected.containsEtape(etape) === false)
                        {
                            etape.addPositionLiee(positionSelected)
                            positionSelected.addEtapeLiee(etape)
                            positionSelected.mustUpdateLiaison()
                        }
                    }

                    etapeSelected = etape
                    positionSelected = 0
                }
                onReleased:
                {

                }

            }
        }
    }

    function addPosition(x, y)
    {
        listRepeaterPosition.append({"_x" : x, "_y" : y, "_index" : listRepeaterPosition.count})
        listRepeaterCanvas.append({ "_index" : listRepeaterCanvas.count })
    }

    ListModel
    {
        id:listRepeaterPosition
        ListElement{ _x : 100 ; _y : 100 ; _index : 0}
    }

    ListModel
    {
        id:listRepeaterCanvas
        ListElement{ _index : 0}
    }

    function drawAxis(id, x1, y1, x2, y2, color)
    {
        var context = repeaterCanvas.itemAt(id).getContext("2d")
        context.lineWidth = 2
        context.strokeStyle = color
        context.beginPath()
        context.moveTo(x1, y1)
        context.lineTo(x2, y2)
        context.stroke()                      // <--- lines are drawn here!
        repeaterCanvas.itemAt(id).update()
        repeaterCanvas.itemAt(id).requestPaint()
    }

    Repeater
    {

        id:repeaterPosition
        model:listRepeaterPosition
        anchors.fill: parent
        Rectangle
        {
            x:_x
            y:_y
            objectName: "Position"
            width:15
            height:15
            radius: 15
            visible:isPositionShowed===true?true:false
            color:"steelblue"
            border.width: 1
            border.color:positionSelected === position ? "white":"transparent"
            onXChanged:
            {
                editLiaison()
            }
            onYChanged:
            {
                editLiaison()
            }

            Position
            {
                id:position
                x:parent.x
                y:parent.y
                anchors.fill: parent
                index: _index
                onMustUpdateLiaison: editLiaison()
            }

            function editLiaison()
            {
                if(repeaterCanvas.itemAt(position.index).available)
                {
                    repeaterCanvas.itemAt(position.index).getContext("2d").reset()
                    for(var i = 0; i < position.getNbPositionLiee(); i++)
                    {
                        if( position.getPosition(i).index > position.index)
                        {
                            drawAxis(position.index, position.x + 7, position.y + 7, position.getPosition(i).x + 7, position.getPosition(i).y + 7, "blue")
                        }else
                        {
                            position.getPosition(i).mustUpdateLiaison()
                        }
                    }
                    for(var j = 0; j < position.getNbEtapeLiee(); j++)
                    {
                        drawAxis(position.index, position.x + 7, position.y + 7, position.getEtape(j).x + 7, position.getEtape(j).y + 7, "red")
                    }
                }
            }

            MouseArea
            {
                anchors.fill: parent
                drag.target: parent;
                acceptedButtons: Qt.AllButtons
                propagateComposedEvents:true
                onPressed:
                {
                    if(positionSelected !== 0 && positionSelected !== position && isPositionModeOn)
                    {
                        if(positionSelected.containsPosition(position) === false)
                        {
                            positionSelected.addPositionLiee(position)
                            position.addPositionLiee(positionSelected)
                            editLiaison();
                        }
                    }

                    etapeSelected = 0
                    positionSelected = position
                }
                onReleased:
                {

                }
            }
        }
    }

    Repeater
    {

        id:repeaterCanvas
        model:listRepeaterPosition
        anchors.fill: parent
        Canvas
        {
            id:myCanvas
            visible:isPositionShowed===true?true:false
            anchors.fill: parent
        }
    }
}
