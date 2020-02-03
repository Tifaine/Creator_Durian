import QtQuick 2.0

Item {
    id:element
    width:150
    height:80
    Rectangle
    {
        anchors.fill: parent
        color:"steelblue"
        MouseArea
        {
            anchors.fill: parent
            drag.target: element;
            propagateComposedEvents:true
            onClicked: console.log("hep")
        }
    }
}
