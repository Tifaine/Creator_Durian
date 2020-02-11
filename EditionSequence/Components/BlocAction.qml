import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import editableAction 1.0
import Qt.labs.folderlistmodel 2.12
import connector 1.0

Item {
    id:element
    width:0
    height:80
    onXChanged: editAction.xBloc = x
    onYChanged: editAction.yBloc = y

    property var action : editAction


    signal entreeClicked(var action)
    signal sortieClicked(var action)
    signal timeOutClicked(var action)
    signal haraKiri();

    function addATimeOut()
    {
        listConnectorTimeOut.append({_xB:0, _yB:0, color:"#ff0000"})
    }

    function addAFather()
    {
        listConnectorFather.append({_xB:0, _yB:0, color:"steelblue"})
    }

    Connections
    {
        target:gestSequence
        onListFilesChanged:updateListAliasForSequence()
    }

    function updateListAliasForSequence()
    {
        listAlias.clear()
        for(var i = 0; i < gestSequence.getNbSequence(); i++)
        {
            listAlias.append({_nom:"Nom", value:gestSequence.getNomSequence(i)})
        }
    }

    ListModel
    {
        id:listAlias
        ListElement{ _nom:"x" ; value:"0"}
    }

    function updateParam(indiceParam, value)
    {
        if( testNom.text === "Sequence")
        {

        }

        listParam.set(indiceParam, {"value": value})
    }

    MouseArea
    {
        anchors.fill: parent
        drag.target: element;
        propagateComposedEvents:true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onPressed:
        {

            if(mouse.button === Qt.RightButton)
            {
                contextMenuDeleteAction.popup()
            }
        }
    }
    Menu
    {
        id: contextMenuDeleteAction
        MenuItem
        {
            text: "Supprimer action"
            onClicked:
            {
                editAction.prepareToErase()
                haraKiri()
            }
        }
    }

    EditableAction
    {
        id:editAction
        xBloc: element.x
        yBloc: element.y
        xFather : blocSortie.x + blocSortie.width/2
        yFather : blocSortie.y + blocSortie.width/2
        xTimeOut : bloctimeOut.x + bloctimeOut.width/2
        yTimeOut : bloctimeOut.y + bloctimeOut.width/2
        xEntree : blocEntree.x + blocEntree.width/2
        yEntree : blocEntree.y + blocEntree.width/2
        onEraseAFather: listConnectorFather.remove(0)
        onEraseATimeout: listConnectorTimeOut.remove(0)
    }

    function init(indiceAction)
    {

        if(indiceAction !== -1)
        {
            editAction.init(gestAction.getAction(indiceAction))
            if( indiceAction === 0 || indiceAction === 1 )
            {
                element.width = 70
                if(indiceAction === 0)
                {
                    blocEntree.enabled = false
                    blocEntree.visible = false
                }else
                {
                    blocSortie.enabled = false
                    blocSortie.visible = false

                    bloctimeOut.enabled = false
                    bloctimeOut.visible = false
                }
            }else
            {
                element.width = 300
            }

            element.height = 26 + gestAction.getNbParameter(indiceAction)*40
            testNom.text = gestAction.getNameAction(indiceAction)

            if(gestAction.getIsActionBlocante(indiceAction)=== 1)
            {
                fondEntete.color = "#4d0000"
                blocSortie.anchors.topMargin = 5
                bloctimeOut.enabled = true
                bloctimeOut.visible = true
            }else
            {
                fondEntete.color = "transparent"
                bloctimeOut.enabled = false
                bloctimeOut.visible = false
            }
            listParam.clear()
            for ( var i = 0; i < gestAction.getNbParameter(indiceAction); i++)
            {
                listParam.append({_nom:gestAction.getNomParam(indiceAction, i), index:listParam.count, value:gestAction.getDefaultValueParam(indiceAction,i)})
                repeaterParameter.itemAt(listParam.count-1).fillAlias(indiceAction, i)
            }
        }
    }

    Rectangle {
        id: fond
        color: "#0cfdfdfd"
        radius: 10
        border.width: 1
        border.color: "#ffffff"
        anchors.fill: parent

        Rectangle {
            id: fondEntete
            height: 25
            radius: 10
            border.width: 0
            anchors.right: parent.right
            anchors.rightMargin: 1
            anchors.left: parent.left
            anchors.leftMargin: 1
            anchors.top: parent.top
            anchors.topMargin: 1

            Rectangle {
                id: separationHeader
                height: 1
                color: "white"
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
            }

            Text {
                id: testNom
                color:"white"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                font.bold: true
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                font.pixelSize: 14
            }
        }

        ListModel
        {
            id:listParam
            ListElement{ _nom:"x" ; value:"0" ; index : 0}
        }

        Repeater
        {
            id:repeaterParameter
            anchors.top: fondEntete.bottom
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.topMargin: 0
            model:listParam

            Rectangle
            {
                id:rect
                height:35
                color:"transparent"
                anchors.right: repeaterParameter.right
                anchors.rightMargin: 0
                anchors.left: repeaterParameter.left
                anchors.leftMargin: 0
                anchors.top: index>0?repeaterParameter.itemAt(index-1).bottom:repeaterParameter.top
                anchors.topMargin:2

                Text {
                    id: textFieldNomParam
                    text: _nom
                    color:"white"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    font.pixelSize: 16
                    anchors.right: parent.right
                    anchors.rightMargin: 2*parent.width/3
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin:2
                    anchors.bottom: parent.bottom
                }
                TextField {
                    id: textFieldDefaultValue
                    text: value
                    height:33
                    font.pixelSize: 16
                    anchors.right: parent.right
                    anchors.rightMargin:5
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width/3+5

                    anchors.top: parent.top
                    anchors.topMargin:2
                    color: "white"
                    background: Rectangle {
                        color:"#22ffffff"
                        radius: 10
                        implicitWidth: 100
                        implicitHeight: 24
                        border.color: "#333"
                        border.width: 1
                    }
                    onTextChanged:
                    {
                        editAction.setValueDefaultParam(index, text)
                    }
                }

                function fillAlias(indiceAct, indicePar)
                {
                    listAlias.clear()
                    if(testNom.text === "Sequence")
                    {
                        element.height = element.height + 40
                        rect.height = rect.height + 40
                        textFieldDefaultValue.anchors.top = controlAlias.bottom
                        updateListAliasForSequence()

                    }else
                    {

                        if(gestAction.getNbAlias(indiceAct, indicePar) > 0)
                        {
                            element.height = element.height + 40
                            rect.height = rect.height + 40
                            textFieldDefaultValue.anchors.top = controlAlias.bottom
                        }else
                        {
                            controlAlias.visible = false
                        }

                        for (var i = 0; i < gestAction.getNbAlias(indiceAct, indicePar); i++)
                        {
                            listAlias.append({_nom:gestAction.getNomAlias(indiceAct, indicePar, i), value:gestAction.getValueAlias(indiceAct, indicePar, i)})
                        }
                    }
                }

                ComboBox {
                    id: controlAlias
                    height: 40
                    model:listAlias
                    anchors.right: parent.right
                    anchors.rightMargin:5
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width/3+5

                    anchors.top: parent.top
                    anchors.topMargin:2
                    currentIndex: 0
                    onCurrentIndexChanged:
                    {
                        if(listAlias.count > currentIndex && currentIndex !== -1)
                        {
                            displayText = listAlias.get(currentIndex).value
                            textFieldDefaultValue.text = displayText
                        }
                    }

                    delegate: ItemDelegate {
                        width: controlAlias.width
                        contentItem: Text {
                            text: (_nom + "("+value+")")
                            color: "white"
                            font: controlAlias.font
                            elide: Text.ElideRight
                            verticalAlignment: Text.AlignVCenter
                        }
                        highlighted: controlAlias.highlightedIndex === index
                        background: Rectangle {
                            implicitWidth: 120
                            implicitHeight: 40
                            color:controlAlias.highlightedIndex === index ? "#262626" : "transparent"
                        }
                    }

                    indicator: Canvas {
                        id: canvas
                        x: controlAlias.width - width - controlAlias.rightPadding
                        y: controlAlias.topPadding + (controlAlias.availableHeight - height) / 2
                        width: 12
                        height: 8
                        contextType: "2d"

                        Connections {
                            target: controlAlias
                            onPressedChanged: canvas.requestPaint()
                        }

                        onPaint: {
                            context.reset();
                            context.moveTo(0, 0);
                            context.lineTo(width, 0);
                            context.lineTo(width / 2, height);
                            context.closePath();
                            context.fillStyle = controlAlias.pressed ? "#4d0000" : "#660000";
                            context.fill();
                        }
                    }

                    contentItem: Text {
                        leftPadding: 10
                        rightPadding: controlAlias.indicator.width + controlAlias.spacing

                        text: controlAlias.displayText
                        font: controlAlias.font
                        color: "white"
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    background: Rectangle {
                        implicitWidth: 120
                        implicitHeight: 40
                        color:"#262626"
                        border.color: controlAlias.pressed ? "#4d0000" : "#66000"
                        border.width: controlAlias.visualFocus ? 2 : 1
                        radius: 2
                    }

                    popup: Popup {
                        y: controlAlias.height - 1
                        width: controlAlias.width
                        implicitHeight: contentItem.implicitHeight
                        padding: 1

                        contentItem: ListView {
                            clip: true
                            implicitHeight: contentHeight
                            model: controlAlias.popup.visible ? controlAlias.delegateModel : null
                            currentIndex: controlAlias.highlightedIndex

                            ScrollIndicator.vertical: ScrollIndicator { }
                        }

                        background: Rectangle {
                            border.color: "#4d0000"
                            color:"#363636"
                            radius: 2
                        }
                    }
                }
            }
        }
    }

    Rectangle
    {
        id:blocEntree
        color:"green"
        width: 10
        height: 10
        radius: 5
        anchors.right: parent.left
        anchors.rightMargin: -5
        anchors.top: parent.top
        anchors.topMargin: 10
        MouseArea
        {
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            anchors.fill: parent
            onClicked:
            {
                if(mouse.button === Qt.RightButton)
                {
                    listConnectorDelete.clear()
                    for(var i = 0; i < editAction.getNbPapa(); i++)
                    {
                        listConnectorDelete.append({_text:editAction.getNomPapa(i), index: listConnectorDelete.count})
                    }

                    contextMenuDeleteConnector.popup()
                }else
                    entreeClicked(editAction)
            }

            ListModel
            {
                id:listConnectorDelete
                ListElement{_text:"Boop"; index : 0}
            }

            Menu
            {
                id: contextMenuDeleteConnector
                Repeater
                {
                    model:listConnectorDelete
                    MenuItem
                    {
                        id:item
                        text:_text
                        onClicked: editAction.abandonnerPere(index)
                        Component.onCompleted: contextMenuDeleteConnector.addItem(item)
                    }
                }
            }
        }
    }

    ListModel
    {
        id:listConnectorFather
        ListElement{_xB:0 ; _yB:0; color:"steelblue"}
    }

    Rectangle
    {
        id:blocSortie
        color: "#ff0000"
        width: 10
        height: 10
        radius: 5
        anchors.left: parent.right
        anchors.leftMargin: -5
        anchors.top: parent.top
        anchors.topMargin: 10
        MouseArea
        {
            anchors.fill: parent
            onClicked: sortieClicked(editAction)
        }
        Repeater
        {
            id:repeaterConnectorFather
            model:listConnectorFather
            Connector
            {
                id:conn
                x1: blocSortie.width/2
                y1: blocSortie.height/2
                x2: _xB
                y2 : _yB
                _color: color
                Component.onCompleted: editAction.addConnectorToFather(conn)
            }
        }
    }

    ListModel
    {
        id:listConnectorTimeOut
        ListElement{_xB:0 ; _yB:0; color:"#ff0000"}
    }

    Rectangle
    {
        id:bloctimeOut
        color: "yellow"
        width: 10
        height: 10
        radius: 5
        anchors.left: parent.right
        anchors.leftMargin: -5
        anchors.top: parent.top
        anchors.topMargin: 20
        MouseArea
        {
            anchors.fill: parent
            onClicked: timeOutClicked(editAction)
        }

        Repeater
        {
            id:repeaterConnectorTimeout
            model:listConnectorTimeOut
            Connector
            {
                id:connec
                x1: bloctimeOut.width/2
                y1: bloctimeOut.height/2
                x2: _xB
                y2 : _yB
                _color: color

                Component.onCompleted: editAction.addConnectorToTimeOut(connec)
            }
        }
    }
}
