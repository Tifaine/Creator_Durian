import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.13

Item {
    id: element
    height:800
    width:100
    signal changeAffichage(var nb)
    property int indiceAffiche:0
    Column {
        id: column
        width: 100
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        ListModel
        {
            id:listModel            
            ListElement{ _nom:"Définir Stratégie" ;     index : 0 }
            ListElement{ _nom:"Édition étape" ;         index : 1 }
            ListElement{ _nom:"Édition Sequence" ;      index : 2 }
            ListElement{ _nom:"Édition Action" ;        index : 3 }
            ListElement{ _nom:"Réglages Roboclaw" ;     index : 4 }
            ListElement{ _nom:"Réglages Dynamixel" ;    index : 5 }
            ListElement{ _nom:"Simulation" ;            index : 6 }
        }

        Repeater
        {
            id:repeater
            model:listModel
            anchors.fill: parent

            ColumnLayout {
                id: rowLayout
                width: 100
                height: column.height/listModel.count

                MouseArea
                {
                    id: mouseArea1
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    onClicked:
                    {
                        element.indiceAffiche=index
                        element.changeAffichage(index)
                    }
                    Rectangle {
                        id: rectangle4
                        color:indiceAffiche==index?"#262626":"transparent"
                        anchors.bottomMargin: 1
                        anchors.fill: parent
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }
                    Text {
                        id: element2
                        text: _nom
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        font.pixelSize: 12
                        color:indiceAffiche==index?"white":"white"
                    }

                    Rectangle {
                        id: rectangle2
                        height: 1
                        color: "white"
                        anchors.right: parent.right
                        anchors.rightMargin: 0
                        anchors.left: parent.left
                        anchors.leftMargin: 0
                        anchors.top: rectangle4.bottom
                        anchors.topMargin: 0
                        Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                        Layout.preferredHeight: 1
                        Layout.fillWidth: true
                    }

                }
            }

        }

    }
}
