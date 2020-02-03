import QtQuick 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.2

Item {

    function addAction()
    {
        listAction.append({_nom:"boop", index:listAction.count, _color:"#00ffffff"})
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
            Repeater
            {
                id:repeaterListAction
                model:listAction
                anchors.fill: parent
                BlocAction
                {

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
