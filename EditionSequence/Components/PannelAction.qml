import QtQuick 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.2
import action 1.0

Item {
    id: element
    width: 150
    height: 800
    signal creerAction(int indiceAction)

    Connections
    {
        target:gestAction
        onActionsUpdated:
        {
            listAction.clear()
            for(var i = 0; i < gestAction.getNbAction(); i++)
            {
                listAction.append({_nom:gestAction.getNameAction(i), index:listAction.count, _color:"#00ffffff"})
            }
        }
    }

    Rectangle
    {
        id:rectSep
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        color:"white"
        width:1
    }

    ListModel
    {
        id:listAction
        ListElement{ _nom:"Deplacement" ; index : 0; _color:"#00ffffff"}
    }

    Flickable
    {
        clip:true
        id: flickable
        anchors.topMargin: 5
        flickableDirection: Flickable.VerticalFlick
        anchors.fill: element
        contentWidth: parent.width; contentHeight: 5000
        contentX: 0
        contentY:0

        ScrollBar.vertical: ScrollBar {
            parent: flickable.parent
            anchors.top: flickable.top
            anchors.right: flickable.right
            anchors.bottom: flickable.bottom
        }
        Rectangle
        {
            id:rectangle5
            anchors.fill: parent
            color:"transparent"
            anchors.rightMargin: 5

            function updateColor(indice)
            {

                listAction.setProperty(indice,"_color","#300000");
                if(behaviorSelected !== -1 && indice !== behaviorSelected)
                {
                    listAction.setProperty(behaviorSelected,"_color","#00ffffff");
                }

                behaviorSelected = indice
            }

            property int behaviorSelected:-1
            Repeater
            {
                id:repeaterListAction
                model:listAction
                anchors.fill: parent
                Rectangle
                {
                    id:rect
                    width: 100
                    height:40
                    color:_color
                    radius: 10
                    border.color: "#ffffff"
                    border.width: 1
                    anchors.left: repeaterListAction.left
                    anchors.leftMargin: 5
                    anchors.right: repeaterListAction.right
                    anchors.rightMargin: 5
                    anchors.top: repeaterListAction.top
                    anchors.topMargin:index*45

                    Rectangle
                    {
                        color: _color//"#0cfdfdfd"
                        radius: 10
                        anchors.right: parent.right
                        anchors.rightMargin: 1
                        anchors.left: parent.left
                        anchors.leftMargin: 1
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 1
                        anchors.top: parent.top
                        anchors.topMargin: 1
                        Text {
                            id: nomComportement
                            text: _nom
                            color:"white"
                            anchors.fill: parent
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        }

                        MouseArea
                        {
                            anchors.fill: parent
                            z:1
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked:
                            {
                                rectangle5.updateColor(index)
                                if(mouse.button === Qt.RightButton)
                                {
                                    contextMenu.popup()
                                }
                            }
                        }
                        Menu
                        {
                            id: contextMenu
                            MenuItem
                            {
                                text: "Ajouter action"
                                onClicked:
                                {
                                    creerAction(index)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
