import QtQuick 2.0
import QtQuick.Controls 2.12


Item {
    property var stepName : "Init"

    Rectangle
    {

        width: 15
        height: 15
        radius: 15
        color:"yellow"


        ToolTip.visible: false

        MouseArea
        {
            anchors.fill: parent
            hoverEnabled: true
            onEntered:
            {
                ToolTip.show(stepName)
            }
            onExited:
            {
                ToolTip.hide()
            }
        }
    }
}
