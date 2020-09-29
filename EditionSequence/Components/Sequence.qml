import QtQuick 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.2
import gestionSequence 1.0

Item {
    id:item1
    focus:visible===true?true:false
    function addAction(index)
    {
        listAction.append({_indiceAction:index, index:listAction.count, _color:"#00ffffff", _x:flickable.contentX, _y:flickable.contentY})
    }

    function save(nomfile)
    {
        gestSequence.save(nomfile)
    }

    property bool ctrl_pressed: false
    Keys.onPressed:
    {
        if (event.key === Qt.Key_Control)
        {
            ctrl_pressed = true
            event.accepted = true;
        }else if (event.key === Qt.Key_M)
        {
            if(ctrl_pressed)
            {
                if(rectParent.scale > 0.2)
                {
                    mXScale -= 0.2
                    mYScale -= 0.2
                }

            }
        }else if (event.key === Qt.Key_P)
        {
            if(ctrl_pressed)
            {
                mXScale += 0.2
                mYScale += 0.2
            }
        }else if (event.key === Qt.Key_R)
        {
            if(ctrl_pressed)
            {
                mXScale = 1
                mYScale = 1
            }
        }
    }
    Keys.onReleased:
    {
        if (event.key === Qt.Key_Control)
        {
            ctrl_pressed = false
            event.accepted = true;
        }
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
        ListElement{ _indiceAction:-1 ; index : 0; _color:"#00ffffff"; _x : 0; _y : 0}
    }

    Component.onCompleted:
    {
        listAction.clear()
        gestSequence.clearAction()
    }

    GestionSequence
    {
        id: gestSequence
        onCreateNewAction:
        {
            listAction.append({_indiceAction:gestAction.getIndiceByName(nomAction), index:listAction.count, _color:"#00ffffff", _x:xBloc, _y:yBloc})
        }
        onUpdateParam:
        {
            if(lastActionCreate !== -1)
            {
                lastActionCreate.updateParam(indiceParam, value)
            }
        }
        onAjoutFille:
        {
            repeaterListAction.itemAt(indicePere).action.addGirlToFather(repeaterListAction.itemAt(indiceFille).action)
            repeaterListAction.itemAt(indicePere).addAFather();
            repeaterListAction.itemAt(indiceFille).action.addFatherToGirl(repeaterListAction.itemAt(indicePere).action)
        }
        onAjoutTimeout:
        {
            repeaterListAction.itemAt(indicePere).action.addGirlToTimeout(repeaterListAction.itemAt(indiceTimeout).action)
            repeaterListAction.itemAt(indicePere).addATimeOut();
            repeaterListAction.itemAt(indiceTimeout).action.addFatherToGirl(repeaterListAction.itemAt(indicePere).action)
        }
    }

    property var sortieClick : -1
    property var timeoutClick : -1
    property var entreeClick : -1
    property var lastActionCreate : -1
    property var mXScale:1
    property var mYScale:1
    Rectangle
    {
        anchors.fill: parent
        id:rectParent
        color:"transparent"

        Flickable
        {
            clip:true
            id: flickable
            flickableDirection: Flickable.HorizontalAndVerticalFlick
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
                transform: Scale { origin.x: 0; origin.y: 0; xScale: mXScale; yScale: mYScale}
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
                        parent.focus = true
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
                        x: _x
                        y: _y
                        Component.onCompleted:
                        {
                            init(_indiceAction)
                            gestSequence.addAction(act.action)
                            lastActionCreate = act
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
                        onHaraKiri:
                        {
                            for(var i = index+1 ;i < listAction.count; i++)
                            {
                                listAction.set(i, {"index": i-1})
                            }
                            gestSequence.eraseAction(act.action)
                            listAction.remove(index)
                        }
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
