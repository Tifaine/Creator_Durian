import QtQuick 2.0
import QtCharts 2.3

Item {
    id: element
    width: 1500
    height: 800

    Graph {
        id: graph
        anchors.right: parent.right
        anchors.rightMargin: 795
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 150
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 150

    }

    BandeauHaut
    {
        id:bandeauHaut
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.bottom: graph.top
        anchors.bottomMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
    }

    PanneauControleVitesse
    {
        anchors.left: graph.right
        anchors.leftMargin: 0
        anchors.top: bandeauHaut.bottom
        anchors.topMargin: 0
    }


}

/*##^##
Designer {
    D{i:1;anchors_height:500;anchors_width:700;anchors_x:13;anchors_y:147}
}
##^##*/
