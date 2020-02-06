import QtQuick 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.2
import gestionSequence 1.0

Item {

    function addAction(index)
    {
        listAction.append({_indiceAction:index, index:listAction.count, _color:"#00ffffff"})
    }

    function save(nomfile)
    {
        gestSequence.save(nomfile)
    }

    function open(nomFile)
    {
        listAction.clear()
        gestSequence.clearAction()
        sortieClick = -1
        timeoutClick = -1
        entreeClick = -1
        gestSequence.open(nomFile)
    }

    ListModel
    {
        id:listAction
        ListElement{ _indiceAction:-1 ; index : 0; _color:"#00ffffff"}
    }

    Component.onCompleted:
    {
        listAction.clear()
        gestSequence.clearAction()
    }

    GestionSequence
    {
        id: gestSequence
    }

    property var sortieClick : -1
    property var timeoutClick : -1
    property var entreeClick : -1
    Flickable
    {
        clip:true
        id: flickable
        flickableDirection: Flickable.HorizontalAndVerticalFlick
        //flickableDirection: Flickable.
        anchors.fill: parent
        contentWidth: 15000; contentHeight: 15000
        contentX: 0
        contentY:0

        ScrollBar.vertical: ScrollBar {
            parent: flickable.parent
            anchors.top: flickable.top
            anchors.right: flickable.right
            anchors.bottom: flickable.bottom
        }
        ScrollBar.horizontal: ScrollBar {
            parent: flickable.parent
            anchors.left: flickable.left
            anchors.right: flickable.right
            anchors.bottom: flickable.bottom
        }
        Rectangle
        {
            id:rectangle5
            anchors.fill: parent
            color:"transparent"

            property int behaviorSelected:-1

            MouseArea
            {
                propagateComposedEvents: true
                anchors.fill: parent
                hoverEnabled: true
                onMouseXChanged:
                {
                    if(sortieClick !== -1)
                    {
                        sortieClick.moveConnectorFather(mouseX - (sortieClick.parent.x + sortieClick.xFather - 10),
                                                        mouseY - (sortieClick.parent.y + sortieClick.yFather - 10))
                    }else if(timeoutClick !== -1)
                    {
                        timeoutClick.moveConnectorTimeout(mouseX - (timeoutClick.parent.x + timeoutClick.xFather -10),
                                                          mouseY - (timeoutClick.parent.y + timeoutClick.yFather))
                    }
                }
                onMouseYChanged:
                {
                    if(sortieClick !== -1)
                    {
                        sortieClick.moveConnectorFather(mouseX - (sortieClick.parent.x + sortieClick.xFather - 10),
                                                        mouseY - (sortieClick.parent.y + sortieClick.yFather - 10))
                    }else if(timeoutClick !== -1)
                    {
                        timeoutClick.moveConnectorTimeout(mouseX - (timeoutClick.parent.x + timeoutClick.xFather - 10),
                                                          mouseY - (timeoutClick.parent.y + timeoutClick.yFather))
                    }
                }

                onClicked:
                {
                    if(sortieClick !== -1)
                    {
                        sortieClick.moveConnectorFather(0,0)
                    }else if(timeoutClick !== -1)
                    {
                        timeoutClick.moveConnectorTimeout(0,0)
                    }
                    entreeClick = -1
                    sortieClick = -1
                    timeoutClick = -1
                }
            }


            Repeater
            {
                id:repeaterListAction
                model:listAction
                anchors.fill: parent
                BlocAction
                {
                    id:act
                    Component.onCompleted:
                    {
                        init(_indiceAction)
                        gestSequence.addAction(act.action)
                    }
                    onEntreeClicked:
                    {
                        if(sortieClick !== -1)
                        {
                            if(sortieClick.addGirlToFather(action) === true)
                            {
                                sortieClick.parent.addAFather()
                            }
                            action.addFatherToGirl(sortieClick)
                        }else if(timeoutClick !== -1)
                        {
                            if(timeoutClick.addGirlToTimeout(action) === true)
                            {
                                timeoutClick.parent.addATimeOut()
                            }
                            action.addFatherToGirl(timeoutClick)

                        }

                        sortieClick = -1
                        timeoutClick = -1

                    }
                    onSortieClicked:
                    {
                        sortieClick = action
                        timeoutClick = -1
                    }
                    onTimeOutClicked:
                    {
                        sortieClick = -1
                        timeoutClick = action
                    }
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
