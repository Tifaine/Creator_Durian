import QtQuick 2.0
import QtQuick.Controls 2.12
import etape 1.0

Item {
    id:item
    property var stepName : "Init"
    signal etapeSelected(var etape)

    Etape
    {
        id:step
        nomEtape: stepName
        xEtape: Math.round( ((parent.x + rect.width / 2) * 3000 / 900) - 1500 )
        yEtape: Math.round( (parent.y + rect.height / 2) * 2000 / 600)
        Component.onCompleted: gestEtape.addEtape(step)
    }

    Rectangle
    {
        id:rect
        width: 15
        height: 15
        radius: 15
        color:"yellow"


        ToolTip.visible: false

        MouseArea
        {
            property bool toolTipAvailable: true
            anchors.fill: parent
            hoverEnabled: true
            drag.target: item;
            onEntered:
            {
                if(toolTipAvailable === true)
                    ToolTip.show(gestEtape.getEtape(gestEtape.getIndiceEtape(step)).description)
            }
            onExited:
            {
                ToolTip.hide()
            }
            onPressed:
            {
                toolTipAvailable = false
                ToolTip.hide()
            }
            onReleased:
            {
                toolTipAvailable = true
            }
            onClicked:
            {
                etapeSelected(step)
            }
        }
    }
}
