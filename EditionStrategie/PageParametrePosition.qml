import QtQuick 2.0
import QtQuick.Controls 2.13
import QtQuick.Extras 1.4

Item
{
    id: element1
    width:585
    height:800
    property var mPosition: 0
    property bool isModePositionOn: buttonModePosition.checked
    visible:false

    function updateVisibility(isPositionShowed)
    {
        if(!isPositionShowed)
        {
            element1.visible = false;
        }else
        {
            if(mPosition !== 0)
            {
                element1.visible = true
            }else
            {
                element1.visible = false
            }
        }
    }
    function updateParam(position)
    {
        mPosition = position
    }

    Rectangle
    {
        width:1
        color:"white"
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 0
    }

    Text {
        id: element
        color: "#ffffff"
        text: qsTr("Paramètres position")
        font.bold: true
        anchors.left: parent.left
        anchors.leftMargin: 25
        anchors.top: parent.top
        anchors.topMargin: 40
        font.pixelSize: 15
    }

    ToggleButton {
        id: buttonModePosition
        x: 423
        width: 100
        height: 100
        text: qsTr("Mode position")
        anchors.right: parent.right
        anchors.rightMargin: 25
        anchors.top: parent.top
        anchors.topMargin: 25
    }

}
